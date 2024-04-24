//
//  XGCMainNavigationControllerDelegate.h
//  xinggc
//
//  Created by 凌志 on 2023/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainNavigationControllerDelegate : NSObject <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
/// 导航栏
@property (nonatomic, weak) __kindof UINavigationController *navigationController;
@end

NS_ASSUME_NONNULL_END
