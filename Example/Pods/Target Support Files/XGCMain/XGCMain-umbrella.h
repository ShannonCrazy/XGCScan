#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+XGCArray.h"
#import "NSBundle+XGCBundle.h"
#import "NSCalendar+XGCCalendar.h"
#import "NSDate+XGCDate.h"
#import "NSString+XGCString.h"
#import "UIColor+XGCColor.h"
#import "UIDevice+XGCDevice.h"
#import "UIImage+XGCImage.h"
#import "XGCMainNavigationController.h"
#import "XGCMainNavigationControllerDelegate.h"
#import "XGCMainTabBarController.h"
#import "XGCMainViewController.h"
#import "XGCMainRoute.h"
#import "XGCConfiguration.h"
#import "XGCThemeManager.h"
#import "XGCThemeManagerCenter.h"
#import "XGCThemeTemplateProtocol.h"
#import "XGCURLManager.h"
#import "XGCURLManagerCenter.h"
#import "XGCURLProtocol.h"
#import "UIControl+XGCControl.h"
#import "UIView+XGCView.h"
#import "XGCActivityIndicatorView.h"
#import "XGCViewConfiguration.h"
#import "XGCViewLayer.h"
#import "XGCWebViewController.h"
#import "XGCWebViewRoute.h"

FOUNDATION_EXPORT double XGCMainVersionNumber;
FOUNDATION_EXPORT const unsigned char XGCMainVersionString[];

