//
//  XGCMainRefreshViewController.h
//  XGCMain
//
//  Created by 凌志 on 2024/2/21.
//

#import "XGCMainViewController.h"
// tool
#import "XGCRefreshTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainRefreshViewController : XGCMainViewController<UITableViewDelegate, UITableViewDataSource, XGCTableViewRefreshDelegate>
@property (nonatomic, strong) XGCRefreshTableView *tableView;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tableViewSwipeGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
