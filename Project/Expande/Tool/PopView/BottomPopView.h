//
//  BottomPopView.h
//  SCGov
//
//  Created by solehe on 2019/7/25.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomPopView : UIView

// 遮罩层
@property (nonatomic, strong) UIView *maskView;
// 视图容器
@property (nonatomic, strong) UIView *contenView;

/**
 显示弹窗
 */
- (void)showInView:(UIView *)view;
/**
 隐藏弹窗
 */
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
