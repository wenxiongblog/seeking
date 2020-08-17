//
//  UIView+Utils.h
//  SCGOV
//
//  Created by solehe on 2019/3/15.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Utils)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

// 加载Xib创建的View
+ (UIView *)loadNibNamed:(NSString *)name owner:(id)owner;

// 生成高斯模糊图片
+ (UIVisualEffectView *)visualEffectView:(CGSize)size;

// 截图
- (UIImage *)snapshotImage;




//改变响应范围
- (void)changeViewScope:(UIEdgeInsets)changeInsets;

/** 画圆角*/
- (void)xwDrawCornerWithRadiuce:(CGFloat)radiuce;
/** 绘制边框*/
- (void)xwDrawBorderWithColor:(UIColor *)color radiuce:(CGFloat)radiuce width:(CGFloat)width;
- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce width:(CGFloat)width color:(UIColor *)color;
/**
 UIRectCornerTopLeft
 * UIRectCornerTopRight
 * UIRectCornerBottomLeft
 * UIRectCornerBottomRight
 * UIRectCornerAllCorners
 */
- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce;

/** 底部划线*/
- (void)showBottomLineWithHeight:(CGFloat)height;
- (void)showBottomLineWithXSpace:(CGFloat)xSpace;
- (void)showBottomLineWithXSpace:(CGFloat)xSpace andColor:(UIColor *)color;
- (void)showBottomLineWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace;
/** 顶部划线*/
- (void)showTopLineWithXSpace:(CGFloat)xSpace;
- (void)showTopLineWithHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
