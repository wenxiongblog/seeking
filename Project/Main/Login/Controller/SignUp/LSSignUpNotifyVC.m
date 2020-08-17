//
//  LSSignUpNotifyVC.m
//  Project
//
//  Created by XuWen on 2020/5/19.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpNotifyVC.h"
#import "LSSignUpLocationVC.h"

@interface LSSignUpNotifyVC ()
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *notAllowButton;
@property (nonatomic,strong) UIImageView *addBgImageView;
@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *subLabel;
@end

@implementation LSSignUpNotifyVC

- (void)MDSignupNotifiy{};
- (void)MDEnable{};
- (void)MDnotEnable{};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    self.titleLabel.hidden = YES;
    
    //埋点
    [self MDSignupNotifiy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.bgImageView.hidden = YES;
    self.view.backgroundColor = [UIColor themeColor];
    self.titleLabel.text = @"ENABLE\nGEOLOCATON";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setFont:Font(36)];
    [self.view addSubview:self.addBgImageView];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.notAllowButton];
    [self.view addSubview:self.mainLabel];
    [self.view addSubview:self.subLabel];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
    }];
    [self.addBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(375)));
        make.height.equalTo(@(XW(282)));
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    [self.notAllowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-60);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.notAllowButton.mas_top).offset(-20);
    }];
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.addBgImageView.mas_bottom).offset(30);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.mainLabel.mas_bottom).offset(25);
    }];
}



#pragma mark - setter & getter1
- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"ALLOW NOTIFY") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        button.backgroundColor = [UIColor projectMainTextColor];
        kXWWeakSelf(weakself);
        [button setAction:^{
            [self MDEnable];
            
            [JumpUtils jumpSystemSetting];
            LSSignUpLocationVC *vc = [[LSSignUpLocationVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
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
    [self MDnotEnable];
    LSSignUpLocationVC *vc = [[LSSignUpLocationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)mainLabel
{
    if(!_mainLabel){
        _mainLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentLeft];
        _mainLabel.numberOfLines = 0;
        
        NSString *content = kLanguage(@"You'll be notified about new match, messages and etc");
        
        NSMutableAttributedString* attributedStr=[[NSMutableAttributedString alloc]initWithString:content];
        if([content containsString:@"tified about new match, messages"]){
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
