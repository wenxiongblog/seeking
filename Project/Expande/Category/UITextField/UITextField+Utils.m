//
//  UITextField+Utils.m
//  SCGov
//
//  Created by solehe on 2019/8/27.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

// 获取真实的字符串
- (NSString *)realText:(NSString *)text {
    if ([self.text containsString:@"*"]) {
        return text;
    }
    return self.text;
}

@end
