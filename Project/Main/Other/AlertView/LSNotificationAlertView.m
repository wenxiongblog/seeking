//
//  LSNotificationAlertView.m
//  Project
//  
//  Created by XuWen on 2020/3/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotificationAlertView.h"

@interface LSNotificationAlertView ()
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *notAllowButton;
@property (nonatomic,strong) UIImageView *addBgImageView;
@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *subLabel;

//@property (nonatomic,strong)
@end

@implementation LSNotificationAlertView

#pragma mark - 埋点
- (void)MDEnable{}
- (void)MDNotEnable{}

+ (void)checkWithTime:(NSInteger)second
{
    if([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone){
        NSLog(@"没有打开");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone){
                LSNotificationAlertView *alertView = [[LSNotificationAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
                [[UIApplication sharedApplication].keyWindow addSubview:alertView];
                [alertView appearAnimation];
            }
        });
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

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
    
    [self.contentView addSubview:self.addBgImageView];
    [self.contentView addSubview:self.nextButton];
    [self.contentView addSubview:self.notAllowButton];
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.subLabel];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
   [self.addBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@(XW(375)));
       make.height.equalTo(@(XW(282)));
       make.top.equalTo(self.contentView);
       make.centerX.equalTo(self.contentView);
   }];
   [self.notAllowButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@(XW(300)));
       make.height.equalTo(@(50));
       make.centerX.equalTo(self.contentView);
       make.bottom.equalTo(self.contentView).offset(-kSafeAreaBottomHeight-60);
   }];
   [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@(XW(300)));
       make.height.equalTo(@(50));
       make.centerX.equalTo(self.contentView);
       make.bottom.equalTo(self.notAllowButton.mas_top).offset(-20);
   }];
   [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView).offset(25);
       make.right.equalTo(self.contentView).offset(-25);
       make.top.equalTo(self.addBgImageView.mas_bottom).offset(30);
   }];
   [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView).offset(25);
       make.right.equalTo(self.contentView).offset(-25);
       make.top.equalTo(self.mainLabel.mas_bottom).offset(25);
   }];
}

#pragma mark - SEEKING_baseConstraintsConfig



#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor themeColor];
    }
    return _contentView;
}


- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"ALLOW NOTIFY") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        button.backgroundColor = [UIColor projectMainTextColor];
        kXWWeakSelf(weakself);
        [button setAction:^{
            [self MDEnable];
            [weakself disappearAnimation];
            [JumpUtils jumpSystemSetting];
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (UIImageView *)addBgImageView
{
    if(!_addBgImageView){
        _addBgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"login_notify_bg")];
    }
    return _addBgImageView;
}

- (UIButton *)notAllowButton
{
    if(!_notAllowButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"NOT NOW") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        _notAllowButton = button;
        [_notAllowButton addTarget:self action:@selector(notAllowClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notAllowButton;
}

- (void)notAllowClicked:(UIButton *)sender
{
    [self MDNotEnable];
    [self disappearAnimation];
}

- (UILabel *)mainLabel
{
    if(!_mainLabel){
        _mainLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentLeft];
        _mainLabel.numberOfLines = 0;
        
        NSString *content = @"You'll be notified about new match, messages and etc";
        
        NSMutableAttributedString* attributedStr=[[NSMutableAttributedString alloc]initWithString:content];
        if([content containsString:@"ified about new match, messages an"]){
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor projectMainTextColor] range:NSMakeRange(29, content.length-29)];
        }
        
        _mainLabel.attributedText = attributedStr;
    }
    return _mainLabel;
}
- (UILabel *)subLabel
{
    if(!_subLabel){
        _subLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontMediun(16) aliment:NSTextAlignmentLeft];
        _subLabel.numberOfLines = 0;
        _subLabel.text = kLanguage(@"You can edit your notification preferences later in the settings");
    }
    return _subLabel;
}


@end
