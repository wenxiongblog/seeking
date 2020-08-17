//
//  NSMapTable+XB.m
//  XBleSDK
//
//  Created by Sole on 2018/3/19.
//  Copyright © 2018年 sole(sole.he@sophonspace.com). All rights reserved.
//

#import "NSMapTable+XB.h"

@implementation NSMapTable (XB)

- (void)addObject:(id)anObject forKey:(id)aKey {
    [self setObject:anObject forKey:aKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFATION_MAPTABLE_COUNT_CHANGED object:nil];
}

- (void)deleteObjectForKey:(id)aKey {
    [self removeObjectForKey:aKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFATION_MAPTABLE_COUNT_CHANGED object:nil];
}

- (void)deleteAllObjects {
    [self removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFATION_MAPTABLE_COUNT_CHANGED object:nil];
}

@end
