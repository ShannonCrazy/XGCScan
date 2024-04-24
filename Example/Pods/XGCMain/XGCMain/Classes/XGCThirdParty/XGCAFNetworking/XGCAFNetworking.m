//
//  XGCAFNetworking.m
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import "XGCAFNetworking.h"
// tool
#import "XGCAFNetworkingDelegate.h"
// thirdParty
#import <AFNetworking/AFNetworking.h>

#ifdef DEBUG
#define XGCNSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define XGCNSLog(FORMAT, ...)
#endif

@interface XGCAFNetworking ()
@property (nonatomic, strong) NSData *pkcs12_data;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, XGCAFNetworkingDelegate *> *dataTasks;
@end

@implementation XGCAFNetworking

#pragma mark public

+ (void)pkcs12_data:(NSData *)pkcs12_data password:(NSString *)password {
    [XGCAFNetworking shareNetworking].pkcs12_data = pkcs12_data;
    [XGCAFNetworking shareNetworking].password = password;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDataTask *)JSONPOST:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"JSONPOST" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] dataTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
}

+ (NSURLSessionDownloadTask *)download:(NSString *)URLString destination:(NSURL *)destination progress:(void (^)(NSProgress * _Nonnull))progress aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURL * _Nullable, NSError * _Nullable))completionHandler {
    return [[XGCAFNetworking shareNetworking] download:URLString destination:destination progress:progress aTarget:aTarget completionHandler:completionHandler];
}

+ (void)cancel:(NSString *)URLString aTarget:(NSObject *)aTarget {
    XGCAFNetworkingDelegate *delegate = [[XGCAFNetworking shareNetworking] delegateFor:URLString aTarget:aTarget];
    if (delegate) {
        [delegate cancelByUser];
    }
}

#pragma mark private
+ (instancetype)shareNetworking {
    static XGCAFNetworking *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[XGCAFNetworking alloc] init];
    });
    return session;
}

- (instancetype)init {
    if (self = [super init]) {
        self.lock = [[NSLock alloc] init];
        self.session = [AFHTTPSessionManager manager];
        
        __weak typeof(self) this = self;
        [self.session setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential) {
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
            if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if ([this.session.securityPolicy evaluateServerTrust:protectionSpace.serverTrust forDomain:protectionSpace.host]) {
                    *credential = [NSURLCredential credentialForTrust:protectionSpace.serverTrust];
                    disposition = *credential ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengePerformDefaultHandling;
                } else {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                if (this.pkcs12_data && this.password) {
                    NSDictionary *options = [NSDictionary dictionaryWithObject:this.password forKey:(__bridge  id)kSecImportExportPassphrase];
                    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
                    if (SecPKCS12Import((__bridge CFDataRef)this.pkcs12_data, (__bridge CFDictionaryRef)options, &items) == errSecSuccess) {
                        CFDictionaryRef first = CFArrayGetValueAtIndex(items, 0);
                        SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(first, kSecImportItemIdentity);
                        SecCertificateRef certificateRef = NULL;
                        SecIdentityCopyCertificate(identityRef, &certificateRef);
                        *credential = [NSURLCredential credentialWithIdentity:identityRef certificates:@[(__bridge  id)certificateRef] persistence:NSURLCredentialPersistencePermanent];
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    }
                }
            }
            return disposition;
        }];
        self.dataTasks = [NSMutableDictionary dictionary];
        // 网络监听
        [self.session.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [this.dataTasks.allValues makeObjectsPerformSelector:@selector(cancelByCellular)];
        }];
        // 文件下载监听
        NSNotificationCenter *defaultCenter = NSNotificationCenter.defaultCenter;
        [defaultCenter addObserver:self selector:@selector(didFailToMoveFileNotification:) name:AFURLSessionDownloadTaskDidFailToMoveFileNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(didMoveFileSuccessfullyNotification:) name:AFURLSessionDownloadTaskDidMoveFileSuccessfullyNotification object:nil];
    }
    return self;
}

- (nullable NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary <NSString *, NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler {
    if (URLString.length == 0) {
        return nil;
    }
    XGCAFNetworkingDelegate *delegate = [self delegateFor:URLString aTarget:aTarget];
    if (delegate) {
        return nil;
    }
    if (delegate.isCancelByUser) {
        [self removeObject:delegate];
        return nil;
    }
    if (!delegate) {
        delegate = [XGCAFNetworkingDelegate method:method URLString:URLString parameters:parameters headers:headers aTarget:aTarget completionHandler:completionHandler];
    }
    return [self dataTaskWithDelegate:delegate];
}

- (NSURLSessionDataTask *)dataTaskWithDelegate:(XGCAFNetworkingDelegate *)delegate {
    self.session.requestSerializer = [delegate.method hasPrefix:@"JSON"] ? [AFJSONRequestSerializer serializer] : [AFHTTPRequestSerializer serializer];
    self.session.requestSerializer.timeoutInterval = 15.0;
    self.session.responseSerializer = [AFJSONResponseSerializer serializer];
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    // 成功失败回调
    void (^success) (NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        XGCAFNetworkingDelegate *delegate = [self delegateFor:task];
        if (delegate) {
            [self removeObject:delegate];
            XGCNSLog(@"URLString=%@\nresponseObject=%@", delegate.URLString, responseObject);
            delegate.completionHandler ? delegate.completionHandler(delegate.firstDataTask, responseObject, nil) : nil;
        }
    };
    void (^failure) (NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        XGCAFNetworkingDelegate *delegate = [self delegateFor:task];
        if (delegate) {
            XGCNSLog(@"URLString=%@\nerror=%@", delegate.URLString, error);
            if (delegate.isCancelByUser) {
                [self removeObject:delegate];
            } else if (delegate.previousFailureCount < 2) {
                [self performSelector:@selector(relapseRequestIn:) withObject:delegate afterDelay:3.0];
            } else {
                [self removeObject:delegate];
                delegate.completionHandler ? delegate.completionHandler(delegate.firstDataTask, nil, error) : nil;
            }
        }
    };
    XGCNSLog(@"URLString=%@\nparameters=%@", delegate.URLString, delegate.parameters);
    // 发起请求
    NSURLSessionDataTask *dataTask = nil;
    if ([delegate.method hasSuffix:@"GET"]) {
        dataTask = [self.session GET:delegate.URLString parameters:delegate.parameters headers:delegate.headers progress:nil success:success failure:failure];
    } else if ([delegate.method hasSuffix:@"POST"]) {
        dataTask = [self.session POST:delegate.URLString parameters:delegate.parameters headers:delegate.headers progress:nil success:success failure:failure];
    } else if ([delegate.method isEqualToString:@"PUT"]) {
        dataTask = [self.session PUT:delegate.URLString parameters:delegate.parameters headers:delegate.headers success:delegate.success failure:delegate.failure];
    } else if ([delegate.method isEqualToString:@"PATCH"]) {
        dataTask= [self.session PATCH:delegate.URLString parameters:delegate.parameters headers:delegate.headers success:delegate.success failure:delegate.failure];
    } else if ([delegate.method isEqualToString:@"DELETE"]) {
        dataTask = [self.session DELETE:delegate.URLString parameters:delegate.parameters headers:delegate.headers success:delegate.success failure:delegate.failure];
    }
    // 记录代理
    [self setObject:delegate dataTask:dataTask];
    return dataTask;
}

- (NSURLSessionDownloadTask *)download:(NSString *)URLString destination:(NSURL *)destination progress:(nullable void (^)(NSProgress *downloadProgress))progress aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    if (URLString.length == 0 || !destination) {
        return nil;
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        return nil;
    }
    XGCAFNetworkingDelegate *delegate = [self delegateFor:URLString aTarget:aTarget];
    // 如果找到代理对象
    if (delegate) {
        return nil;
    }
    if (delegate.isCancelByUser) {
        [self removeObject:delegate];
        return nil;
    }
    if (!delegate) {
        delegate = [XGCAFNetworkingDelegate download:URLString destination:destination aTarget:aTarget completionHandler:completionHandler];
    }
    // 删除数据
    NSFileManager *defaultManager = NSFileManager.defaultManager;
    if ([defaultManager fileExistsAtPath:destination.path]) {
        [defaultManager removeItemAtURL:destination error:nil];
    }
    // 从 self.dataTasks 移除代理
    [self removeObject:delegate];
    // 发起请求
    NSURLSessionDownloadTask *dataTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination;
    } completionHandler:nil];
    // 记录代理
    [self setObject:delegate dataTask:dataTask];
    return dataTask;
}

- (nullable XGCAFNetworkingDelegate *)delegateFor:(NSString *)URLString aTarget:(NSObject *)aTarget {
    __block XGCAFNetworkingDelegate *delegate = nil;
    [self.lock lock];
    [self.dataTasks enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull key, XGCAFNetworkingDelegate * _Nonnull obj, BOOL * _Nonnull stop) {
        *stop = (delegate = [obj isEqual:URLString aTarget:aTarget]);
    }];
    [self.lock unlock];
    return delegate;
}

- (nullable XGCAFNetworkingDelegate *)delegateFor:(NSURLSessionTask *)task {
    [self.lock lock];
    XGCAFNetworkingDelegate *delegate = [self.dataTasks objectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
    return delegate;
}

- (void)relapseRequestIn:(XGCAFNetworkingDelegate *)delegate {
    if (delegate.isCancelByUser) {
        [self removeObject:delegate];
        return;
    }
    delegate.previousFailureCount ++;
    [self dataTaskWithDelegate:delegate];
}

- (void)setObject:(XGCAFNetworkingDelegate *)anObject dataTask:(__kindof NSURLSessionTask *)dataTask {
    if (!anObject || !dataTask) {
        return;
    }
    [self.lock lock];
    // 移除
    if (anObject.dataTask) {
        [self.dataTasks removeObjectForKey:@(anObject.dataTask.taskIdentifier)];
    }
    // 记录第一次请求生产的请求对象
    if (!anObject.firstDataTask) {
        anObject.firstDataTask = dataTask;
    }
    // 新增
    anObject.dataTask = dataTask;
    [self.dataTasks setObject:anObject forKey:@(anObject.dataTask.taskIdentifier)];
    [self.lock unlock];
}

- (void)removeObject:(XGCAFNetworkingDelegate *)anObject {
    if (!anObject.dataTask) {
        return;
    }
    [self.lock lock];
    [self.dataTasks removeObjectForKey:@(anObject.dataTask.taskIdentifier)];
    [self.lock unlock];
}

#pragma mark - NSNotification
- (void)didFailToMoveFileNotification:(NSNotification *)sender {
    NSURLSessionDownloadTask *task = sender.object;
    if ([task isKindOfClass:NSURLSessionDownloadTask.class]) {
        XGCAFNetworkingDelegate *delegate = [self delegateFor:task];
        if (!delegate) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            delegate.download ? delegate.download(delegate.destination, nil) : nil;
            [self removeObject:delegate];
        });
    }
}

- (void)didMoveFileSuccessfullyNotification:(NSNotification *)sender {
    NSURLSessionDownloadTask *task = sender.object;
    if ([task isKindOfClass:NSURLSessionDownloadTask.class]) {
        XGCAFNetworkingDelegate *delegate = [self delegateFor:task];
        if (!delegate) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            delegate.download ? delegate.download(nil, [NSError errorWithDomain:NSCocoaErrorDomain code:262 userInfo:sender.userInfo]) : nil;
            [self removeObject:delegate];
        });
    }
}

#pragma mark lifeCycle
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
