//
//  NSArray+XGCArray.m
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import "NSArray+XGCArray.h"

@implementation NSArray (XGCArray)
- (NSArray *)random:(NSUInteger)count {
    if (count >= self.count) {
        return self;
    }
    NSMutableSet *temps = [[NSMutableSet alloc] init];
    while ([temps count] < 3) {
        int index = arc4random() % self.count;
        [temps addObject:[self objectAtIndex:index]];
    }
    return temps.allObjects;
}
@end

@implementation NSMutableArray (XGCMutableArray)
- (void)removeFirstObject {
    if (self.count == 0) {
        return;
    }
    [self removeObjectAtIndex:0];
}

- (void)replaceObjectIn:(id)object withObject:(id)anObject {
    if (!object || !anObject || ![self containsObject:object]) {
        return;
    }
    [self replaceObjectAtIndex:[self indexOfObject:object] withObject:anObject];
}

- (void)insertObject:(id)object afterObject:(id)anObject {
    if (!object || !anObject) {
        return;
    }
    NSUInteger index = [self indexOfObject:anObject];
    if (index == NSNotFound) {
        [self addObject:object];
    } else {
        [self insertObject:object atIndex:index + 1];
    }
}

- (void)insertObject:(id)object beforeObject:(id)anObject {
    if (!object || !anObject) {
        return;
    }
    NSUInteger index = [self indexOfObject:anObject];
    if (index == NSNotFound) {
        [self addObject:object];
    } else {
        [self insertObject:object atIndex:index];
    }
}

- (void)removeObjectFromIndex:(NSUInteger)index {
    if (index >= self.count) {
        return;
    }
    NSUInteger loc = index + 1;
    [self removeObjectsInRange:NSMakeRange(loc, self.count - loc)];
}

- (void)moveObject:(id)object toIndex:(NSUInteger)index {
    [self removeObject:object];
    if (index < self.count) {
        [self insertObject:object atIndex:index];
    } else {
        [self addObject:object];
    }
}

@end
