//  
//  UIColor+LSConst.m
//  Project
//
//  Created by XuWen on 2020/1/14.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "UIColor+LSConst.h"


@implementation UIColor (LSConst)

//241  51 85
+ (UIColor *)themeColor {
    return [UIColor xwColorWithHexString:@"#FFAE00"];
}
+ (UIColor *)projectBackGroudColor {
    return [UIColor xwColorWithHexString:@"#171531"];
}

+ (UIColor *)projectBlueColor
{
    return [UIColor xwColorWithHexString:@"#232048"];
}

+ (UIColor *)themeBlueColor
{
    return [UIColor xwColorWithHexString:@"#2E2877"];
}

+ (UIColor *)placeholderColor
{
    return [UIColor xwColorWithHexString:@"#4C5971"];
}

+ (UIColor *)projectMainTextColor {
    return [UIColor xwColorWithHexString:@"#333333"];
}
+ (UIColor *)projectSubTextColor {
    return [UIColor xwColorWithHexString:@"#A3A6AC"];
}
+ (UIColor *)projectButtonBGColor {
    return [UIColor xwColorWithHexString:@"#737DFF"];
}
+ (UIColor *)projectRedColor{
    return [UIColor xwColorWithHexString:@"#FF6464"];
}
+ (UIColor *)projectBorderColor
{
    return [UIColor xwColorWithHexString:@"#eeeeee"];
}


@end
