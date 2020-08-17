//
//  LSSignUpLocationVC.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpLocationVC.h"
#import "LSLocationManager.h"
@interface LSSignUpLocationVC ()
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *notAllowButton;
@property (nonatomic,strong) UIImageView *addBgImageView;
@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *subLabel;
//数据
@property (nonatomic,assign) double lan;
@property (nonatomic,assign) double lon;
@property (nonatomic,strong) NSString *cityName;
@end

@implementation LSSignUpLocationVC

#pragma mark - 埋点
//来到定位同意页面
- (void)MDchooseLocation{}
//同意定位
- (void)chooseLocation13{}
//不同意定位
- (void)chooseDisagreeLocation13{}
//上传了用户定位
- (void)updateUserLocation14{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    
    self.titleLabel.hidden = YES;
    //mai点
    [self MDchooseLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)uploadLocation
{
    //city
    kXWWeakSelf(weakself);
    [self updateUserInfo:^(BOOL finished) {
        // 经纬度
        [AlertView hiddenLoadingInView:self.view];
        if(finished){
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
            [self UpdateLocation:^(BOOL finished) {
                [weakself updateUserLocation14];
            }];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
        }
    }];
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
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"ALLOW LOCATION") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        button.backgroundColor = [UIColor projectMainTextColor];
        kXWWeakSelf(weakself);
        [button setAction:^{
            SEEKING_UserModel *model = kUser;
            NSLog(@"%@",model);
            [AlertView showLoading:kLanguage(@"Location...") inView:self.view];
            [[LSLocationManager share]startLocation:^(BOOL isSuccess ,double lan, double lon, NSString * _Nonnull cityName) {
                if(isSuccess){
                    [weakself chooseLocation13];
                    kUser.lng = lon;
                    kUser.lat = lan;
                    kUser.address = cityName;
                    [weakself uploadLocation];
                }else{
                    [AlertView hiddenLoadingInView:self.view];
                    [weakself chooseDisagreeLocation13];
                     [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
                }
            }];
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (UIImageView *)addBgImageView
{
    if(!_addBgImageView){
        _addBgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"login_address_bg")];
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
    [self chooseDisagreeLocation13];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
}

- (UILabel *)mainLabel
{
    if(!_mainLabel){
        _mainLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentLeft];
        _mainLabel.numberOfLines = 0;
        
        NSString *content = kLanguage(@"Access your location to find people nearby");
        NSMutableAttributedString* attributedStr=[[NSMutableAttributedString alloc]initWithString:content];
        if([content containsString:@"Access your location to find people near"]){
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
        _subLabel.text = kLanguage(@"You location will be used to smart matching. We will show you people nearby");
    }
    return _subLabel;
}

@end
