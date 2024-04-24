//
//  XGCMainPickerManager.m
//  XGCMain
//
//  Created by 凌志 on 2024/1/25.
//

#import "XGCMainPickerManager.h"
#if __has_include (<TZImagePickerController/TZImagePickerController.h>)
#import <TZImagePickerController/TZImagePickerController.h>
#endif
#import "UIDevice+XGCDevice.h"
//
#import <AVFoundation/AVFoundation.h>

@interface XGCMainPickerManager () <
#if __has_include (<TZImagePickerController/TZImagePickerController.h>)
TZImagePickerControllerDelegate,
#endif
UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate>
@property (nonatomic, weak) __kindof UIViewController *aTarget;
@end

@implementation XGCMainPickerManager

- (instancetype)init {
    if (self = [super init]) {
        self.allowTakePicture = YES;
        self.allowPickingImage = YES;
        self.allowPickingDocument = YES;
        self.maxFilesCount = NSUIntegerMax;
        self.contentTypes = XGCMainDocumentContentTypeFileSupport;
    }
    return self;
}

- (void)presentFromViewController:(UIViewController *)presentedViewController {
    self.aTarget = presentedViewController;
    // 选取照片
    __weak typeof(self) this = self;
    void (^allowTakePicture)(UIAlertAction *action) = ^(UIAlertAction *action) {
        [this allowTakePictureAction];
    };
    // 拍照
    void (^allowPickingImage)(UIAlertAction *action) = ^(UIAlertAction *action) {
        [this allowPickingImageAction];
    };
    // 选取文档
    void (^allowPickingDocument)(UIAlertAction *action) = ^(UIAlertAction *action) {
        [this allowPickingDocumentAction];
    };
    NSMutableArray *temps = [NSMutableArray arrayWithObjects:allowTakePicture, allowPickingImage, allowPickingDocument, nil];
    if (!self.allowTakePicture) {
        [temps removeObject:allowTakePicture];
    }
    if (!self.allowPickingImage) {
        [temps removeObject:allowPickingImage];
    }
    if (!self.allowPickingDocument) {
        [temps removeObject:allowPickingDocument];
    }
    if (temps.count == 0) {
        return;
    }
    if (temps.count == 1) {
        void(^block)(UIAlertAction *action) = temps.lastObject;
        block([UIAlertAction new]);
        return;
    }
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (UIDevice.iPad) {
        actionSheet.popoverPresentationController.sourceView = self.sourceView;
        actionSheet.popoverPresentationController.sourceRect = self.sourceRect;
    }
    if (self.allowTakePicture) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"使用相机" style:UIAlertActionStyleDefault handler:allowTakePicture]];
    }
    if (self.allowPickingImage) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"手机相册选择" style:UIAlertActionStyleDefault handler:allowPickingImage]];
    }
    if (self.allowPickingDocument) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"选择文件" style:UIAlertActionStyleDefault handler:allowPickingDocument]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.aTarget presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark 相册
- (void)allowPickingImageAction {
#if __has_include (<TZImagePickerController/TZImagePickerController.h>)
    TZImagePickerController *viewControllerToPresent = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxFilesCount delegate:self];
    viewControllerToPresent.allowTakeVideo = NO;
    [self.aTarget presentViewController:viewControllerToPresent animated:YES completion:nil];
#endif
}

#pragma mark TZImagePickerControllerDelegate
#if __has_include (<TZImagePickerController/TZImagePickerController.h>)
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.didFinishPickingPhotosWithInfosHandle ? self.didFinishPickingPhotosWithInfosHandle(photos, infos) : nil;
}
#endif

#pragma mark 相机
- (void)allowTakePictureAction {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    void(^completionHandler)(BOOL granted) = ^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
            viewController.delegate = self;
            viewController.sourceType = UIImagePickerControllerSourceTypeCamera;
            viewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.aTarget presentViewController:viewController animated:YES completion:nil];            
        });
    };
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:completionHandler];
        } break;
        case AVAuthorizationStatusDenied: case AVAuthorizationStatusRestricted: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请在iPhone的“设置-隐私-照片”选项中允许app访问您的相册" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self.aTarget presentViewController:alert animated:YES completion:nil];
        } break;
        case AVAuthorizationStatusAuthorized: {
            completionHandler ? completionHandler(YES) : nil;
        } break;
        default: {
        } break;
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    self.didFinishPickingPhotosWithInfosHandle ? self.didFinishPickingPhotosWithInfosHandle([NSArray arrayWithObject:image], [NSArray arrayWithObject:info]) : nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 文档
- (void)allowPickingDocumentAction {
    NSMutableArray <NSString *> *allowedUTIs = [NSMutableArray array];
    if ((self.contentTypes & XGCMainDocumentContentTypeWord) == XGCMainDocumentContentTypeWord) {
        // com.microsoft.word.openxml.document --> docx
        [allowedUTIs addObjectsFromArray:@[@"com.microsoft.word.doc",
                                           @"com.microsoft.word.docx",
                                           @"com.microsoft.word.openxml.document",
                                           @"org.openxmlformats.wordprocessingml.document"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypeExcel) == XGCMainDocumentContentTypeExcel) {
        // org.openxmlformats.spreadsheetml.sheet.macroenabled -> xlsm
        // org.openxmlformats.spreadsheetml.sheet --> xlxs
        // com.microsoft.excel.xlt --> xlt
        [allowedUTIs addObjectsFromArray:@[@"com.microsoft.excel.xls",
                                           @"org.openxmlformats.spreadsheetml.sheet",
                                           @"com.microsoft.excel.xlt",
                                           @"org.openxmlformats.spreadsheetml.sheet.macroenabled"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypePowerpoint) == XGCMainDocumentContentTypePowerpoint) {
        // com.microsoft.powerpoint.​ppt --> ppt
        // com.microsoft.powerpoint.openxml.presentation --> pptx
        // org.openxmlformats.presentationml.presentation --> pptx
        [allowedUTIs addObjectsFromArray:@[@"com.microsoft.powerpoint.​ppt",
                                           @"com.microsoft.powerpoint.openxml.presentation",
                                           @"org.openxmlformats.presentationml.presentation"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypeAdobePDF) == XGCMainDocumentContentTypeAdobePDF) {
        [allowedUTIs addObjectsFromArray:@[@"com.adobe.pdf"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypeOFD) == XGCMainDocumentContentTypeOFD) {
        [allowedUTIs addObjectsFromArray:@[@"com.inbasis.ofd", @"public-data"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypeImage) == XGCMainDocumentContentTypeImage) {
        [allowedUTIs addObjectsFromArray:@[@"public.jpeg", @"public.png", @"public.webp", @"public.jpg", @"public.heic"]];
    }
    if ((self.contentTypes & XGCMainDocumentContentTypeArchive) == XGCMainDocumentContentTypeArchive) {
        [allowedUTIs addObjectsFromArray:@[@"public.zip-archive",@"public.data"]];
    }
    UIDocumentPickerViewController *pickerViewController = nil;
    if (@available(iOS 14.0, *)) {
        __block NSMutableArray <UTType *> *contentTypes = [NSMutableArray array];
        [allowedUTIs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UTType *contentType = [UTType typeWithIdentifier:obj];
            contentType ? [contentTypes addObject:contentType] : nil;
        }];
        pickerViewController = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:contentTypes asCopy:YES];
    } else {
        pickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeOpen];
    }
    pickerViewController.delegate = self;
    pickerViewController.allowsMultipleSelection = self.maxFilesCount > 1;
    [self.aTarget presentViewController:pickerViewController animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
    NSURL *URL = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    __block NSMutableArray <NSURL *> *URLs = [NSMutableArray array];
    [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL flag = [obj startAccessingSecurityScopedResource];
        if (flag) {
            [coordinator coordinateReadingItemAtURL:obj options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL * _Nonnull newURL) {
                NSURL *filePathURL = [URL URLByAppendingPathComponent:newURL.path.lastPathComponent];
                BOOL result = [[NSData dataWithContentsOfURL:newURL] writeToURL:filePathURL atomically:YES];
                result ? [URLs addObject:filePathURL] : nil;
            }];
        }
        [obj stopAccessingSecurityScopedResource];
    }];
    self.didPickDocumentsAtURLs ? self.didPickDocumentsAtURLs([URLs copy]) : nil;
}

@end
