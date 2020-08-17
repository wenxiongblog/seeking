//
//  XXRefreshFooter.m
//  SCGov
//
//  Created by solehe on 2019/8/7.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXRefreshFooter.h"

@implementation XXRefreshFooter

#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
}


@end
