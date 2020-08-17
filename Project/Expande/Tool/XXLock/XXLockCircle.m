/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockCircle.m
 **  Description: 圆圈
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import "XXLockCircle.h"
#import "XXLockConfig.h"

@interface XXLockCircle ()

@end

@implementation XXLockCircle

- (instancetype)initWithDiameter:(CGFloat)diameter
{
    self = [super initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.diameter = diameter;
        self.state = XXLockCircleStateNormal;
    }
    
    return self;
}

- (void)updateCircleState:(XXLockCircleState)state
{
    [self setState:state];
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kCircleWidth);
    
    if (self.state == XXLockCircleStateNormal)
    {
        [self drawEmptyCircleWithContext:context
                                    rect:CGRectMake(kCircleWidth / 2,
                                                    kCircleWidth / 2,
                                                    self.diameter - kCircleWidth,
                                                    self.diameter - kCircleWidth)
                             strokeColor:XX_LOCK_COLOR_NORMAL
                               fillColor:XX_LOCK_COLOR_BACKGROUND];
    }
    else if (self.state == XXLockCircleStateSelected)
    {
        [self drawCenterCircleWithContext:context
                                     rect:CGRectMake(kCircleWidth / 2,
                                                     kCircleWidth / 2,
                                                     self.diameter - kCircleWidth,
                                                     self.diameter - kCircleWidth)
                               centerRect:CGRectMake(self.diameter * (0.5 - kCircleCenterRatio / 2),
                                                     self.diameter * (0.5 - kCircleCenterRatio / 2),
                                                     self.diameter * kCircleCenterRatio,
                                                     self.diameter * kCircleCenterRatio)
                              strokeColor:XX_LOCK_COLOR_NORMAL
                                fillColor:XX_LOCK_COLOR_BACKGROUND];
    }
    else if (self.state == XXLockCircleStateFill)
    {
        [self drawSolidCircleWithContext:context
                                    rect:CGRectMake(kCircleWidth / 2,
                                                    kCircleWidth / 2,
                                                    self.diameter - kCircleWidth,
                                                    self.diameter - kCircleWidth)
                             strokeColor:XX_LOCK_COLOR_NORMAL];
    }
    else if (self.state == XXLockCircleStateError)
    {
        [self drawCenterCircleWithContext:context
                                     rect:CGRectMake(kCircleWidth / 2,
                                                     kCircleWidth / 2,
                                                     self.diameter - kCircleWidth,
                                                     self.diameter - kCircleWidth)
                               centerRect:CGRectMake(self.diameter * (0.5 - kCircleCenterRatio / 2),
                                                     self.diameter * (0.5 - kCircleCenterRatio / 2),
                                                     self.diameter * kCircleCenterRatio,
                                                     self.diameter * kCircleCenterRatio)
                              strokeColor:XX_LOCK_COLOR_ERROR
                                fillColor:XX_LOCK_COLOR_BACKGROUND];
    }
}

#pragma mark Private

/**
 空心圆环

 @param context     context
 @param rect        rect
 @param strokeColor strokeColor
 @param fillColor   fillColor
 */
- (void)drawEmptyCircleWithContext:(CGContextRef)context
                              rect:(CGRect)rect
                       strokeColor:(UIColor *)strokeColor
                         fillColor:(UIColor *)fillColor
{
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
}

/**
 实心圆

 @param context     context
 @param rect        rect
 @param strokeColor strokeColor
 */
- (void)drawSolidCircleWithContext:(CGContextRef)context
                              rect:(CGRect)rect
                       strokeColor:(UIColor *)strokeColor
{
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
}

/**
 圆环 + 中心小圆

 @param context     context
 @param rect        rect
 @param centerRect  centerRect
 @param strokeColor strokeColor
 @param fillColor   fillColor
 */
- (void)drawCenterCircleWithContext:(CGContextRef)context
                               rect:(CGRect)rect
                         centerRect:(CGRect)centerRect
                        strokeColor:(UIColor *)strokeColor
                          fillColor:(UIColor *)fillColor
{
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    CGContextAddEllipseInRect(context, centerRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
