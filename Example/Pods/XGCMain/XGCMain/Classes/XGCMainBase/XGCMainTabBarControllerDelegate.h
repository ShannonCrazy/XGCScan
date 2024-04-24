//
//  XGCMainTabBarControllerDelegate.h
//  XGCMainComponents
//
//  Created by 凌志 on 2023/11/15.
//

#import <UIKit/UIKit.h>
@class XGCMainTabBarController;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainTabBarControllerDelegate : NSObject <UITabBarControllerDelegate>
/// 导航栏
@property (nonatomic, weak) XGCMainTabBarController *tabBarController;
@end

NS_ASSUME_NONNULL_END
