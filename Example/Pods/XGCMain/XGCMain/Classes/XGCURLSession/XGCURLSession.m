//
//  XGCURLSession.m
//  xinggc
//
//  Created by 凌志 on 2023/11/16.
//

#import "XGCURLSession.h"
// tool
#import "XGCAFNetworking.h"
#import "XGCURLSessionDelegate.h"
// XGCMain
#import "XGCUserManager.h"
#import "XGCURLManagerCenter.h"

@interface XGCURLSession ()
/// 队列
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, XGCURLSessionDelegate *> *dataTasks;
@end

@implementation XGCURLSession

+ (instancetype)shareSession {
    static XGCURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[XGCURLSession alloc] init];
    });
    return session;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dataTasks = [NSMutableDictionary dictionary];
        // https配置
//        NSData *pkcs12_data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"api.xinggongcheng.com" ofType:@"p12"]];
//        [XGCAFNetworking pkcs12_data:pkcs12_data password:@"Xinggc2018"];
        // 通知
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserLogoutNotification) name:XGCUserLogoutNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserKickOutNotification) name:XGCUserKickOutNotification object:nil];
    }
    return self;
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters aTarget:(NSObject *)aTarget callback:(void (^)(id _Nullable, NSError * _Nullable))callback {
    void(^completionHandler)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nonnull error) = ^(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nonnull error) {
        [self dataTask:task responseObject:responseObject error:error];
    };
    NSURLSessionDataTask *dataTask = [XGCAFNetworking POST:[self URLString:URLString] parameters:[self parameters:parameters encoding:YES] headers:[self headers:nil] aTarget:aTarget completionHandler:completionHandler];
    if (!dataTask) {
        return;
    }
    [[XGCURLSession shareSession].dataTasks setObject:[XGCURLSessionDelegate delegate:dataTask URLString:URLString parameters:parameters aTarget:aTarget callback:callback] forKey:@(dataTask.taskIdentifier)];
}

+ (void)JSONPOST:(NSString *)URLString parameters:(id)parameters aTarget:(NSObject *)aTarget callback:(void (^)(id _Nullable, NSError * _Nullable))callback {
    void(^completionHandler)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nonnull error) = ^(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nonnull error) {
        [self dataTask:task responseObject:responseObject error:error];
    };
    NSURLSessionDataTask *dataTask = [XGCAFNetworking JSONPOST:[self URLString:URLString] parameters:[self parameters:parameters encoding:NO] headers:[self headers:nil] aTarget:aTarget completionHandler:completionHandler];
    if (!dataTask) {
        return;
    }
    [[XGCURLSession shareSession].dataTasks setObject:[XGCURLSessionDelegate delegate:dataTask URLString:URLString parameters:parameters aTarget:aTarget callback:callback] forKey:@(dataTask.taskIdentifier)];
}

+ (void)cancel:(NSString *)URLString aTarget:(NSObject *)aTarget {
    [XGCAFNetworking cancel:[self URLString:URLString] aTarget:aTarget];
}

+ (void)dataTask:(NSURLSessionTask *)dataTask responseObject:(nullable id)responseObject error:(nullable NSError *)error {
    XGCURLSession *shareSession = [XGCURLSession shareSession];
    // 获取代理对象
    XGCURLSessionDelegate *delegate = [shareSession.dataTasks objectForKey:@(dataTask.taskIdentifier)];
    if (!delegate) {
        return;
    }
    [shareSession.dataTasks removeObjectForKey:@(dataTask.taskIdentifier)];
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSInteger code = [dictionary[@"code"] integerValue];
        switch (code) {
            case 10000: { // 成功
                if (delegate.callback) {
                    NSDictionary *data = [dictionary objectForKey:@"data"];
                    if ([data isKindOfClass:[NSDictionary class]] && [data.allKeys containsObject:@"rows"] && [data.allKeys containsObject:@"totals"]) {
                        delegate.callback([data objectForKey:@"rows"], error);
                    } else {
                        delegate.callback(data, error);
                    }
                }
            } break;
            case 9999: case 10004: case 10005: case 10007: case 20002: { // 账号异常、token超时等8
                [NSNotificationCenter.defaultCenter postNotificationName:XGCUserKickOutNotification object:nil userInfo:responseObject];
            } break;
            default: { // 其他当做失败
                if (delegate.callback) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:responseObject[@"desc"] ?: @"网络请求失败，请稍后再试！" forKey:NSLocalizedDescriptionKey];
                    delegate.callback(nil, error ?: [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:userInfo]);
                }
            } break;
        }
    } else if (error) {
        delegate.callback ? delegate.callback(nil, error) : nil;
    }
}

#pragma mark func
+ (NSString *)URLString:(NSString *)URLString {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    __kindof NSObject <XGCURLProtocol> *configuration = XGCURLManagerCenter.defaultURLManager.currentConfiguration;
    components.scheme = configuration.scheme;
    components.host = configuration.host;
    components.port = configuration.port;
    components.path = configuration.path;
    return [components.URL URLByAppendingPathComponent:URLString].absoluteString;
}

+ (nullable id)parameters:(nullable id)parameters encoding:(BOOL)encoding {
    if ([parameters isKindOfClass:[NSArray class]]) {
        return encoding ? [NSSet setWithArray:(NSArray *)parameters] : parameters;
    }
    if (parameters && ![parameters isKindOfClass:[NSDictionary class]]) {
        return parameters;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:parameters ?: @{}];
    NSString *companyId = XGCUM.cUser.userMap.companyId;
    if (companyId.length > 0) {
        [dictionary setValue:companyId forKey:@"companyId"];
    }
    return encoding ? XGCQueryDictionaryFromDictionary(dictionary) : dictionary;
}

CG_INLINE NSDictionary *XGCQueryDictionaryFromDictionary(NSDictionary *dictionary) {
    NSMutableDictionary *maps = [NSMutableDictionary dictionaryWithDictionary:dictionary ?: @{}];
    [maps enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [maps setObject:XGCQueryDictionaryFromDictionary(obj) forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [maps setObject:[NSSet setWithArray:(NSArray *)obj] forKey:key];
        }
    }];
    return maps;
}

+ (NSDictionary <NSString *, NSString *> *)headers:(nullable NSDictionary <NSString *, NSString *> *)headers {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:headers ?: @{}];
    dictionary[@"requestDeviceType"] = @"iOS";
    dictionary[@"Authorization"] = XGCUM.cUser.token;
    dictionary[@"env"] = XGCURLManagerCenter.defaultURLManager.currentConfiguration.env;
    return dictionary;
}

#pragma mark notification
- (void)cUserLogoutNotification {
    [self.dataTasks enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull key, XGCURLSessionDelegate * _Nonnull obj, BOOL * _Nonnull stop) {
        [XGCURLSession cancel:obj.URLString aTarget:obj.aTarget];
    }];
    [self.dataTasks removeAllObjects];
}

- (void)cUserKickOutNotification {
    [self.dataTasks enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull key, XGCURLSessionDelegate * _Nonnull obj, BOOL * _Nonnull stop) {
        [XGCURLSession cancel:obj.URLString aTarget:obj.aTarget];
    }];
    [self.dataTasks removeAllObjects];
}

@end
