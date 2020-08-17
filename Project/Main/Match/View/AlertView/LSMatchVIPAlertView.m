//
//  LSMatchVIPAlertView.m
//  Project
//
//  Created by XuWen on 2020/5/22.
//  Copyright © 2020 xuwen. All rights reserved.
//
            
#import "LSMatchVIPAlertView.h"
#import "CountDownButton.h"
#import "LSVIPAlertView.h"

@interface LSMatchVIPAlertView ()
@property (nonatomic,strong)UIImageView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong) CountDownButton *countDownButton;

@property (nonatomic,strong) UIButton *nextButton;
@end

@implementation LSMatchVIPAlertView


- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}



#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.placeView addSubview:self.contentView];
    //标志
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"macth_Honeyicon"))];
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@52);
        make.height.equalTo(@24);
        make.left.equalTo(self).offset(24);
        make.top.equalTo(self).offset(kStatusBarHeight);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.countDownButton];
    [self.contentView addSubview:self.nextButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puchaseSuccess) name:KNotification_PurchaseSuccess object:nil];
}

- (void)puchaseSuccess
{
    [self disappearAnimation];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subtitleLabel.mas_top).offset(-50);
        make.left.right.equalTo(self.contentView);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(45);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@(XW(325)));
        make.top.equalTo(self.countDownButton.mas_bottom).offset(130);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.countDownButton startCountDown:[CountDownButton countDownSecond]];
}


#pragma mark - setter & getter1

- (UIImageView *)contentView
{
    if(!_contentView){
        _contentView = [[UIImageView alloc]initWithImage:XWImageName(@"matchVIP_BG")];
        _contentView.contentMode = UIViewContentModeScaleAspectFill;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"You’re out of likes \nfor today";
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if(!_subtitleLabel){
        _subtitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor lightGrayColor] font:Font(16) aliment:NSTextAlignmentCenter];
        _subtitleLabel.text = @"You’ll be able to send 80 more likes in:";
    }
    return _subtitleLabel;
}

- (CountDownButton *)countDownButton
{
    if(!_countDownButton){
        _countDownButton = [CountDownButton buttonWithType:UIButtonTypeCustom];
        _countDownButton.titleLabel.font = FontBold(30);
        [_countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countDownButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        kXWWeakSelf(weakself);
        _countDownButton.CountDownFinishBlock = ^(BOOL finished) {
            //倒计时完成发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CountDownFinished" object:nil];
            [weakself disappearAnimation];
        };
    }
    return _countDownButton;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton creatCommonButtonConfigWithTitle:@"Remove the limit" font:FontBold(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _nextButton.backgroundColor = [UIColor themeColor];
        [_nextButton xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_Match];
        }];
    }
    return _nextButton;
}
@end
