//
//  NSMutableArray+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (XWUtils)
-(NSMutableArray*)randowmArrayWithCount:(NSInteger)count;

// 随机打乱元素次序
- (void)shuffle;
@end
