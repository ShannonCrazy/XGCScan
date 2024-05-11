//
//  XGCWebViewController.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCWebViewController : XGCMainViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)XGCWebView:(NSURL *)URL;
@end

NS_ASSUME_NONNULL_END
