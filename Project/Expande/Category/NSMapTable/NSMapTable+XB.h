//
//  NSMapTable+XB.h
//  XBleSDK
//
//  Created by Sole on 2018/3/19.
//  Copyright © 2018年 sole(sole.he@sophonspace.com). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 容器个数变化
#define NOTIFATION_MAPTABLE_COUNT_CHANGED  @"com.sophonspace.xble.sdk.map.table.count"


@interface NSMapTable (XB)

- (void)addObject:(id)anObject forKey:(id)aKey;
- (void)deleteObjectForKey:(id)aKey;
- (void)deleteAllObjects;

@end
