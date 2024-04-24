//
//  XGCMainFormDescriptor.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import "XGCMainFormDescriptor.h"

@implementation XGCMainFormDescriptor

+ (instancetype)formDescriptor {
    return [XGCMainFormDescriptor new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.sections = [NSMutableArray array];
    }
    return self;
}

@end
