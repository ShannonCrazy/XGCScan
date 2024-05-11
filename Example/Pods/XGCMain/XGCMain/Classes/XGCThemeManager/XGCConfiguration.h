//
//  XGCConfiguration.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define XGCCMI [XGCConfiguration sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface XGCConfiguration : NSObject

@property (nonatomic, strong) UIColor            *clearColor;
@property (nonatomic, strong) UIColor            *whiteColor;
@property (nonatomic, strong) UIColor            *blackColor;
@property (nonatomic, strong) UIColor            *grayColor;
@property (nonatomic, strong) UIColor            *grayDarkenColor;
@property (nonatomic, strong) UIColor            *grayLightenColor;
@property (nonatomic, strong) UIColor            *redColor;
@property (nonatomic, strong) UIColor            *greenColor;
@property (nonatomic, strong) UIColor            *blueColor;
@property (nonatomic, strong) UIColor            *secondaryBlueColor;

@property (nonatomic, strong) UIColor            *yellowColor;
@property (nonatomic, strong) UIColor            *purpleColor;

@property (nonatomic, strong) UIColor            *linkColor;
@property (nonatomic, strong) UIColor            *disabledColor;
@property (nonatomic, strong, nullable) UIColor  *backgroundColor;
@property (nonatomic, strong) UIColor            *separatorDashedColor;

@property (nonatomic, strong) UIColor            *labelColor;
@property (nonatomic, strong) UIColor            *secondaryLabelColor;
@property (nonatomic, strong, nullable) UIColor  *tertiaryLabelColor;
@property (nonatomic, strong, nullable) UIColor  *quaternaryLabelColor;

@property (nonatomic, strong) UIColor            *placeholderTextColor;

@property (nonatomic, strong) UIColor            *separatorColor;

@property (nonatomic, strong) UIColor            *shadowColor;

@property (nonatomic, strong) UIColor            *timeAxisColor;

#pragma mark - UIButton
@property (nonatomic, strong) UIColor            *buttonTintColor;
@property (nonatomic, strong) UIColor            *buttonDisabledColor;

#pragma mark - UITextField & UITextView

@property (nonatomic, strong, nullable) UIColor  *textFieldTextColor;

#pragma mark - NavigationBar

@property (nonatomic, strong, nullable) UIColor  *navBarBackgroundColor;
@property (nonatomic, strong, nullable) UIColor  *navBarShadowColor;

@property (nonatomic, strong, nullable) UIColor  *navBarTitleColor;
@property (nonatomic, strong, nullable) UIFont   *navBarTitleFont;

@property (nonatomic, strong, nullable) UIImage  *navBackButtonImage;

@property (nonatomic, strong, nullable) UIFont   *navBarButtonFont;
@property (nonatomic, strong, nullable) UIColor  *navBarButtonColor;
@property (nonatomic, strong, nullable) UIColor  *navBarButtonDisabledColor;

#pragma mark - TabBar

@property (nonatomic, strong, nullable) UIColor  *tabBarBackgroundColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarShadowColor;

@property (nonatomic, strong, nullable) UIFont   *tabBarItemTitleFont;
@property (nonatomic, strong, nullable) UIFont   *tabBarItemTitleFontSelected;

@property (nonatomic, strong, nullable) UIColor  *tabBarItemTitleColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarItemTitleColorSelected;

#pragma mark - UIViewController
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;
/// 单例对象
/// The singleton instance
+ (instancetype _Nullable )sharedInstance;
@end

NS_ASSUME_NONNULL_END
