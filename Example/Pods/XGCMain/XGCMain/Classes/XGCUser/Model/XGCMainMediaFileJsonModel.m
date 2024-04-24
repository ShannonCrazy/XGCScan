//
//  XGCMainMediaFileJsonModel.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCMainMediaFileJsonModel.h"
#if __has_include (<MJExtension/MJExtension.h>)
#import <MJExtension/MJExtension.h>
#endif

#if __has_include (<SDWebImage/NSData+ImageContentType.h>)
#import <SDWebImage/NSData+ImageContentType.h>
#endif

@implementation XGCMainMediaFileJsonModel

+ (instancetype)image:(UIImage *)image filePathURL:(NSURL *)filePathURL fileName:(NSString *)fileName suffix:(NSString *)suffix {
    NSDate *date = [NSDate date];
    XGCMainMediaFileJsonModel *model = [[XGCMainMediaFileJsonModel alloc] init];
    model.image = image;
    model.filePathURL = filePathURL;
    if (filePathURL && !fileName) {
        fileName = filePathURL.lastPathComponent.stringByDeletingPathExtension;
    }
    if (filePathURL && !suffix) {
        suffix = filePathURL.pathExtension;
    }
    model.fileName = fileName ?: @(ceil(date.timeIntervalSince1970 * 1000)).description;
    model.suffix = suffix ?: [self imageFormatForImage:image];
    model.creTime = @(ceil(date.timeIntervalSince1970 * 1000)).description;
    return model;
}

+ (instancetype)fileUrl:(NSString *)fileUrl suffix:(nullable NSString *)suffix {
    XGCMainMediaFileJsonModel *model = [[XGCMainMediaFileJsonModel alloc] init];
    model.fileUrl = fileUrl;
    model.fileName = fileUrl.stringByDeletingPathExtension.lastPathComponent;
    model.suffix = fileUrl.pathExtension;
    if (model.suffix.length == 0) {
        model.suffix = suffix;
    }
    return model;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"image", @"filePathURL"];
}

+ (NSString *)imageFormatForImage:(UIImage *)image {
#if __has_include (<SDWebImage/NSData+ImageContentType.h>)
    SDImageFormat format = [NSData sd_imageFormatForImageData:UIImageJPEGRepresentation(image, 1.0)];
    switch (format) {
        case SDImageFormatJPEG: return @"jpeg"; break;
        case SDImageFormatPNG: return @"png"; break;
        case SDImageFormatGIF: return @"gif"; break;
        case SDImageFormatTIFF: return @"tiff"; break;
        case SDImageFormatWebP: return @"webp"; break;
        case SDImageFormatHEIC: return @"heic"; break;
        case SDImageFormatHEIF: return @"heif"; break;
        case SDImageFormatSVG: return @"svg"; break;
        default: return @"png"; break;
    }
#endif
    return @"png";
}
@end
