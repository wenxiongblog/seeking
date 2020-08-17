//
//  NSObject+XB.h
//  SmartLock
//
//  Created by Sole on 2017/10/19.
//  Copyright © 2017年 sole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Obj)

- (void)setObject:(id)obj withKey:(NSString *)key;
- (id)objectWithKey:(NSString *)key;

@end
