//
//  UILabel+TFUtils.h
//  SCGov
//
//  Created by XuWen on 2019/11/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TFUtils)
+ (UILabel *)createCommonLabelConfigWithTextColor:(UIColor *)textColor font:(UIFont *)font aliment:(NSTextAlignment)aliment;
- (void)commonLabelConfigWithTextColor:(UIColor *)textColor font:(UIFont *)font aliment:(NSTextAlignment)aliment;

//文字两端对齐
- (void)textAlignmentLeftAndRight;
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
/**
 字体加阴影
 */
- (void)setShadowText:(NSString *)text;
/**
 字体阴影和行间距
 */
- (void)setShadowText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;
@end

NS_ASSUME_NONNULL_END
