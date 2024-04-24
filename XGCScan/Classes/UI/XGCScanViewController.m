//
//  XGCScanViewController.m
//  xinggc
//
//  Created by 凌志 on 2023/11/29.
//

#import "XGCScanViewController.h"
// XGCMain
#import <XGCMain/XGCMainRoute.h>
#import <XGCMain/UIView+XGCView.h>
#import <XGCMain/UIImage+XGCImage.h>
// tool
#import <AVFoundation/AVFoundation.h>
// controller
#import "XGCScanInfosViewController.h"
// thridparty
#import <Masonry/Masonry.h>

@interface XGCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// 图片
@property (nonatomic, strong) UIImageView *imageView;
/// 存放小绿点
@property (nonatomic, strong) UIView *containerView;
/// 相机管理者
@property (nonatomic, strong) AVCaptureSession *captureSession;
/// 图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/// 图片选择器
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation XGCScanViewController

- (struct XGCMainViewConfiguration)configuration {
    struct XGCMainViewConfiguration configuration = [super configuration];
    configuration.prefersNavigationBarHidden = true;
    return configuration;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        imageView;
    });
    self.containerView = ({
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        view;
    });
    ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"scan_return" inResource:@"XGCScan"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
            make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
        }];
    });
    ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:@"相册" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(albumButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
            make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
        }];
    });
    // 通知
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(captureSessionRuntimeErrorNotification:) name:AVCaptureSessionRuntimeErrorNotification object:nil];
    // 检测权限
    [self authorizationStatus];
}

#pragma mark - notification
- (void)captureSessionRuntimeErrorNotification:(NSNotification *)noti {
#if DEBUG
    NSLog(@"noti=%@", noti);
#endif
#if TARGET_IPHONE_SIMULATOR
#else
    NSError *error = [noti.userInfo objectForKey:AVCaptureSessionErrorKey];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:(error.localizedDescription ?: @"相机启动失败，请返回重试") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {[self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    });
#endif
}

#pragma mark func
- (void)authorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            NSString *message = [NSString stringWithFormat:@"请前往“设置-%@”打开相机权限", [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限未开启" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:alert completion:nil];
        } break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{ [self authorizationStatus]; });
            }];
        } break;
        default: [self initializeCaptureSession];
    }
}

- (void)initializeCaptureSession {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        return;
    }
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        return;
    }
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    if ([self.captureSession canAddOutput:output]) {
        [self.captureSession addOutput:output];
    }
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 预览图层
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    // 开启
    [self startRunning];
}

- (void)startRunning {
    if (!self.captureSession.isRunning) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.captureSession startRunning];
        });
    }
    [self cleanContainerViewSubviews];
}

- (void)stopRunning {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
}

#pragma mark action
- (void)backButtonTouchUpInside {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)albumButtonTouchUpInside {
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)featureTouchUpInside:(UIButton *)sender {
    [self routeStringValue:[sender titleForState:UIControlStateDisabled]];
}

- (void)routeStringValue:(NSString *)stringValue {
    if (stringValue.length == 0) {
        return;
    }
#if DEBUG
    NSLog(@"stringValue=%@", stringValue);
#endif
    __kindof UIViewController *viewController = nil;
    NSURL *URL = [NSURL URLWithString:stringValue];
    if ([XGCMainRoute canRouteURL:URL withParameters:nil]) {
        viewController = [XGCMainRoute routeControllerForURL:URL];
    } else if (URL && URL.scheme.length > 0 && [XGCMainRoute canRouteURL:[NSURL URLWithString:@"xinggc://XGCWebView"]]) {
        viewController = [XGCMainRoute routeControllerForURL:[NSURL URLWithString:@"xinggc://XGCWebView"] withParameters:@{@"URL" : URL}];
    } else {
        viewController = [XGCScanInfosViewController XGCScanInfos:stringValue];
    }
    if (!viewController) {
        return;
    }
    // 停止相机
    [self stopRunning];
    // 推送到其他页面
    NSMutableArray <__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:(self.navigationController.viewControllers ?: @[])];
    [viewControllers removeObject:self];
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)cleanContainerViewSubviews {
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.imageView.image = nil;
}

#pragma mark lifecy
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.previewLayer.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [self stopRunning];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0) {
        return;
    }
    // 坐标转换
    __block NSMutableArray <__kindof AVMetadataMachineReadableCodeObject *> *temps = [NSMutableArray array];
    [metadataObjects enumerateObjectsUsingBlock:^(__kindof AVMetadataObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AVMetadataMachineReadableCodeObject *metadataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        if (metadataObject && [metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            [temps addObject:metadataObject];
        }
    }];
    if (temps.count == 0) {
        return;
    }
    [self stopRunning];
    // 清除小绿点
    [self cleanContainerViewSubviews];
    // 添加按钮
    [temps enumerateObjectsUsingBlock:^(__kindof AVMetadataMachineReadableCodeObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 15.0;
        button.backgroundColor = UIColor.greenColor;
        [button setTitle:obj.stringValue forState:UIControlStateDisabled];
        button.frame = CGRectMake(CGRectGetMidX(obj.bounds), CGRectGetMidY(obj.bounds), 30.0, 30.0);
        [button addTarget:self action:@selector(featureTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
    }];
    if (temps.count > 1) {
        return;
    }
    [self routeStringValue:temps.firstObject.stringValue];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    image = [self fixOrientation:image];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    if (!detector) {
        return;
    }
    NSMutableArray <CIQRCodeFeature *> *features = [NSMutableArray array];
    [[detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]] enumerateObjectsUsingBlock:^(CIFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CIQRCodeFeature class]]) {
            [features addObject:(CIQRCodeFeature *)obj];
        }
    }];
    if (features.count == 0) {
        [self.view makeToast:@"未检测到任何二维码信息" position:XGCToastViewPositionCenter];
        return;
    }
    [self cleanContainerViewSubviews];
    self.imageView.image = image;
    // 图片缩放比例
    CGFloat scale = MIN(CGRectGetWidth(self.view.frame) / image.size.width, CGRectGetHeight(self.view.frame) / image.size.height);
    CGFloat offsetX = (self.view.frame.size.width - scale * image.size.width) / 2.0;
    CGFloat offsetY = (self.view.frame.size.height - scale * image.size.height) / 2.0;
    [features enumerateObjectsUsingBlock:^(CIQRCodeFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 15.0;
        button.backgroundColor = UIColor.greenColor;
        [button setTitle:obj.messageString forState:UIControlStateDisabled];
        CGRect frame = obj.bounds;
        // CIFaceFeature中的bounds的Y值 是距离底部的值
        frame.origin.y = image.size.height - obj.bounds.origin.y - obj.bounds.size.height;
        button.center = CGPointMake(CGRectGetMidX(frame) * scale + offsetX, CGRectGetMidY(frame) * scale + offsetY);
        button.bounds = CGRectMake(0, 0, 30.0, 30.0);
        [button addTarget:self action:@selector(featureTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
    }];
    if (features.count > 1) {
        return;
    }
    [self routeStringValue:features.firstObject.messageString];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown: case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
        } break;
        case UIImageOrientationLeft: case UIImageOrientationLeftMirrored: {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
        } break;
        case UIImageOrientationRight: case UIImageOrientationRightMirrored: {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
        } break;
        default: break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored: case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        } break;
        case UIImageOrientationLeftMirrored: case UIImageOrientationRightMirrored: {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        } break;
        default: break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored: {
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
        } break;
        default: {
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
        } break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
