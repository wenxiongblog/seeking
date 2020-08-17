//
//  SEEKING_CustomerEmptyView.m
//  Project
//
//  Created by XuWen on 2020/3/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "SEEKING_CustomerEmptyView.h"

@interface  SEEKING_CustomerEmptyView ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subLabel;
@end

@implementation SEEKING_CustomerEmptyView

//show
+ (void)showEmptyInView:(UIView *)view
{
    SEEKING_CustomerEmptyView *loadingView = [SEEKING_CustomerEmptyView share];
    [view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

//hide
+ (void)hideEmptyinView:(UIView *)view
{
    if([SEEKING_CustomerEmptyView share].superview != nil){
        [[SEEKING_CustomerEmptyView share] removeFromSuperview];
    }
}

//单例
static SEEKING_CustomerEmptyView *__singletion;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] initWithFrame:CGRectZero];
    });
    return __singletion;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}

- (void)SEEKING_baseUIConfig
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subLabel];
}

- (void)baseConstriantsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.bottom.equalTo(self.subLabel.mas_top).offset(-20);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgImageView);
    }];
}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT)];
        _bgImageView.image = XWImageName(@"commonBg");
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(32) aliment:NSTextAlignmentCenter];
        _titleLabel.text = kLanguage(@"No More Users");
    }
    return _titleLabel;
}

- (UILabel *)subLabel
{
    if(!_subLabel){
        _subLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(20) aliment:NSTextAlignmentCenter];
        _subLabel.text = kLanguage(@"Please view tomorrow.");
    }
    return _subLabel;
}

@end
