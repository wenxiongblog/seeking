//
//  UIColor+Image.h
//  SCZW
//
//  Created by solehe on 2018/10/12.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Image)

/**
 生成纯色图片

 @param size 图片尺寸
 @return 生成的图片
 */
- (UIImage *)imageWithSize:(CGSize)size;
+ (UIColor * _Nullable)xwColorWithRGB:(uint32_t)rgbValue;
+ (UIColor * _Nullable)xwColorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor * _Nullable)xwColorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (nullable UIColor *)xwColorWithHexString:(NSString * _Nonnull)hexStr;
+ (UIColor * _Nullable)xwRandomColor;
+ (UIColor * _Nullable)xwRandomDarkColor;
+ (UIColor * _Nullable)xwMiddleDarkColor;
/**
    随机浅色
 */
+ (UIColor * _Nullable)xwRandomLightColor;
+ (UIColor * _Nullable)xwRandomDarkLightColor;
/**
 颜色渐变
 */
+ (CAGradientLayer * _Nullable)setGradualChangingColor:(UIView *_Nullable)view fromColor:(NSString *_Nullable)fromHexColorStr toColor:(NSString *_Nullable)toHexColorStr;
+ (CAGradientLayer *_Nullable)setGradualHorizontalChangingColor:(UIView *_Nullable)view fromColor:(NSString *_Nullable)fromHexColorStr toColor:(NSString *_Nullable)toHexColorStr;
@end

NS_ASSUME_NONNULL_END
