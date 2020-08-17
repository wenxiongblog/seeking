//
//  MidPopView.m
//  SCGOV
//
//  Created by solehe on 2019/3/20.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import "MidPopView.h"

@implementation MidPopView

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        [_maskView setBackgroundColor:RGBA(0, 0, 0, 0.4)];
        [self insertSubview:_maskView atIndex:0];
        
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _maskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:6.f];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-48);
            make.centerY.mas_equalTo(-20);
            make.height.mas_greaterThanOrEqualTo(50);
        }];
    }
    return _contentView;
}

- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
        [_customView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_customView];
        
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(0);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    }
    return _customView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.customView.mas_bottom);
        }];
    }
    return _bottomView;
}

- (void)showInView:(UIView *)superView {
    
    [self.maskView setAlpha:0.f];
    [superView addSubview:self];
    
    @weak(self)
    [UIView animateWithDuration:0.3f animations:^{
        [weakself.maskView setAlpha:1.f];
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 0.3f;
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.contentView.layer addAnimation:animation forKey:@"zoom"];
}

- (void)dismiss {
    
    [self.maskView setAlpha:1.f];
    
    @weak(self)
    [UIView animateWithDuration:0.3f animations:^{
        [weakself.maskView setAlpha:0.f];
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = 0.3f;
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.contentView.layer addAnimation:animation forKey:@"zoom"];
}

@end
