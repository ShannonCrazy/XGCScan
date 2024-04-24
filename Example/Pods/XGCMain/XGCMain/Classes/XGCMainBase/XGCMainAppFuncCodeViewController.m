//
//  XGCMainAppFuncCodeViewController.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCMainAppFuncCodeViewController.h"
// model
#import "XGCUserManager.h"

@interface XGCMainAppFuncCodeViewController ()
@property (nonatomic, strong, readwrite, nullable) XGCMenuDataModel *cMenu;
@property (nonatomic, strong, readwrite, nullable) XGCUserAclMapModel *authority;
@end

@implementation XGCMainAppFuncCodeViewController

+ (instancetype)cAppFuncCode:(NSString *)cAppFuncCode {
    return [[self alloc] initWithAppFuncCode:cAppFuncCode];
}

- (instancetype)initWithAppFuncCode:(NSString *)cAppFuncCode {
    if (self = [super init]) {
        _cAppFuncCode = cAppFuncCode;
        self.cMenu = [XGCUM.cMenu cMenuData:@"cd_yingyong" cAppFuncCode:_cAppFuncCode filter:NO];
        self.authority = [XGCUM.cMenu cAclMap:_cAppFuncCode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.cMenu.cName;
}

@end
