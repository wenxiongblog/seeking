//
//  UIImage+Color.h
//  SCZW
//
//  Created by solehe on 2018/10/13.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)
+ (UIImage *)imageWithColor:(UIColor *)color;
// 改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;

// 高斯模糊
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;

// 修改图片尺寸
- (UIImage *)imageWithSize:(CGSize)size;

// 将图片转位base64字符串
- (NSString *)base64String;

// 生成二维码
+ (UIImage *)imageWithString:(NSString *)string size:(CGSize)size;

// 将UIView转换成图片
+ (UIImage *)imageWithView:(UIView *)view;

//模糊化
- (UIImage *)coreBlurImageWithBlurNumber:(CGFloat)blur;
- (UIImage *)coreBlurImage;

+ (UIImage *)jx_WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point;
+ (UIImage *)addWatermarkInImage:(UIImage *)image AtPonit:(CGPoint)point WithText:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
