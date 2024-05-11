//
//  UIImage+XGCImage.h
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XGCImage)
/// 旋转
/// - Parameter angle: 角度
- (nullable UIImage *)makeRotation:(CGFloat)angle;
@end

NS_ASSUME_NONNULL_END
