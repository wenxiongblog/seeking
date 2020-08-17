//
//  MidPopView.h
//  SCGOV
//
//  Created by solehe on 2019/3/20.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 中间弹出提示框
 */
@interface MidPopView : UIView

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIView *bottomView;

- (void)showInView:(UIView *)superView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
