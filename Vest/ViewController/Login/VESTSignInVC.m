//
//  VESTSignInVC.m
//  Project
//
//  Created by XuWen on 2020/8/24.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTSignInVC.h"
#import "VESTEmailInputView.h"
#import "VESTPsdInputView.h"
#import "VESTSignUpVC.h"
#import "VESTTabBarVC.h"
#import "VESTUserTool.h"

@interface VESTSignInVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) VESTEmailInputView *emailInputView;
@property (nonatomic,strong) VESTPsdInputView *psdInputView;
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *signUpButton;
@end

@implementation VESTSignInVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraitsConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)check
{
    if(self.emailInputView.value.length == 0){
        [AlertView toast:@"Input email" inView:self.view];
        return NO;
    }
    if(self.psdInputView.value.length == 0){
        [AlertView toast:@"Input password" inView:self.view];
        return NO;
    }
    if(![self.emailInputView.value isEmail]){
        [AlertView toast:@"Email format error" inView:self.view];
        return NO;
    }
    if(self.psdInputView.value.length < 6){
        [AlertView toast:@"Password length must be greater than 6" inView:self.view];
        return NO;
    }
    return YES;
}

- (void)login
{
    if([self check]){
        //测试账号登录
        if([self.emailInputView.value isEqualToString:@"123@123.com"] && [self.psdInputView.value isEqualToString:@"123456"]){
            //登录成功
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"kVestIsLogin"];
            //设置一个头像和昵称年龄性别等
            [VESTUserTool SaveHeadImageToLocal:XWImageName(@"vestUser")];
            [VESTUserTool saveName:@"Test User"];
            [VESTUserTool saveAge:20];
            [VESTUserTool saveSex:@"1"];
            
            [VESTTabBarVC jumpVESTTabVC];
            return;
        }
        
        //开始登录
        if([self.emailInputView.value isEqualToString:[VESTUserTool account]] && [self.psdInputView.value isEqualToString:[VESTUserTool password]]){
            //登录成功
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"kVestIsLogin"];
            [VESTTabBarVC jumpVESTTabVC];
        }else{
            [AlertView toast:@"Account or password error" inView:self.view];
        }
    }
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.emailInputView];
    [self.view addSubview:self.psdInputView];
    [self.view addSubview:self.signUpButton];
    [self.view addSubview:self.nextButton];
}
- (void)baseConstraitsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(100+kStatusBarAndNavigationBarHeight-20);
    }];
    [self.emailInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(265)));
        make.height.equalTo(@(56));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
    }];
    [self.psdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(265)));
        make.height.equalTo(@(56));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.emailInputView.mas_bottom).offset(10);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@62);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.psdInputView.mas_bottom).offset(62);
    }];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@(XW(131)));
        make.height.equalTo(@(61));
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-50);
    }];
}
#pragma mark - public
#pragma mark - private
#pragma mark - event
#pragma mark - getter & setter
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"SIGN IN";
    }
    return _titleLabel;
}
- (VESTEmailInputView *)emailInputView
{
    if(!_emailInputView){
        _emailInputView = [[VESTEmailInputView alloc]init];
        [_emailInputView xwDrawCornerWithRadiuce:28];
    }
    return _emailInputView;
}
- (VESTPsdInputView *)psdInputView
{
    if(!_psdInputView){
        _psdInputView = [[VESTPsdInputView alloc]init];
        [_psdInputView xwDrawCornerWithRadiuce:28];
    }
    return _psdInputView;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:XWImageName(@"vest_nextBtn") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            [weakself login];
        }];
    }
    return _nextButton;
}
- (UIButton *)signUpButton
{
    if(!_signUpButton){
        _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUpButton setImage:XWImageName(@"vest_signUP") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_signUpButton setAction:^{
            VESTSignUpVC *vc = [[VESTSignUpVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _signUpButton;
}
@end
