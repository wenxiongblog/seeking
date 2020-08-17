//
//  NSMutableDictionary+LSUtils.m
//  Project
//
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "NSMutableDictionary+LSUtils.h"

@implementation NSMutableDictionary (LSUtils)

- (void)setNullObject:(id)object forKey:(NSString *)key
{
    if(object == nil){
        return;
    }
    [self setObject:object forKey:key];
}

- (void)setNullObject:(id)object forKey:(NSString *)key replaceObject:(id)replaceobject
{
    if(object == nil){
        [self setObject:replaceobject forKey:key];
        return;
    }
    [self setObject:object forKey:key];
}

@end
