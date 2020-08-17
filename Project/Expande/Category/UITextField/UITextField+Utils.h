//
//  UITextField+Utils.h
//  SCGov
//
//  Created by solehe on 2019/8/27.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Utils)

// 获取真实的字符串
- (NSString *)realText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
