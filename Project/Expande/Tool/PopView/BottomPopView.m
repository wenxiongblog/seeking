//
//  BottomPopView.m
//  SCGov
//
//  Created by solehe on 2019/7/25.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "BottomPopView.h"

@implementation BottomPopView

- (UIView *)maskView {
    
    if (!_maskView) {
        
        _maskView = [[UIView alloc] init];
        [_maskView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        [self addSubview:_maskView];
        
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _maskView;
}

- (UIView *)contenView {
    
    if (!_contenView) {
        
        _contenView = [[UIView alloc] init];
        [_contenView setBackgroundColor:[UIColor whiteColor]];
        [self insertSubview:_contenView aboveSubview:self.maskView];

    }
    return _contenView;
}

/**
 显示弹窗
 */
- (void)showInView:(UIView *)view {
    
    if (self.superview != nil) {
        return;
    }
    
    [view addSubview:self];
    [self.maskView setAlpha:0.f];
    
    CGRect frame = self.contenView.frame;
    frame.origin.y = H(self);
    [self.contenView setFrame:frame];
    frame.origin.y = H(self)-H(self.contenView);
    
    
    @weak(self)
    [UIView animateWithDuration:0.3 animations:^{
        [weakself.maskView setAlpha:1.f];
        [weakself.contenView setFrame:frame];
    }];
    
}

/**
 隐藏弹窗
 */
- (void)hidden {
    
    if (self.superview == nil) {
        return;
    }
    
    CGRect frame = self.contenView.frame;
    frame.origin.y = H(self);
    
    @weak(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        [weakself.maskView setAlpha:0.f];
        [weakself.contenView setFrame:frame];
        
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}

@end
