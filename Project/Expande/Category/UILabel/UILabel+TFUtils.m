//
//  UILabel+TFUtils.m
//  SCGov
//
//  Created by XuWen on 2019/11/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "UILabel+TFUtils.h"

@implementation UILabel (TFUtils)
+ (UILabel *)createCommonLabelConfigWithTextColor:(UIColor *)textColor font:(UIFont *)font aliment:(NSTextAlignment)aliment {
    UILabel *label = [[UILabel alloc]init];
    [label commonLabelConfigWithTextColor:textColor font:font aliment:aliment];
    return label;
}

- (void)commonLabelConfigWithTextColor:(UIColor *)textColor font:(UIFont *)font aliment:(NSTextAlignment)aliment {
    self.textColor = textColor;
    self.font = font;
    self.textAlignment = aliment;
}

- (void)textAlignmentLeftAndRight{
    NSString *str2 = self.text;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithString:str2];
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc]init];
    par.alignment = NSTextAlignmentJustified;
    NSDictionary *dic = @{NSParagraphStyleAttributeName : par,
                          NSFontAttributeName : self.font,
                          NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleNone]};
    [mstr setAttributes:dic range:NSMakeRange(0, mstr.length)];
    self.attributedText = mstr;
    
}

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

- (void)setShadowText:(NSString *)text
{
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 4.0;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{NSShadowAttributeName:shadow}];
    self.attributedText = attributedText;
}

- (void)setShadowText:(NSString *)text lineSpacing:(CGFloat)lineSpacing
{
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 4.0;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName:shadow}];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedText;
    
}
@end
