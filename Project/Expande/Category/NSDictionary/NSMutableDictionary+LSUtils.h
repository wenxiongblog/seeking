//
//  NSMutableDictionary+LSUtils.h
//  Project
//
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (LSUtils)
- (void)setNullObject:(id)object forKey:(NSString *)key;
- (void)setNullObject:(id)object forKey:(NSString *)key replaceObject:(id)replaceobject;
@end

NS_ASSUME_NONNULL_END
