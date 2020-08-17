//
//  UIButton+TFUtils.h
//  SCGov
//
//  Created by XuWen on 2019/11/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TFUtils)
+ (UIButton *)creatCommonButtonConfigWithTitle:(NSString *)titles font:(UIFont *)font titleColor:(UIColor *)titleColor aliment:(UIControlContentHorizontalAlignment)aliment;

- (void)commonButtonConfigWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor aliment:(UIControlContentHorizontalAlignment)aliment;

- (void)commonHightlighted;

- (void)addZoom;

- (void)addZoomTouchOut;

- (void)setAction:(void (^)(void))action;


/**
自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
例如： self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
*/
@property(nonatomic, assign) UIEdgeInsets hitEdgeInsets;
/**
 自定义响应边界 自定义的边界的范围 范围扩大3.0
 例如：self.btn.hitScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitScale;
/*
 自定义响应边界 自定义的宽度的范围 范围扩大3.0
 例如：self.btn.hitWidthScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitWidthScale;

/*
 自定义响应边界 自定义的高度的范围 范围扩大3.0
 例如：self.btn.hitHeightScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitHeightScale;

@end

NS_ASSUME_NONNULL_END
