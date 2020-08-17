//
//  CALayer+Xib.m
//  scwfwoa_iOS
//
//  Created by solehe on 2018/12/11.
//  Copyright © 2018 MR.Liu. All rights reserved.
//

#import "CALayer+Xib.h"

@implementation CALayer (Xib)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setShadowUIColor:(UIColor *)shadowUIColor {
    self.shadowColor = shadowUIColor.CGColor;
}

- (UIColor *)shadowUIColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
