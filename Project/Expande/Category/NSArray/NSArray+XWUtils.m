//
//  NSArray+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "NSArray+XWUtils.h"

@implementation NSArray (XWUtils)

+ (NSArray *)fillArraySomeCount:(NSUInteger)count byOtherArray:(NSArray *)array withPlaceholderObject:(id)object {
    
    NSMutableArray *marray = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [marray addObject:object];
    }
    
    for (NSUInteger i = 0; i < array.count; i++) {
        marray[i] = array[i];
    }
    return marray;
}

- (NSArray *)turnOver;
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(int i = self.count-1;i>=0;i--){
        [mutableArray addObject:self[i]];
    }
    return [NSArray arrayWithArray:mutableArray];
}

@end
