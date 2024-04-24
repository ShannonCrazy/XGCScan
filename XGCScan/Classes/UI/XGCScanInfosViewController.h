//
//  XGCScanInfosViewController.h
//  xinggc
//
//  Created by 凌志 on 2023/11/29.
//

#import <XGCMain/XGCMainViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCScanInfosViewController : XGCMainViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
/// 初始化
/// - Parameter stringValue: 扫码信息
+ (instancetype)XGCScanInfos:(NSString *)stringValue;
@end

NS_ASSUME_NONNULL_END
