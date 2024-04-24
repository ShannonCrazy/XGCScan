//
//  XGCURLProtocol.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XGCURLProtocol <NSObject>
@required
/// 协议
- (NSString *)scheme;
/// 域名（IP）
- (NSString *)host;
/// 端口
- (nullable NSNumber *)port;
/// 访问资源的路径
- (NSString *)path;
/// WKWebView打开office文档时处理的域名（IP）
- (NSString *)WKWebViewOfficeHost;
/// WKWebView打开office文档时处理的端口
- (nullable NSNumber*)WKWebViewOfficePort;
/// 路由转发地址
- (nullable NSString *)env;
/// 用户服务协议
- (NSString *)terms;
/// 隐私权政策
- (NSString *)policy;
@end

NS_ASSUME_NONNULL_END
