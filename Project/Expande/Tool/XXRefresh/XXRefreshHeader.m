//
//  XXRefreshHeader.m
//  SCGov
//
//  Created by solehe on 2019/8/7.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXRefreshHeader.h"

@implementation XXRefreshHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认隐藏上次刷新时间
    [self.lastUpdatedTimeLabel setHidden:YES];
    // 设置下拉刷新头部占用的高度
    
}

@end
