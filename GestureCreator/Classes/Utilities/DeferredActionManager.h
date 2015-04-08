//
// Created by Timur Turaev on 18.08.14.
// Copyright (c) 2014 Yandex. All rights reserved.
//

@import Foundation;


typedef void (^DeferredBlock)();

@interface DeferredActionManager : NSObject

- (void)performActionAfterDelay:(NSTimeInterval)delay withKey:(NSString *)key block:(DeferredBlock)block;
- (void)removeActionForKey:(NSString *)key;
- (void)removeAllActions;

@end
