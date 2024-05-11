//
//  XGCWebViewController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCWebViewController.h"
// tool
#import <WebKit/WebKit.h>
//
#if __has_include ("XGCURLManagerCenter.h")
#import "XGCURLManagerCenter.h"
#endif

@interface XGCWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKDownloadDelegate, UIDocumentInteractionControllerDelegate>
/// 链接
@property (nonatomic, strong) NSURL *URL;
/// 控件
@property (nonatomic, strong) WKWebView *wkWebView;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
/// 关闭按钮
@property (nonatomic, strong) UIBarButtonItem *canGoBack;
/// 下载
@property (nonatomic, strong) WKDownload *download API_AVAILABLE(ios(14.5));
/// 下载路径
@property (nonatomic, strong) NSURL *destination;
/// 分享控件
@property (nonatomic, strong) UIDocumentInteractionController *interactionController;
@end

@implementation XGCWebViewController

+ (instancetype)XGCWebView:(NSURL *)URL {
    XGCWebViewController *viewController = [[XGCWebViewController alloc] init];
    viewController.URL = URL;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.wkWebView = ({
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        wkWebView.UIDelegate = self;
        wkWebView.navigationDelegate = self;
        wkWebView.backgroundColor = UIColor.clearColor;
        wkWebView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:wkWebView];
        wkWebView;
    });
    // addObserver
    {
        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    // UIProgressView
    self.progressView = ({
        UIProgressView *view = [[UIProgressView alloc] init];
        view.progressTintColor = [UIColor.blueColor colorWithAlphaComponent:0.7];
        view.trackTintColor = UIColor.clearColor;
        [self.view addSubview:view];
        view;
    });
    // 加载
    if (self.URL) {
        if ([self.URL.scheme isEqualToString:@"file"]) {
            [self.wkWebView loadFileURL:self.URL allowingReadAccessToURL:self.URL.URLByDeletingLastPathComponent];
        } 
#if __has_include ("XGCURLManagerCenter.h")
        else if ([self isOfficeExtension:self.URL.pathExtension]) {
            __kindof NSObject <XGCURLProtocol> *configuration = XGCURLManagerCenter.defaultURLManager.currentConfiguration;
            NSURLComponents *components = [[NSURLComponents alloc] init];
            components.scheme = [configuration scheme];
            components.host = [configuration WKWebViewOfficeHost];
            components.port = [configuration WKWebViewOfficePort];
            components.path = @"/fileView.html";
            components.query = [NSString stringWithFormat:@"sourceUri=oss://%@%@&title=%@", [self.URL.host componentsSeparatedByString:@"."].firstObject, self.URL.path, self.URL.lastPathComponent.stringByDeletingPathExtension];
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:components.URL]];
        }
#endif
        else {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateViewSubviewsFrame];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self updateViewSubviewsFrame];
}

- (void)dealloc {
    if (!self.isViewLoaded) {
        return;
    }
    if (@available(iOS 14.5, *)) {
        [self.download cancel:nil];
    }
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"canGoBack"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark func
- (BOOL)isOfficeExtension:(NSString *)pathExtension {
    return [@[@"doc", @"docx", @"dotx", @"dotm", @"xls",@"xlsx",@"xlsm",@"xlt", @"xlsb", @"xltx", @"xltm", @"xlam", @"csv", @"ppt", @"pptx", @"pptm", @"potx", @"potm", @"ppsx", @"ppsm"] containsObject:pathExtension];
}

- (void)updateViewSubviewsFrame {
    self.wkWebView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, self.view.safeAreaInsets.top, CGRectGetWidth(self.view.frame), 2.0);
}

#pragma mark super
- (void)goBack:(UIBarButtonItem *)sender {
    self.wkWebView.canGoBack ? [self.wkWebView goBack] : [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <WKUIDelegate>
/// 打开新窗口
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

/// webview被关闭
- (void)webViewDidClose:(WKWebView *)webView {
}

/// 显示一个确认框，只有确定
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler ? completionHandler() : nil;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 显示一个确认框，有确定和取消
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler ? completionHandler(NO) : nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler ? completionHandler(YES) : nil;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 显示一个输入框，有文本框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler ? completionHandler(alert.textFields[0].text ? : @"") : nil;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 请求媒体权限
- (void)webView:(WKWebView *)webView requestMediaCapturePermissionForOrigin:(WKSecurityOrigin *)origin initiatedByFrame:(WKFrameInfo *)frame type:(WKMediaCaptureType)type decisionHandler:(void (^)(WKPermissionDecision decision))decisionHandler API_AVAILABLE(ios(15.0)){
    NSString *message = [NSString stringWithFormat:@"网页“%@”", origin.host];
    switch (type) {
        case WKMediaCaptureTypeCamera: [message stringByAppendingString:@"想获取您的摄像头"];
        case WKMediaCaptureTypeMicrophone: [message stringByAppendingString:@"想获取您的麦克风"];
        case WKMediaCaptureTypeCameraAndMicrophone: [message stringByAppendingString:@"想获取您的摄像头和麦克风"];
        default: break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decisionHandler ? decisionHandler(WKPermissionDecisionDeny) : nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        decisionHandler ? decisionHandler(WKPermissionDecisionGrant) : nil;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 请求陀螺仪权限
- (void)webView:(WKWebView *)webView requestDeviceOrientationAndMotionPermissionForOrigin:(WKSecurityOrigin *)origin initiatedByFrame:(WKFrameInfo *)frame decisionHandler:(void (^)(WKPermissionDecision decision))decisionHandler API_AVAILABLE(ios(15.0)) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"网页“%@”想访问您的设备陀螺仪", origin.host] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decisionHandler ? decisionHandler(WKPermissionDecisionDeny) : nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        decisionHandler ? decisionHandler(WKPermissionDecisionGrant) : nil;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 已废弃
//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo {
//}
//- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions {
//}
//- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
//}

- (void)webView:(WKWebView *)webView contextMenuConfigurationForElement:(WKContextMenuElementInfo *)elementInfo completionHandler:(void (^)(UIContextMenuConfiguration * _Nullable configuration))completionHandler API_AVAILABLE(ios(13.0)) {
}

- (void)webView:(WKWebView *)webView contextMenuWillPresentForElement:(WKContextMenuElementInfo *)elementInfo API_AVAILABLE(ios(13.0)){
}

- (void)webView:(WKWebView *)webView contextMenuForElement:(WKContextMenuElementInfo *)elementInfo willCommitWithAnimator:(id <UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)){
}

- (void)webView:(WKWebView *)webView contextMenuDidEndForElement:(WKContextMenuElementInfo *)elementInfo API_AVAILABLE(ios(13.0)){
}


- (void)webView:(WKWebView *)webView showLockdownModeFirstUseMessage:(NSString *)message completionHandler:(void (^)(WKDialogResult))completionHandler API_AVAILABLE(ios(16.0)){
    
}

- (void)webView:(WKWebView *)webView willPresentEditMenuWithAnimator:(id<UIEditMenuInteractionAnimating>)animator API_AVAILABLE(ios(16.0)){
    
}

- (void)webView:(WKWebView *)webView willDismissEditMenuWithAnimator:(id<UIEditMenuInteractionAnimating>)animator API_AVAILABLE(ios(16.0)){
    
}

#pragma mark - <WKNavigationDelegate>
/// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (@available(iOS 14.5, *)) {
        policy = navigationAction.shouldPerformDownload ? WKNavigationActionPolicyDownload : WKNavigationActionPolicyAllow;
    }
    decisionHandler ? decisionHandler(policy) : nil;
}

/// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler API_AVAILABLE(ios(13.0)) {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (@available(iOS 14.5, *)) {
        policy = navigationAction.shouldPerformDownload ? WKNavigationActionPolicyDownload : WKNavigationActionPolicyAllow;
    }
    decisionHandler ? decisionHandler(policy, preferences) : nil;
}

/// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    WKNavigationResponsePolicy policy = WKNavigationResponsePolicyAllow;
    if (@available(iOS 14.5, *)) {
        policy = navigationResponse.canShowMIMEType ? WKNavigationResponsePolicyAllow : WKNavigationResponsePolicyDownload;
    }
    decisionHandler ? decisionHandler(policy) : nil;
}

/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

/// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
#if DEBUG
    NSLog(@"%s-%@", __func__, error);
#endif
}

/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

/// 加载页面失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
#if DEBUG
    NSLog(@"%s-%@", __func__, error);
#endif
}

/// https权限认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        BOOL flag = challenge.previousFailureCount == 0;
        NSURLSessionAuthChallengeDisposition disposition = flag ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        NSURLCredential *credential = flag ? [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] : nil;
        completionHandler ? completionHandler(disposition, credential) : nil;
    } else {
        completionHandler ? completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil) : nil;
    }
}

/// 当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

/// 使用已弃用的TLS(Transport Layer Security )版本建立网络连接时调用
- (void)webView:(WKWebView *)webView authenticationChallenge:(NSURLAuthenticationChallenge *)challenge shouldAllowDeprecatedTLS:(void (^)(BOOL))decisionHandler {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    decisionHandler ? decisionHandler(YES) : nil;
}

/// web操作变成下载
- (void)webView:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction didBecomeDownload:(WKDownload *)download API_AVAILABLE(ios(14.5)) {
    self.download = download;
    self.download.delegate = self;
}

/// web响应变成下载
- (void)webView:(WKWebView *)webView navigationResponse:(WKNavigationResponse *)navigationResponse didBecomeDownload:(WKDownload *)download API_AVAILABLE(ios(14.5)) {
    self.download = download;
    self.download.delegate = self;
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.wkWebView) {
        return;
    }
    if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = [self.wkWebView.title stringByRemovingPercentEncoding];
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        if (!self.canGoBack) {
            self.canGoBack = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(canGoBackButtonAction:)];
        }
        NSMutableArray <UIBarButtonItem *> *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems ?: @[]];
        if (self.wkWebView.backForwardList.backList.count > 0) {
            [leftBarButtonItems addObject:self.canGoBack];
        } else {
            [leftBarButtonItems removeObject:self.canGoBack];
        }
        self.navigationItem.leftBarButtonItems = leftBarButtonItems;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if (self.wkWebView.estimatedProgress >= 1) {
            void (^animations)(void) = ^(void) {
                self.progressView.alpha = 0.0;
            };
            [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:animations completion:nil];
        } else {
            self.progressView.alpha = 1.0;
        }
    }
}

#pragma mark WKDownloadDelegate
/// 文件开始下载的时候询问需要保存的位置
- (void)download:(WKDownload *)download decideDestinationUsingResponse:(NSURLResponse *)response suggestedFilename:(NSString *)suggestedFilename completionHandler:(void (^)(NSURL * _Nullable destination))completionHandler API_AVAILABLE(ios(14.5)) {
    NSURL *URL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    completionHandler ? completionHandler(self.destination = [URL URLByAppendingPathComponent:suggestedFilename]) : nil;
}

- (void)download:(WKDownload *)download willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request decisionHandler:(void (^)(WKDownloadRedirectPolicy))decisionHandler  API_AVAILABLE(ios(14.5)) {
    decisionHandler ? decisionHandler(WKDownloadRedirectPolicyAllow) : nil;
}

- (void)download:(WKDownload *)download didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler API_AVAILABLE(ios(14.5)) {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        BOOL flag = challenge.previousFailureCount == 0;
        NSURLSessionAuthChallengeDisposition disposition = flag ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        NSURLCredential *credential = flag ? [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] : nil;
        completionHandler ? completionHandler(disposition, credential) : nil;
    } else {
        completionHandler ? completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil) : nil;
    }
}

- (void)downloadDidFinish:(WKDownload *)download API_AVAILABLE(ios(14.5)) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.destination.path]) {
        return;
    }
    // 设置分享页面的URL
    self.interactionController.URL = self.destination;
    // 设置分享页面显示的名称
    self.interactionController.name = [self.description.lastPathComponent stringByRemovingPercentEncoding];
    // 弹出分享页面
    [self.interactionController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)download:(WKDownload *)download didFailWithError:(NSError *)error resumeData:(NSData *)resumeData API_AVAILABLE(ios(14.5)) {
    
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller {
    
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

#pragma mark action
- (void)canGoBackButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark lazy
- (UIDocumentInteractionController *)interactionController {
    if (!_interactionController) {
        _interactionController = [UIDocumentInteractionController interactionControllerWithURL:self.destination];
        _interactionController.delegate = self;
    }
    return _interactionController;
}

@end
