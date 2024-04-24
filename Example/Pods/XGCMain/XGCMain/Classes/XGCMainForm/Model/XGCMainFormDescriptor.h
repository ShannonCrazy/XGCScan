//
//  XGCMainFormDescriptor.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import <Foundation/Foundation.h>
// model
#import "XGCMainFormSectionDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainFormDescriptor : NSObject
/// 组数据
@property (nonatomic, strong) NSMutableArray <XGCMainFormSectionDescriptor *> *sections;

+ (instancetype)formDescriptor;
@end

NS_ASSUME_NONNULL_END
