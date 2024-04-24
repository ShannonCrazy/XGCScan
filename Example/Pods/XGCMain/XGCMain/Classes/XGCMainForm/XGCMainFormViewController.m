//
//  XGCMainFormViewController.m
//  XGCMain
//
//  Created by 凌志 on 2024/2/21.
//

#import "XGCMainFormViewController.h"
// view
#import "XGCAlertView.h"
#import "XGCMainFormSectionTableHeaderView.h"
// cell
#import "XGCMainFormRowTableViewCell.h"
// category
#import "XGCUserManager.h"
#import "UIView+XGCView.h"
#import "NSArray+XGCArray.h"
#import "NSString+XGCString.h"
// thirdparty
#import "XGCAliyunOSSiOS.h"

@interface XGCMainFormViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *needReloadIndexPaths;
@property (nonatomic, strong) NSMutableIndexSet *needReloadIndexSets;
@end

@implementation XGCMainFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        }
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = UIColor.clearColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        [tableView registerClass:[XGCMainFormRowTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowMediaTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowMediaTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowActionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowActionTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowTextViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowTextViewTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowTextFieldTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowTextFieldTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowStyleValue1TableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowStyleValue1TableViewCell class])];
        [tableView registerClass:[XGCMainFormRowStyleSubtitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowStyleSubtitleTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowDictMapSelectorTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowDictMapSelectorTableViewCell class])];
        [tableView registerClass:[XGCMainFormRowTextFieldSelectorTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainFormRowTextFieldSelectorTableViewCell class])];
        // 头尾
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        [tableView registerClass:[XGCMainFormSectionTableHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XGCMainFormSectionTableHeaderView class])];
        [tableView registerClass:[XGCMainFormSectionTableFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XGCMainFormSectionTableFooterView class])];
        [self.view addSubview:tableView];
        tableView;
    });
    self.needReloadIndexPaths = [NSMutableArray array];
    self.needReloadIndexSets = [NSMutableIndexSet indexSet];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needReloadIndexPaths.count == 0 && self.needReloadIndexSets.count == 0) {
        return;
    }
    [self.tableView beginUpdates];
    if (self.needReloadIndexPaths.count > 0) {
        [self.tableView reloadRowsAtIndexPaths:self.needReloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    if (self.needReloadIndexSets.count > 0) {
        [self.tableView reloadSections:self.needReloadIndexSets withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
    [self.needReloadIndexPaths removeAllObjects];
    [self.needReloadIndexSets removeAllIndexes];
}


#pragma mark func
- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.tableView.contentInset = _contentInset;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)beginUpdates {
    [self.tableView beginUpdates];
}

- (void)endUpdates {
    [self.tableView endUpdates];
}

- (void)reloadSection:(XGCMainFormSectionDescriptor *)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSUInteger value = [self.descriptor.sections indexOfObject:section];
    if (value == NSNotFound) {
        return;
    }
    if (self.view.window) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:value] withRowAnimation:animation];
    } else {
        [self.needReloadIndexSets addIndex:value];
    }
}

- (void)reloadRowsAtRows:(NSArray <__kindof XGCMainFormRowDescriptor *> *)rows withRowAnimation:(UITableViewRowAnimation)animation {
    __block NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (XGCMainFormRowDescriptor *row in rows) {
        [self.descriptor.sections enumerateObjectsUsingBlock:^(XGCMainFormSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [obj.rows indexOfObject:row];
            if (index != NSNotFound) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:idx]];
            }
        }];
    }
    if (indexPaths.count == 0) {
        return;
    }
    if (self.view.window) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    } else {
        [self.needReloadIndexPaths addObjectsFromArray:indexPaths];
    }
}

- (void)scrollToRowAtRow:(__kindof XGCMainFormRowDescriptor *)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    __block NSIndexPath *indexPath = nil;
    [self.descriptor.sections enumerateObjectsUsingBlock:^(XGCMainFormSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [obj.rows indexOfObject:row];
        if (index != NSNotFound) {
            indexPath = [NSIndexPath indexPathForRow:index inSection:idx];
        }
    }];
    if (!indexPath) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (BOOL)detectionDescriptor {
    BOOL flag = YES;
    for (XGCMainFormSectionDescriptor *section in self.descriptor.sections) {
        for (__kindof XGCMainFormRowDescriptor *row in section.rows) {
            if (!row.isRequired) {
                continue;
            }
            XGCMainFormRowTextFieldDescriptor *textFieldDescriptor = (XGCMainFormRowTextFieldDescriptor *)row;
            if ([textFieldDescriptor isKindOfClass:[XGCMainFormRowTextFieldDescriptor class]] && textFieldDescriptor.text.length == 0) {
                flag = NO;
                [self.view makeToast:textFieldDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowTextViewDescriptor *textViewDescriptor = (XGCMainFormRowTextViewDescriptor *)row;
            if ([textViewDescriptor isKindOfClass:[XGCMainFormRowTextViewDescriptor class]] && textViewDescriptor.text.length == 0) {
                flag = NO;
                [self.view makeToast:textViewDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowActionDescriptor *actionDescriptor = (XGCMainFormRowActionDescriptor *)row;
            if ([actionDescriptor isKindOfClass:[XGCMainFormRowActionDescriptor class]] && actionDescriptor.text.length == 0) {
                flag = NO;
                [self.view makeToast:actionDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowDateActionDescriptor *dateActionDescriptor = (XGCMainFormRowDateActionDescriptor *)row;
            if ([dateActionDescriptor isKindOfClass:[XGCMainFormRowDateActionDescriptor class]] && dateActionDescriptor.date == nil) {
                flag = NO;
                [self.view makeToast:dateActionDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowDictMapActionDescriptor *dictMapActionDescriptor = (XGCMainFormRowDictMapActionDescriptor *)row;
            if ([dictMapActionDescriptor isMemberOfClass:[XGCMainFormRowDictMapActionDescriptor class]] && dictMapActionDescriptor.cCode.length == 0) {
                flag = NO;
                [self.view makeToast:dictMapActionDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowDictMapSelectorDescriptor *dictMapSelectorDescriptor = (XGCMainFormRowDictMapSelectorDescriptor *)row;
            if ([dictMapSelectorDescriptor isKindOfClass:[XGCMainFormRowDictMapSelectorDescriptor class]] && dictMapSelectorDescriptor.cCode.length == 0) {
                flag = NO;
                [self.view makeToast:dictMapSelectorDescriptor.placeholder position:XGCToastViewPositionCenter];
                break;
            }
            XGCMainFormRowMediaDescriptor *mediaDescriptor = (XGCMainFormRowMediaDescriptor *)row;
            if ([mediaDescriptor isKindOfClass:[XGCMainFormRowMediaDescriptor class]] && mediaDescriptor.fileJsons.count == 0) {
                flag = NO;
                [self.view makeToast:[NSString stringWithFormat:@"请添加%@", mediaDescriptor.cDescription] position:XGCToastViewPositionCenter];
                break;
            }
        }
        if (!flag) {
            break;
        }
    }
    return flag;
}

- (void)uploadingDescriptor:(void (^)(void))completion {
    // 遍历
    __block NSMutableArray <XGCMainFormRowMediaDescriptor *> *temps = [NSMutableArray array];
    [self.descriptor.sections enumerateObjectsUsingBlock:^(XGCMainFormSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.rows enumerateObjectsUsingBlock:^(__kindof XGCMainFormRowDescriptor * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if ([obj1 isKindOfClass:[XGCMainFormRowMediaDescriptor class]]) {
                [temps addObject:obj1];
            }
        }];
    }];
    [self uploadingMediasBy:temps firstObject:temps.firstObject completion:completion];
}

- (void)uploadingMediasBy:(NSMutableArray <XGCMainFormRowMediaDescriptor *> *)temps firstObject:(XGCMainFormRowMediaDescriptor *)firstObject completion:(void(^)(void))completion {
    if (!firstObject) {
        [self.view dismiss];
        completion ? completion() : nil;
        return;
    }
    __block  XGCMainMediaFileJsonModel * _Nullable fileJson = nil;
    [firstObject.fileJsons enumerateObjectsUsingBlock:^(XGCMainMediaFileJsonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.fileUrl.length == 0 && (obj.image || obj.filePathURL)) {
            *stop = (fileJson = obj) ? YES : NO;
        }
    }];
    if (!fileJson) {
        [temps removeObject:firstObject];
        [self uploadingMediasBy:temps firstObject:temps.firstObject completion:completion];
        return;
    }
    __weak typeof(self) this = self;
    void (^uploadProgress) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [this.view showProgress:totalBytesSent / totalBytesExpectedToSend status:@"附件上传中..."];
        });
    };
    NSData *uploadingData = fileJson.image ? UIImageJPEGRepresentation(fileJson.image, 1.0) : (fileJson.filePathURL ? [NSData dataWithContentsOfURL:fileJson.filePathURL] : nil);
    [XGCAliyunOSSiOS.shareInstance putObject:uploadingData fileName:fileJson.fileName pathExtension:fileJson.suffix uploadProgress:uploadProgress completionHandler:^(NSString * _Nullable destination, NSError * _Nullable error) {
        if (!error) {
            fileJson.image = nil;
            fileJson.filePathURL = nil;
            fileJson.fileUrl = destination;
            [this uploadingMediasBy:temps firstObject:firstObject completion:completion];
        } else {
            [this.view dismiss];
            [this.view makeToast:@"附件上传失败，请稍后再试" position:XGCToastViewPositionCenter];
        }
    }];
}

#pragma mark system
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.descriptor.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.descriptor.sections[section].rows.count;
}

#pragma mark sectionHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    __kindof XGCMainFormSectionConfigDescriptor *descriptor = self.descriptor.sections[section].headerInSection;
    return descriptor.rowHeight ?: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __kindof XGCMainFormSectionConfigDescriptor *descriptor = self.descriptor.sections[section].headerInSection;
    if ([descriptor isKindOfClass:[XGCMainFormSectionCustomConfigDescriptor class]]) {
        XGCMainFormSectionCustomConfigDescriptor *custom = (XGCMainFormSectionCustomConfigDescriptor *)descriptor;
        __kindof UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(custom.aClass)];
        if (!headerFooterView) {
            [tableView registerClass:custom.aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(custom.aClass)];
        }
        if (!headerFooterView) {
            headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(custom.aClass)];
        }
        custom.setupCustomHeaderFooterView ? custom.setupCustomHeaderFooterView(custom, headerFooterView, section) : nil;
        return headerFooterView;
    } else if ([descriptor isKindOfClass:[XGCMainFormSectionDefaultConfigDescriptor class]]) {
        XGCMainFormSectionTableHeaderView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XGCMainFormSectionTableHeaderView class])];
        headerFooterView.headerInSection = (XGCMainFormSectionDefaultConfigDescriptor *)descriptor;
        return headerFooterView;
    } else {
        UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        return headerFooterView;
    }
}

#pragma mark sectionFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    __kindof XGCMainFormSectionConfigDescriptor *descriptor = self.descriptor.sections[section].footerInSection;
    return descriptor.rowHeight ?: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    __kindof XGCMainFormSectionConfigDescriptor *descriptor = self.descriptor.sections[section].footerInSection;
    if ([descriptor isKindOfClass:[XGCMainFormSectionCustomConfigDescriptor class]]) {
        XGCMainFormSectionCustomConfigDescriptor *custom = (XGCMainFormSectionCustomConfigDescriptor *)descriptor;
        __kindof UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(custom.aClass)];
        if (!headerFooterView) {
            [tableView registerClass:custom.aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(custom.aClass)];
        }
        if (!headerFooterView) {
            headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(custom.aClass)];
        }
        custom.setupCustomHeaderFooterView ? custom.setupCustomHeaderFooterView(custom, headerFooterView, section) : nil;
        return headerFooterView;
    } else if ([descriptor isKindOfClass:[XGCMainFormSectionDefaultConfigDescriptor class]]) {
        XGCMainFormSectionTableFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XGCMainFormSectionTableFooterView class])];
        headerFooterView.footerInSection = (XGCMainFormSectionDefaultConfigDescriptor *)descriptor;
        return headerFooterView;
    } else {
        UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        return headerFooterView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.descriptor.sections[indexPath.section].rows[indexPath.row].rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainFormRowDescriptor *descriptor = self.descriptor.sections[indexPath.section].rows[indexPath.row];
    if ([descriptor isKindOfClass:[XGCMainFormRowTextFieldSelectorDescriptor class]]) {
        XGCMainFormRowTextFieldSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowTextFieldSelectorTableViewCell class])];
        cell.tableView = tableView;
        cell.textFieldSelectorDescriptor = (XGCMainFormRowTextFieldSelectorDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowTextFieldDescriptor class]]) {
        XGCMainFormRowTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowTextFieldTableViewCell class])];
        cell.tableView = tableView;
        cell.textFieldDescriptor = (XGCMainFormRowTextFieldDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowTextViewDescriptor class]]) {
        XGCMainFormRowTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowTextViewTableViewCell class])];
        cell.tableView = tableView;
        cell.textViewDescriptor = (XGCMainFormRowTextViewDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowActionDescriptor class]]) {
        XGCMainFormRowActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowActionTableViewCell class])];
        cell.tableView = tableView;
        cell.dateDescriptor = nil;
        cell.dictMapDescriptor = nil;
        cell.UIControlTouchUpInside = nil;
        cell.actionDescriptor = (XGCMainFormRowActionDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowStyleValue1Descriptor class]]) {
        XGCMainFormRowStyleValue1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowStyleValue1TableViewCell class])];
        cell.value1Descriptor = (XGCMainFormRowStyleValue1Descriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowStyleSubtitleDescriptor class]]) {
        XGCMainFormRowStyleSubtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowStyleSubtitleTableViewCell class])];
        cell.subtitleDescriptor = (XGCMainFormRowStyleSubtitleDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowMediaDescriptor class]]) { // 图片附件
        XGCMainFormRowMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowMediaTableViewCell class])];
        cell.aTarget = self;
        cell.mediaDescriptor = (XGCMainFormRowMediaDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowDateActionDescriptor class]]) { // 日历
        XGCMainFormRowActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowActionTableViewCell class])];
        cell.actionDescriptor = nil;
        cell.dictMapDescriptor = nil;
        cell.dateDescriptor = (XGCMainFormRowDateActionDescriptor *)descriptor;
        __weak typeof(self) this = self;
        cell.UIControlTouchUpInside = ^(__kindof XGCMainFormRowDescriptor * _Nonnull descriptor) {
            [this addXGCDatePickerAction:descriptor];
        };
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowDictMapActionDescriptor class]]) { // 字典码
        XGCMainFormRowActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowActionTableViewCell class])];
        cell.dateDescriptor = nil;
        cell.actionDescriptor = nil;
        cell.dictMapDescriptor = (XGCMainFormRowDictMapActionDescriptor *)descriptor;
        __weak typeof(self) this = self;
        cell.UIControlTouchUpInside = ^(__kindof XGCMainFormRowDescriptor * _Nonnull descriptor) {
            [this addDictMapPickerViewAction:descriptor];
        };
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowDictMapSelectorDescriptor class]]) { // 字典选择
        XGCMainFormRowDictMapSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowDictMapSelectorTableViewCell class])];
        cell.dictMapSelectorDescriptor = (XGCMainFormRowDictMapSelectorDescriptor *)descriptor;
        return cell;
    } else if ([descriptor isKindOfClass:[XGCMainFormRowCustiomDescriptor class]]) { // 自定义
        XGCMainFormRowCustiomDescriptor *row = (XGCMainFormRowCustiomDescriptor *)descriptor;
        __kindof UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(row.aClass)];
        if (!cell) {
            [tableView registerClass:row.aClass forCellReuseIdentifier:NSStringFromClass(row.aClass)];
        }
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(row.aClass)];
        }
        row.setupCustomCell ? row.setupCustomCell(row, cell, indexPath) : nil;
        return cell;
    }
    else if ([descriptor isKindOfClass:[XGCMainFormRowDescriptor class]]) {
        XGCMainFormRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainFormRowTableViewCell class])];
        cell.tableView = tableView;
        cell.descriptor = descriptor;
        return cell;
    }
    return nil;
}

#pragma mark func
- (void)addXGCDatePickerAction:(XGCMainFormRowDateActionDescriptor *)dateDescriptor {
    if (![dateDescriptor isKindOfClass:[XGCMainFormRowDateActionDescriptor class]]) {
        return;
    }
    XGCDatePickerView *pickerView = [[XGCDatePickerView alloc] initWithFrame:self.view.frame];
    pickerView.date = dateDescriptor.date;
    pickerView.title = dateDescriptor.placeholder;
    pickerView.dateFormat = dateDescriptor.dateFormat;
    if (dateDescriptor.addDatePickerViewWithConfigurationHandler) {
        dateDescriptor.addDatePickerViewWithConfigurationHandler(dateDescriptor, pickerView);
    }
    __weak typeof(self) this = self;
    pickerView.didSelectDateAction = ^(XGCDatePickerView * _Nonnull pickerView, NSDate * _Nonnull date) {
        dateDescriptor.date = date;
        if (dateDescriptor.NSDateDidChangeAction) {
            dateDescriptor.NSDateDidChangeAction(dateDescriptor, date);
        }
        [this reloadRowsAtRows:@[dateDescriptor] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:pickerView];
}

- (void)addDictMapPickerViewAction:(XGCMainFormRowDictMapActionDescriptor *)dictMapDescriptor {
    if (![dictMapDescriptor isKindOfClass:[XGCMainFormRowDictMapActionDescriptor class]]) {
        return;
    }
    XGCAlertView *alert = [[XGCAlertView alloc] initWithFrame:self.view.frame];
    alert.title = dictMapDescriptor.placeholder;
    alert.cCodes = [dictMapDescriptor.cCode componentsSeparatedByString:@","];
    alert.allowsMultipleSelection = dictMapDescriptor.allowsMultipleSelection;
    alert.dictMaps = dictMapDescriptor.dictMaps ?: [XGCUM.cMenu cDictMap:dictMapDescriptor.cCoder];
    __weak typeof(self) this = self;
    alert.didSelectDictMapsAction = ^(XGCAlertView * _Nonnull alertView, NSArray<XGCUserDictMapModel *> * _Nonnull dictMaps) {
        if (dictMapDescriptor.allowsMultipleSelection) {
            __block NSMutableArray <NSString *> *cCodes = [NSMutableArray array];
            [dictMaps enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.cCode.length > 0 ? [cCodes addObject:obj.cCode] : nil;
            }];
            dictMapDescriptor.cCode = [cCodes componentsJoinedByString:@","];
        } else {
            dictMapDescriptor.cCode = dictMaps.firstObject.cCode;
        }
        if (dictMapDescriptor.cCodeDidChangeAction) {
            dictMapDescriptor.cCodeDidChangeAction(dictMapDescriptor, dictMapDescriptor.cCode);
        }
        [this reloadRowsAtRows:@[dictMapDescriptor] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:alert];
}

@end
