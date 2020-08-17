//
//  LSSlider.m
//  Project
//
//  Created by XuWen on 2020/5/19.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSlider.h"

@implementation LSSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height= 5;
    self.layer.cornerRadius = 2.5;
    return bounds;
}
 
// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 5 ;
    rect.size.width = rect.size.width +10;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 5 , 5);
}

@end
