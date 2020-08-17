//
//  NSObject+XB.m
//  SmartLock
//
//  Created by Sole on 2017/10/19.
//  Copyright © 2017年 sole. All rights reserved.
//

#import "NSObject+Obj.h"
#import <objc/runtime.h>

@implementation NSObject (Obj)

- (void)setObject:(id)obj withKey:(NSString *)key {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(key), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)objectWithKey:(NSString *)key {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(key));
}

@end
