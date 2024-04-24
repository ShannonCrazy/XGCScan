//
//  XGCMainFormSectionDescriptor.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import "XGCMainFormSectionDescriptor.h"

@implementation XGCMainFormSectionDescriptor

+ (instancetype)formSectionDescriptor {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.rows = [NSMutableArray array];
    }
    return self;
}

@end

@implementation XGCMainFormSectionConfigDescriptor

- (instancetype)init {
    if (self = [super init]) {
        self.rowHeight = UITableViewAutomaticDimension;
        self.contentEdgeInsets = UIEdgeInsetsMake(14.0, 20.0, 14.0, 20.0);
    }
    return self;
}

@end

@implementation XGCMainFormSectionDefaultConfigDescriptor

- (instancetype)init {
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

@end

@implementation XGCMainFormSectionCustomConfigDescriptor

@end
