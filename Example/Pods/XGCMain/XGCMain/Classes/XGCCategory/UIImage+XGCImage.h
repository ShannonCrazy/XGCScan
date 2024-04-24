//
//  UIImage+XGCImage.h
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XGCImage)

+ (UIImage *)imageNamed:(NSString *)name inResource:(NSString *)resource;

+ (UIImage *)imageNamed:(NSString *)name inClass:(Class)aClass;

- (nullable UIImage *)makeRotation:(CGFloat)angle;
@end

NS_ASSUME_NONNULL_END
