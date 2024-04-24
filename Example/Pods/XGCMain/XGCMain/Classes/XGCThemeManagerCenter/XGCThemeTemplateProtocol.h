//
//  XGCThemeProtocol.h
//  XGCMain
//
//  Created by 凌志 on 2024/2/20.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XGCThemeTemplateProtocol <NSObject>
@required
/// 应用配置表的设置
/// Applies configurations
- (void)applyConfigurationTemplate;
@end

NS_ASSUME_NONNULL_END
