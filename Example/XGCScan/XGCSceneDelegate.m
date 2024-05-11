//
//  XGCSceneDelegate.m
//  XGCScan_Example
//
//  Created by 凌志 on 2024/4/24.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSceneDelegate.h"
//
#import <XGCMain/XGCMainRoute.h>

@implementation XGCSceneDelegate
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    [XGCMainRoute scene:scene willConnectToSession:session options:connectionOptions];
}
@end
