//
//  XGCMainMediaFileJsonModel.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainMediaFileJsonModel : NSObject
/// 文件地址
@property (nonatomic, copy) NSString *fileUrl;
/// 文件名
@property (nonatomic, copy) NSString *fileName;
/// 后缀
@property (nonatomic, copy) NSString *suffix;
/// 图像
@property (nonatomic, strong, nullable) UIImage *image;
/// 本地文件路劲
@property (nonatomic, strong, nullable) NSURL *filePathURL;
/// 创建时间
@property (nonatomic, copy) NSString *creTime;

+ (instancetype)image:(nullable UIImage *)image filePathURL:(nullable NSURL *)filePathURL fileName:(nullable NSString *)fileName suffix:(nullable NSString *)suffix;

+ (instancetype)fileUrl:(NSString *)fileUrl suffix:(nullable NSString *)suffix;
@end

NS_ASSUME_NONNULL_END
