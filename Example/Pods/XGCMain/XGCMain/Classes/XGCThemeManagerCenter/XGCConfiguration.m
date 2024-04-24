//
//  XGCConfiguration.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/26.
//

#import "XGCConfiguration.h"
//
#import "UIImage+XGCImage.h"
#import "UIColor+XGCColor.h"

/// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看 UIColor+QMUI.h
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

@implementation XGCConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static XGCConfiguration *sharedInstance;
    dispatch_once(&pred, ^{
        sharedInstance = [[XGCConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}

#pragma mark - Initialize default values

- (void)initDefaultConfiguration {
    
#pragma mark - Global Color
    
    self.clearColor = UIColorMakeWithRGBA(255, 255, 255, 0);
    self.whiteColor = UIColorMake(255, 255, 255);
    self.blackColor = UIColorMake(0, 0, 0);
    self.grayColor = UIColorMake(179, 179, 179);
    self.grayDarkenColor = UIColorMake(163, 163, 163);
    self.grayLightenColor = UIColorMake(198, 198, 198);
    self.redColor = UIColorMake(250, 58, 58);
    self.greenColor = UIColorMake(12, 178, 153);
    self.blueColor = UIColorMake(14, 130, 234);
    self.secondaryBlueColor = UIColorMake(126, 190, 255);
    
    self.yellowColor = UIColorMake(241, 145, 21);
    self.purpleColor = UIColorMake(178, 34, 219);
    
    self.linkColor = UIColorMake(56, 116, 171);
    self.disabledColor = self.grayColor;
    self.backgroundColor = UIColorMake(242, 241, 246);
    self.separatorDashedColor = UIColorMake(17, 17, 17);
    
    self.labelColor = UIColorMake(34, 34, 34);
    self.secondaryLabelColor = UIColorMake(94, 101, 112);
    self.tertiaryLabelColor = UIColorMake(161, 161, 161);
    
    self.placeholderTextColor = [UIColor.grayColor colorWithAlphaComponent:0.7];
    
    self.separatorColor = [UIColor xgc_colorNamed:@"#ccced0"];
    
    self.shadowColor = UIColorMake(106, 165, 235);
    
    self.timeAxisColor = UIColorMake(193, 223, 253);
#pragma mark - UIButton
    self.buttonTintColor = UIColorMake(76, 203, 255);
    self.buttonDisabledColor = UIColorMake(214, 234, 254);
    
#pragma mark - UITextField & UITextView
    self.textFieldTextColor = self.labelColor;
    
#pragma mark - NavigationBar
    self.navBarBackgroundColor = UIColorMake(255, 255, 255);
    self.navBarShadowColor = UIColor.clearColor;
    self.navBarTitleColor = self.labelColor;
    self.navBarTitleFont = [UIFont boldSystemFontOfSize:18];
    self.navBackButtonImage = [UIImage imageNamed:@"main_return" inResource:@"XGCMain"];
    self.navBarButtonFont = [UIFont systemFontOfSize:16];
    self.navBarButtonColor = self.blueColor;
    self.navBarButtonDisabledColor = self.tertiaryLabelColor;
    
#pragma mark - TabBar
    self.tabBarBackgroundColor = self.whiteColor;
    self.tabBarShadowColor = self.clearColor;
    self.tabBarItemTitleFont = [UIFont systemFontOfSize:9];
    self.tabBarItemTitleFontSelected = [UIFont systemFontOfSize:9];
    self.tabBarItemTitleColor = self.labelColor;
    self.tabBarItemTitleColorSelected = self.blueColor;
    
#pragma mark - UIViewController
    self.preferredStatusBarStyle = UIStatusBarStyleDefault;
}
     

@end
