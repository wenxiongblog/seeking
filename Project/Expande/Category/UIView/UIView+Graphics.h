//
//  UIView+Graphics.h
//  SCZW
//
//  Created by solehe on 2018/10/12.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Graphics)


/**
 设置圆角

 @param corners 圆角位置
 @param radius 圆角半径
 */
- (void)setCornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/**
 设置阴影
 */
- (void)setShadow;


@end

NS_ASSUME_NONNULL_END
