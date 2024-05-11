//
//  NSArray+XGCArray.h
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (XGCArray)
/// 随机获取几个值
/// - Parameter count: 总共要获取几个值
- (NSArray <ObjectType> *)arc4random:(NSUInteger)count;
@end

@interface NSMutableArray<ObjectType> (XGCMutableArray)
/// 移除第一个元素
- (void)removeFirstObject;
/// 替换某个对象（系统方法只有replaceObjectAtIndex:withObject:，要获取Index步骤内部实现）
/// @param object 被替换的对象，不能为空
/// @param anObject 替换的对象，不能为空
- (void)replaceObjectIn:(ObjectType)object withObject:(ObjectType)anObject;

/// 在anObject位置的后面插入一个object，如果数组中找不到anObject这个对象，那么就放在数组的最后一位
/// @param object 对象
/// @param anObject 比对对象
- (void)insertObject:(ObjectType)object afterObject:(ObjectType)anObject;

/// 在anObject位置的前面插入一个object，如果数组中找不到anObject这个对象，那么就放在数组的最后一位
/// @param object 对象
/// @param anObject 比对对象
- (void)insertObject:(ObjectType)object beforeObject:(ObjectType)anObject;

/// 从某个下标开始已删除后面的数据
/// @param index 下标位置
- (void)removeObjectFromIndex:(NSUInteger)index;

/// 移动某个数据到指定下标
/// @param object 对象
/// @param index 下标位置
- (void)moveObject:(ObjectType)object toIndex:(NSUInteger)index;
@end
NS_ASSUME_NONNULL_END
