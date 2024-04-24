//
//  XGCMainAppFuncCodeRefreshViewController.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/26.
//

#import "XGCMainAppFuncCodeViewController.h"
// tool
#import "XGCRefreshTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainAppFuncCodeRefreshViewController : XGCMainAppFuncCodeViewController <UITableViewDelegate, UITableViewDataSource, XGCTableViewRefreshDelegate>
@property (nonatomic, strong) XGCRefreshTableView *tableView;
@property (nonatomic, assign) BOOL beginRefreshingWhenDidMoveToSuperView;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tableViewSwipeGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
