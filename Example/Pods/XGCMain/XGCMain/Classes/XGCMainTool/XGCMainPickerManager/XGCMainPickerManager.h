//
//  XGCMainPickerManager.h
//  XGCMain
//
//  Created by 凌志 on 2024/1/25.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, XGCMainDocumentContentType) {
    /// 图片
    XGCMainDocumentContentTypeImage = 1 << 0,
    /// 文件 - Word
    XGCMainDocumentContentTypeWord = 1 << 1,
    /// 文件 - Excel
    XGCMainDocumentContentTypeExcel = 1 << 2,
    /// 文件 - PowerPoint
    XGCMainDocumentContentTypePowerpoint = 1 << 3,
    /// 文件 - AdobePDF
    XGCMainDocumentContentTypeAdobePDF = 1 << 4,
    /// 文件 - 压缩包 rar、zip
    XGCMainDocumentContentTypeArchive = 1 << 5,
    /// 文件-OFD
    XGCMainDocumentContentTypeOFD = 1 << 6,
    /// 文件全类型
    XGCMainDocumentContentTypeFileSupport = XGCMainDocumentContentTypeWord | XGCMainDocumentContentTypeExcel | XGCMainDocumentContentTypeAdobePDF | XGCMainDocumentContentTypeOFD,
};

@interface XGCMainPickerManager : NSObject

@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, strong) UIView *sourceView;
/// Default is YES, if set NO, user can't take picture.
/// 默认为YES，如果设置为NO, 用户将不能拍摄照片
@property (nonatomic, assign) BOOL allowTakePicture;
/// Default is YES, if set NO, user can't take picture.
/// 默认为YES，如果设置为NO, 用户将不能选择图片
@property (nonatomic, assign) BOOL allowPickingImage;
/// Default is 9 / 默认最大可选9个文件 默认最大值
@property (nonatomic, assign) NSUInteger maxFilesCount;
/// Default is YES, if set NO, user can't take picture.
/// 默认为YES，如果设置为NO, 用户将不能文件
@property (nonatomic, assign) BOOL allowPickingDocument;
/// 支持选择的文件类型，默认 XGCMainDocumentContentTypeFileSupport
@property (nonatomic, assign) XGCMainDocumentContentType contentTypes;
/// 完成图片选择或者拍照
@property (nonatomic, copy) void(^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos, NSArray<NSDictionary *> *infos);
/// 完成文件选择
@property (nonatomic, copy) void(^didPickDocumentsAtURLs)(NSArray <NSURL *> *urls);
/// 弹起
- (void)presentFromViewController:(UIViewController *)presentedViewController;
@end

NS_ASSUME_NONNULL_END
