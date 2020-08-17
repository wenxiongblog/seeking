//
//  MiddlePopView.m
//  SCGov
//
//  Created by solehe on 2019/7/25.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "MiddlePopView.h"

@implementation MiddlePopView

- (UIView *)maskView {
    
    if (!_maskView) {
        
        _maskView = [[UIView alloc] init];
        [_maskView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
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
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-20);
        }];
    }
    return _contentView;
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
