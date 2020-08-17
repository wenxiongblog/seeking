//
//  UIView+Graphics.m
//  SCZW
//
//  Created by solehe on 2018/10/12.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import "UIView+Graphics.h"

@implementation UIView (Graphics)

#pragma mark -
/**
 设置圆角
 
 @param corners 圆角位置
 @param radius 圆角半径
 */
- (void)setCornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


#pragma mark -
/**
 设置阴影
 */
- (void)setShadow {
    self.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.layer.shadowOffset =  CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
}

@end
