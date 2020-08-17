//
//  CALayer+Xib.h
//  scwfwoa_iOS
//
//  Created by solehe on 2018/12/11.
//  Copyright © 2018 MR.Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 xib中配置属性
 */
@interface CALayer (Xib)

// 边框颜色
@property(nonatomic, assign) UIColor *borderUIColor;
// 阴影颜色
@property (nonatomic, strong) UIColor *shadowUIColor;

@end

NS_ASSUME_NONNULL_END
