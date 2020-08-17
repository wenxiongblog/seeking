//
//  UILabel+Format.m
//  SCGOV
//
//  Created by solehe on 2019/3/20.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import "UILabel+Format.h"

@implementation UILabel (Format)

// 设置行距
- (void)setLineSpace:(CGFloat)space {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

// 设置字间距
- (void)setFontSpace:(CGFloat)space {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

// 设置特殊文字颜色和字体大小
- (void)resetText:(NSString *)str font:(UIFont *)font color:(UIColor *)color {
    NSRange range = [self.text rangeOfString:str];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attributedString;
}

// 计算尺寸
- (CGSize)sizeWithWidth:(CGFloat)width {
    return [self.text boundingRectWithSize:CGSizeMake(width, 1000)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName : self.font} context:nil].size;
}

@end
