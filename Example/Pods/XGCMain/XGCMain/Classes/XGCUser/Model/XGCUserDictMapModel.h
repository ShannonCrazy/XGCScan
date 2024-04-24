//
//  XGCUserDictMapModel.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCUserDictMapModel : NSObject
/// 编号
@property (nonatomic, copy) NSString *cId;
/// 编码
@property (nonatomic, copy, nullable) NSString *cCode;
/// 名称
@property (nonatomic, copy) NSString *cName;
/// 是否展示
@property (nonatomic, copy) NSString *cIsShow;
/// 附加信息
@property (nonatomic, copy) NSString *exlCol;
/// 是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/// 是否可用
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
/// 是否展开
@property (nonatomic, assign, getter=isOpen) BOOL open;
/// 等级
@property (nonatomic, assign) NSUInteger level;
/// 子项
@property (nonatomic, strong, nullable) NSMutableArray <XGCUserDictMapModel *> *children;
/// 快捷初始化
+ (instancetype)cCode:(nullable NSString *)cCode cName:(NSString *)cName;
@end

NS_ASSUME_NONNULL_END
