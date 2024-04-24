//
//  XGCMainAppFuncCodeViewController.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCMainViewController.h"
#import "XGCUserAclMapModel.h"
#import "XGCMenuDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainAppFuncCodeViewController : XGCMainViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)cAppFuncCode:(NSString *)cAppFuncCode;
@property (nonatomic, copy, nullable) NSString *cAppFuncCode;
@property (nonatomic, strong, readonly, nullable) XGCMenuDataModel *cMenu;
@property (nonatomic, strong, readonly, nullable) XGCUserAclMapModel *authority;
@end


NS_ASSUME_NONNULL_END
