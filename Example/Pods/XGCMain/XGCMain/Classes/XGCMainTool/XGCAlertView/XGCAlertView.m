//
//  XGCAlertView.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/26.
//

#import "XGCAlertView.h"
#import "XGCConfiguration.h"
#import "XGCMainTextField.h"
#import "XGCEmptyTableView.h"
#import "NSString+XGCString.h"
#import "XGCAlertTableViewCell.h"
//
#import <M13OrderedDictionary/M13OrderedDictionary.h>

static CGFloat const XGCAlertViewToolBarHeight = 40.0;

@interface XGCAlertView ()<UITableViewDelegate, UITableViewDataSource>
// default 270.0(UITableView最大高度)
@property (nonatomic, assign) CGFloat XGCAlertViewTableViewHeight;
@property (nonatomic, strong) UIControl *backgroundControl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) XGCMainTextField *textField;
@property (nonatomic, strong) XGCEmptyTableView *tableView;

/// 一维数组
@property (nonatomic, strong) NSMutableArray <XGCUserDictMapModel *> *delayeringTrees;
/// 搜索结果
@property (nonatomic, strong) NSArray <XGCUserDictMapModel *> *results;

@property (nonatomic, strong) M13MutableOrderedDictionary <NSString *, XGCUserDictMapModel *> *maps;

@property (nonatomic, assign, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, assign, getter=isEndPresented)   BOOL endPresented;
@property (nonatomic, assign, getter=isBeingDismissed) BOOL beingDismissed;
@end

@implementation XGCAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.XGCAlertViewTableViewHeight = 270.0;
        // UI
        self.backgroundControl = ({
            UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
            control.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
            [control addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            control;
        });
        self.containerView = ({
            CGFloat height = self.XGCAlertViewTableViewHeight + XGCAlertViewToolBarHeight;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - height, CGRectGetWidth(frame), height)];
            view.backgroundColor = UIColor.whiteColor;
            [self addSubview:view];
            view;
        });
        self.toolbar = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), XGCAlertViewToolBarHeight)];
            [self.containerView addSubview:view];
            view;
        });
        self.leftBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            button.frame = CGRectMake(10.0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.rightBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            button.frame = CGRectMake(CGRectGetWidth(self.toolbar.frame) - 44.0 - 10.0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button addTarget:self action:@selector(rightBarButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.titleLabel = ({
            CGFloat x = CGRectGetMaxX(self.leftBarButton.frame);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CGRectGetMinX(self.rightBarButton.frame) - x, CGRectGetHeight(self.toolbar.frame))];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [self.toolbar addSubview:label];
            label;
        });
        ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.toolbar.frame) - 1.0, CGRectGetWidth(self.toolbar.frame), 1.0)];
            view.backgroundColor = UIColor.groupTableViewBackgroundColor;
            [self.toolbar addSubview:view];
        });
        self.textField = ({
            XGCMainTextField *textField = [[XGCMainTextField alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY(self.toolbar.frame) + 10.0, CGRectGetWidth(frame) - 40.0, 30.0)];
            textField.layer.cornerRadius = 15.0;
            textField.placeholder = @"请输入关键字搜索";
            textField.textColor = XGCCMI.labelColor;
            textField.font = [UIFont systemFontOfSize:13];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.backgroundColor = XGCCMI.backgroundColor;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.contentInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
            [textField addTarget:self action:@selector(UITextFieldTextDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
            [self.containerView addSubview:textField];
            textField;
        });
        self.tableView = ({
            CGFloat y = CGRectGetMaxY(self.textField.frame) + 10.0;
            XGCEmptyTableView *tableView = [[XGCEmptyTableView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(frame), CGRectGetHeight(self.containerView.frame) - y) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.sectionHeaderHeight = 0;
            tableView.sectionFooterHeight = 0;
            if (@available(iOS 15.0, *)) {
                tableView.sectionHeaderTopPadding = 0;
            }
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            [tableView registerClass:[XGCAlertTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCAlertTableViewCell class])];
            [self.containerView addSubview:tableView];
            tableView;
        });
        self.delayeringTrees = [NSMutableArray array];
        self.maps = [M13MutableOrderedDictionary orderedDictionary];
    }
    return self;
}

#pragma mark set
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    self.tableView.allowsMultipleSelection = _allowsMultipleSelection;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

#pragma mark system
- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self updateContainerViewFrame];
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    if (self.isBeingPresented) {
        return;
    }
    if (self.isEndPresented) {
        return;
    }
    if (self.isBeingDismissed) {
        return;
    }
    // 数据维度变化
    [self.dictMaps enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self delayeringTrees:obj level:0];
    }];
    self.results = self.delayeringTrees;
    // 高度重新计算
    CGFloat rowHeight = 14.0 * 2 + [UIFont systemFontOfSize:13].lineHeight;
    self.XGCAlertViewTableViewHeight = MIN(MAX(rowHeight * self.results.count, 116.0), 270.0);
    [self updateContainerViewFrame];
    // 刷新
    [self.tableView reloadData];
    // 滚动到第一个选中的row
    if (self.maps.count > 0) {
        NSInteger row = [self.results indexOfObject:self.maps.allObjects.firstObject];
        if (row != NSNotFound) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    // 视图动画
    self.beingPresented = YES;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
    // 将视图上的键盘回收
    [UIApplication.sharedApplication sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardWillShowNotification object:self];
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformIdentity;
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    };
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        self.endPresented = YES;
        self.beingPresented = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardDidShowNotification object:self];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:completion];
}

- (void)delayeringTrees:(XGCUserDictMapModel *)dictMap level:(NSUInteger)level {
    dictMap.level = level;
    // 选中状态
    if (self.cCodes.count > 0) {
        dictMap.selected = [self.cCodes containsObject:dictMap.cCode];
    }
    if (self.cIds.count > 0) {
        dictMap.selected = [self.cIds containsObject:dictMap.cId];
    }
    // 是否可用
    dictMap.enabled = (dictMap.children.count == 0 || self.enabledWhenHasChildren);
    // 记录
    if (dictMap.selected && dictMap.enabled) {
        [self.maps setObject:dictMap forKey:(dictMap.cCode ?: (dictMap.cId ?: @""))];
    }
    // 添加到一维数组中
    [self.delayeringTrees addObject:dictMap];
    // 循环子项
    [dictMap.children enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self delayeringTrees:obj level:level + 1];
    }];
}

- (void)updateContainerViewFrame {
    CGFloat height = self.XGCAlertViewTableViewHeight + XGCAlertViewToolBarHeight + 50.0 + self.safeAreaInsets.bottom;
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - height, CGRectGetWidth(self.frame), height);
    CGFloat y = CGRectGetMaxY(self.textField.frame) + 10.0;
    self.tableView.frame = CGRectMake(0, y, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - y);
}

#pragma mark action
- (void)UITextFieldTextDidChangeAction:(XGCMainTextField *)textField {
    if (textField.markedTextRange) {
        return;
    }
    if (textField.hasText) {
        self.results = [self.delayeringTrees filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.cName CONTAINS %@", [textField.text removeWhitespace]]];
    } else {
        self.results = self.delayeringTrees;
    }
    [self.tableView reloadData];
}

- (void)backgroundControlTouchUpInside {
    self.beingDismissed = YES;
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:^(BOOL finished) { [self removeFromSuperview]; }];
}

- (void)rightBarButtonTouchUpInside {
    // 回调
    NSArray <XGCUserDictMapModel *> *allObjects = self.maps.allObjects;
    __block NSMutableSet <NSString *> *temps = [NSMutableSet set];
    [allObjects enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temps addObject:(obj.cCode ?: obj.cId ?: @"")];
    }];
    if (self.cCodes.count > 0) {
        [self.cCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temps removeObject:obj];
        }];
    }
    if (self.cIds.count > 0) {
        [self.cIds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temps removeObject:obj];
        }];
    }
    if (temps.count > 0) {
        self.didSelectDictMapsAction ? self.didSelectDictMapsAction(self, allObjects) : nil;
    }
    // 销毁页面
    [self backgroundControlTouchUpInside];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCAlertTableViewCell class])];
    cell.model = self.results[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCUserDictMapModel *row = self.results[indexPath.row];
    if (!row.enabled) {
        return;
    }
    if (row.selected && !self.allowsMultipleSelection) {
        return;
    }
    // 单选操作
    if (!self.allowsMultipleSelection) {
        [self.maps.allObjects enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        [self.maps removeAllObjects];
    }
    // 置为已选状态
    row.selected = !row.selected;
    // 记录操作
    NSString *key = row.cCode ?: row.cId ?: @"";
    row.selected ? [self.maps setObject:row forKey:key] : [self.maps removeObjectForKey:key];
    // 刷新
    [tableView reloadData];
}

@end
