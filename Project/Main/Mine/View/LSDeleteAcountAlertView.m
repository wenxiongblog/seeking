//
//  LSDeleteAcountAlertView.m
//  Project
//
//  Created by XuWen on 2020/6/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDeleteAcountAlertView.h"
#import "CountDownButton.h"

@interface LSDeleteAcountAlertView()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *continueButton;
@property (nonatomic,strong) CountDownButton *countDownButton;

@end

@implementation LSDeleteAcountAlertView
+ (BOOL)show
{
    if([CountDownButton isNeedCountDown_deleteAcount]){
        LSDeleteAcountAlertView *alertView = [[LSDeleteAcountAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [alertView appearAnimation];
        return YES;
    }else{
        return NO;
    }
    
}

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        
        //开始倒计时
        [self.countDownButton startCountDown:[CountDownButton countDownSecond_deleteAcount]];
    }
    return self;
}

#pragma mark - public
#pragma mark - private
#pragma mark - event

#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.placeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.continueButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@306);
        make.height.equalTo(@387);
        make.center.equalTo(self.placeView);
    }];
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@278);
        make.height.equalTo(@52);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
}


#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor xwColorWithHexString:@"#211E21"];
        [_contentView xwDrawCornerWithRadiuce:10];
        
        //title
        UILabel *titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
        titleLabel.text = kLanguage(@"Delete account");
        [_contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(25);
        }];
        //subtitle
        UILabel *subLabel  = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentLeft];
        subLabel.text= kLanguage(@"For your account safety, the deletion function should be used after 72 hours. Please wait for 72 hours.");
        subLabel.numberOfLines = 0;
        [_contentView addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(titleLabel.mas_bottom).offset(12);
        }];
        
        [_contentView addSubview:self.countDownButton];
        [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(subLabel.mas_bottom).offset(0);
            make.height.equalTo(@90);
        }];
    }
    return _contentView;
}

- (CountDownButton *)countDownButton
{
    if(!_countDownButton){
        _countDownButton = [[CountDownButton alloc]init];
        _countDownButton.userInteractionEnabled = NO;
        _countDownButton.hidden = NO;
        _countDownButton.showTimeStyle = ShowTimeStyleHour;
        [_countDownButton commonButtonConfigWithTitle:@"" font:FontBold(67) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        kXWWeakSelf(weakself);
        _countDownButton.CountDownProgressBlock = ^(BOOL finished, int progress) {
            if(finished){
                weakself.countDownButton.hidden = YES;
                [weakself disappearAnimation];
            }
        };
    }
    return _countDownButton;;
}

- (UIButton *)continueButton
{
    if(!_continueButton){
        _continueButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"CONTINUE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _continueButton.backgroundColor = [UIColor themeColor];
        [_continueButton xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_continueButton setAction:^{
            [weakself disappearAnimation];
        }];
    }
    return _continueButton;
}

@end
