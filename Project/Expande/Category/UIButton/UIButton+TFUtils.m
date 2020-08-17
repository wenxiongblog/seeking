//
//  UIButton+TFUtils.m
//  SCGov
//
//  Created by XuWen on 2019/11/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "UIButton+TFUtils.h"
#import <objc/runtime.h>


static const char * kHitEdgeInsets = "hitEdgeInset";
static const char * kHitScale = "hitScale";
static const char * kHitWidthScale = "hitWidthScale";
static const char * kHitHeightScale = "hitWidthScale";

@implementation UIButton (TFUtils)
+ (UIButton *)creatCommonButtonConfigWithTitle:(NSString *)titles font:(UIFont *)font titleColor:(UIColor *)titleColor aliment:(UIControlContentHorizontalAlignment)aliment{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button commonButtonConfigWithTitle:titles font:font titleColor:titleColor aliment:aliment];
    return button;
}

- (void)commonButtonConfigWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor aliment:(UIControlContentHorizontalAlignment)aliment {
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:aliment];
}
- (void)commonHightlighted
{
    [self setBackgroundImage:XWImageName(@"buttonHightlight") forState:UIControlStateHighlighted];
    [self setBackgroundImage:XWImageName(@"buttonSelect") forState:UIControlStateNormal];
}
- (void)addZoom
{
    [self addTarget:self
                 action:@selector(pressedEvent:)
       forControlEvents:UIControlEventTouchDown];
    [self addTarget:self
                 action:@selector(unpressedEvent:)
       forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)addZoomTouchOut
{
    [self addTarget:self
             action:@selector(unpressedoutEvent:)
   forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)pressedEvent:(UIButton *)btn
{
    kXWWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIButton *)btn
{
    kXWWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)unpressedoutEvent:(UIButton *)sender
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.duration = 0.2; // 动画持续时间
//    animation.repeatCount = 1; // 重复次数
//    animation.autoreverses = YES; // 动画结束时执行逆动画
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]; // 开始时的倍率
//    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]; // 结束时的倍率
//    [sender.layer addAnimation:animation forKey:@"move-rotate-layer"];
    
    [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
     }];
}


- (void)setAction:(void (^)(void))action{
    objc_setAssociatedObject(self, "ButtonAction", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(xtButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)xtButtonAction:(UIButton *)button{
    void (^action)(void) = objc_getAssociatedObject(self, "ButtonAction");
    if (action) {
        action();
    }
}

#pragma mark - set Method
-(void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = [NSValue value:&hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, kHitEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitScale:(CGFloat)hitScale{
    CGFloat width = self.bounds.size.width * hitScale;
    CGFloat height = self.bounds.size.height * hitScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitScale, @(hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitWidthScale:(CGFloat)hitScale{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitScale, @(hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitHeightScale:(CGFloat)hitHeightScale{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitHeightScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitHeightScale, @(kHitHeightScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - get method
-(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = objc_getAssociatedObject(self, kHitEdgeInsets);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return value ? edgeInsets:UIEdgeInsetsZero;
}

-(CGFloat)hitScale{
    return [objc_getAssociatedObject(self, kHitScale) floatValue];
}

-(CGFloat)hitWidthScale{
    return [objc_getAssociatedObject(self, kHitWidthScale) floatValue];
}

-(CGFloat)hitHeightScale{
    return [objc_getAssociatedObject(self, kHitHeightScale) floatValue];
}

#pragma mark - override super method
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0 ) {
        return [super pointInside:point withEvent:event];
    }else{
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}
@end
