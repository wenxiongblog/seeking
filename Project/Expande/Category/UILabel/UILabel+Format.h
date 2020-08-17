//
//  UILabel+Format.h
//  SCGOV
//
//  Created by solehe on 2019/3/20.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Format)

// 设置行距
- (void)setLineSpace:(CGFloat)space;

// 设置字间距
- (void)setFontSpace:(CGFloat)space;

// 设置特殊文字颜色和字体大小
- (void)resetText:(NSString *)str font:(UIFont *)font color:(UIColor *)color;

// 计算尺寸
- (CGSize)sizeWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
