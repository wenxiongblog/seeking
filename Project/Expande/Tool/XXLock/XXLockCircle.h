/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockCircle.h
 **  Description: 圆圈
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XXLockCircleState)
{
    XXLockCircleStateNormal = 0,
    XXLockCircleStateSelected,
    XXLockCircleStateFill,
    XXLockCircleStateError
};

@interface XXLockCircle : UIView

@property (nonatomic, assign) XXLockCircleState state;
@property (nonatomic, assign) CGFloat diameter;

- (instancetype)initWithDiameter:(CGFloat)diameter;
- (void)updateCircleState:(XXLockCircleState)state;

@end
