//
//  XGCMainAppFuncCodeRefreshViewController.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/26.
//

#import "XGCMainAppFuncCodeRefreshViewController.h"

@interface XGCMainAppFuncCodeRefreshViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *swipeGestureRecognizer;
@end

@implementation XGCMainAppFuncCodeRefreshViewController

- (BOOL)beginRefreshingWhenDidMoveToSuperView {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        XGCRefreshTableView *tableView = [[XGCRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.refreshDelegate = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = UIColor.clearColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.beginRefreshingWhenDidMoveToSuperView = self.beginRefreshingWhenDidMoveToSuperView;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
        [self.view addSubview:tableView];
        tableView;
    });
    if (_swipeGestureRecognizer) {
        [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
    }
}

- (UIPanGestureRecognizer *)tableViewSwipeGestureRecognizer {
    return self.swipeGestureRecognizer;
}

#pragma mark UITableViewDelegate, UITableViewDataSource, XGCTableViewRefreshDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    return cell;
}

#pragma mark
- (UIPanGestureRecognizer *)swipeGestureRecognizer {
    if (!_swipeGestureRecognizer) {
        _swipeGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
        _swipeGestureRecognizer.delegate = self;
        _swipeGestureRecognizer.delaysTouchesBegan = YES;
        _swipeGestureRecognizer.cancelsTouchesInView = NO;
        if (self.isViewLoaded) {
            [self.tableView addGestureRecognizer:_swipeGestureRecognizer];
        }
    }
    return _swipeGestureRecognizer;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UITableView *tableView = (UITableView *)gestureRecognizer.view;
    if ([tableView isKindOfClass:UITableView.class] && [gestureRecognizer isMemberOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:tableView];
        CGPoint location = [panGestureRecognizer locationInView:tableView];
        return translation.x < 0 && location.y < tableView.contentSize.height;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [otherGestureRecognizer.view isKindOfClass:UITableView.class];
}

@end
