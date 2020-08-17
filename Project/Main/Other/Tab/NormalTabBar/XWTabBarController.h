//
//  XWTabBarController.h
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XWTabStyle) {
    XWTabDefault,
    XWTabCustom,
};

typedef NS_ENUM(NSUInteger, XWTabBarItemImageState) {
    XWTabBarItemImageStateNormal,
    XWTabBarItemImageStateSelected,
};

@interface XWTabBarController : UITabBarController
/**
 *  标题数组,对应每一个控制器的标题
 */
@property (nonatomic, nonnull, copy) NSArray *titles;

/**
 *  tabbar图片数组
 */
@property (nonatomic, nonnull, copy) NSArray *images;

/**
 *  tabbar被选中图片数组
 */
@property (nonatomic, nonnull, copy) NSArray *selectedImages;
/**
 *  设置标题状态颜色
 *
 *  @param color 颜色
 *  @param font  字体大小
 *  @param state 对应状态
 */
- (void)setTitleColor:(nullable UIColor *)color andFont:(nullable UIFont*)font forState:(UIControlState)state;
- (void)setTitlePositionAdjustment:(UIOffset)offset andimageInsets:(UIEdgeInsets)inset;

- (_Nonnull instancetype)init;
@end
