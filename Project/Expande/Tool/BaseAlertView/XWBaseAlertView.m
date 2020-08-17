//
//  XWBaseAlertView.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBaseAlertView.h"
#import "UIView+Utils.h"

@interface XWBaseAlertView()
@property (nonatomic, strong, readwrite) UIView *placeView;
@property (nonatomic, assign) XWBaseAlertViewStyle style;
@end

@implementation XWBaseAlertView

#pragma mark - init

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style {
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    if (self) {
        self.style = style;
        [self baseConfig];
    }
    return self;
}
    
#pragma mark - setBaseUI

- (void)baseConfig {
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    [self addSubview:self.placeView];
}

#pragma mark - public
- (void)appearAnimation {
    switch (self.style) {
        case XWBaseAlertViewStyleCenter: {
            
            self.placeView.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            
            [UIView animateWithDuration:0.3f delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.placeView.transform = CGAffineTransformIdentity;
                self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.35];
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
        case XWBaseAlertViewStyleBottom: {
            self.placeView.top = kSCREEN_HEIGHT;
            [UIView animateWithDuration:0.3f delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                self.placeView.top = 0;
                self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.35];
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
        default:
            break;
    }
}

- (void)disappearAnimation {
    [self endEditing:YES];
    switch (self.style) {
        case XWBaseAlertViewStyleCenter: {
            
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.placeView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                self.placeView.alpha = 0.0;
                self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
                [self removeFromSuperview];
            }];
            break;
        }
        case XWBaseAlertViewStyleBottom: {
            
            [UIView animateWithDuration:0.3f animations:^{
                self.placeView.top = kSCREEN_HEIGHT;
                self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        default:
            break;
    }
}


#pragma mark - setter & getter1
- (UIView *)placeView {
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _placeView.backgroundColor = [UIColor clearColor];
    }
    return _placeView;
}
@end
