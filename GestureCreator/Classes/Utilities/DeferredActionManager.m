//
// Created by Timur Turaev on 18.08.14.
// Copyright (c) 2014 Yandex. All rights reserved.
//

#import "DeferredActionManager.h"

@interface DeferredActionManager ()
@property(nonatomic, readonly) NSMutableDictionary *deferredBlocks;
@end

@implementation DeferredActionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _deferredBlocks = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)performActionAfterDelay:(NSTimeInterval)delay withKey:(NSString *)key block:(DeferredBlock)block {
    [self removeActionForKey:key];
    self.deferredBlocks[key] = block;
    [self performSelector:@selector(fireBlockWithKey:) withObject:key afterDelay:delay];
}

- (void)fireBlockWithKey:(NSString *)key {
    DeferredBlock block = self.deferredBlocks[key];
    if (block) {
        block();
    }
    [self removeActionForKey:key];
}

- (void)removeActionForKey:(NSString *)key {
    [self.deferredBlocks removeObjectForKey:key];
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireBlockWithKey:) object:key];
}

- (void)removeAllActions {
    [self.deferredBlocks removeAllObjects];
    [self.class cancelPreviousPerformRequestsWithTarget:self];
}

@end