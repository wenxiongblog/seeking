//
//  LSHomeHeaderView.m
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSHomeHeaderView.h"

@interface LSHomeHeaderView()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
@end

@implementation LSHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstraintConfig];
        
        [self popJumpAnimationView];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.titleImageView];
    [self addSubview:self.rightImageView];
}

- (void)baseConstraintConfig
{
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self).offset(-20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleImageView);
        make.left.equalTo(self.titleImageView.mas_right).offset(15);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.centerY.equalTo(self.titleImageView);
        make.right.equalTo(self).offset(-20);
    }];
}

#pragma mark - private
- (void)popJumpAnimationView{
    
    CGFloat duration = 30.0;
    CGFloat height = XW(604) - XW(165);
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = duration;
    animation.values = @[@(0), @(-height),@(0)];
    animation.keyTimes = @[@(0),@(0.5),@(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    [self.bgImageView.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}


#pragma mark - setter & getter1
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.frame = CGRectMake(0, 0, XW(336), XW(604));
        _bgImageView.image = XWImageName(@"EliteBoy");
    }
    return _bgImageView;
}
- (UIImageView *)titleImageView
{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]initWithImage:XWImageName(@"eliteLogo")];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleImageView;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentLeft];
        _titleLabel.text = kLanguage(@"Elite men");
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(20) aliment:NSTextAlignmentLeft];
        _subTitleLabel.text = kLanguage(@"Perfect your profile");
    }
    return _subTitleLabel;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc]initWithImage:XWImageName(@"Elite_right")];
    }
    return _rightImageView;
}

- (void)setIsMan:(BOOL)isMan
{
    _isMan = isMan;
    if(isMan){
        _titleLabel.text = kLanguage(@"Elite men");
        self.bgImageView.image = XWImageName(@"EliteBoy");
    }else{
        _titleLabel.text = kLanguage(@"Cute girls");
        self.bgImageView.image = XWImageName(@"EliteGirl");
    }
}

// 开始动画？
- (void)startAnimation
{
    CALayer *layer = self.bgImageView.layer;
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

// 暂停动画？
- (void)stopAnimation
{
    CFTimeInterval pausedTime = [self.bgImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.bgImageView.layer.speed = 0.0;
    self.bgImageView.layer.timeOffset = pausedTime;
}
@end
