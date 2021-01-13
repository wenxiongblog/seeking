//
//  VESTSignUpVC.m
//  Project
//
//  Created by XuWen on 2020/8/24.
//  Copyright © 2020 xuwen. All rights reserved.
//  

#import "VESTSignUpVC.h"
#import "VESTEmailInputView.h"
#import "VESTPsdInputView.h"
#import "VESTAgeInputView.h"
#import "VESTSignUpNameVC.h"
#import "VESTUserTool.h"

@interface VESTSignUpVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) VESTEmailInputView *emailInputView;
@property (nonatomic,strong) VESTPsdInputView *psdInputView;
@property (nonatomic,strong) VESTAgeInputView *ageInoutView;

@property (nonatomic,strong) UIButton *girlButton;
@property (nonatomic,strong) UIButton *boyButton;

@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *signInButton;

@end

@implementation VESTSignUpVC

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
#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.emailInputView];
    [self.view addSubview:self.psdInputView];
    [self.view addSubview:self.ageInoutView];
    [self.view addSubview:self.girlButton];
    [self.view addSubview:self.boyButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.signInButton];
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
    [self.ageInoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(265)));
        make.height.equalTo(@(56));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.psdInputView.mas_bottom).offset(10);
    }];
    [self.girlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ageInoutView);
        make.height.equalTo(self.ageInoutView);
        make.width.equalTo(@(XW(125)));
        make.top.equalTo(self.ageInoutView.mas_bottom).offset(30);
    }];
    [self.boyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageInoutView);
        make.height.equalTo(self.ageInoutView);
        make.width.equalTo(@(XW(125)));
        make.top.equalTo(self.ageInoutView.mas_bottom).offset(30);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@62);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.boyButton.mas_bottom).offset(62);
    }];
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(@(XW(131)));
        make.height.equalTo(@(61));
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-50);
    }];
}

#pragma mark - public
#pragma mark - private
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
    if(self.ageInoutView.value.length == 0){
        [AlertView toast:@"Input age" inView:self.view];
        return NO;
    }
    if(self.girlButton.selected==NO && self.boyButton.selected==NO){
        [AlertView toast:@"Choose your gender" inView:self.view];
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
    if([self.ageInoutView.value intValue]<18){
        [AlertView toast:@"Age must be greater than 18" inView:self.view];
        return NO;
    }
    
    //保存用户信息
    [VESTUserTool saveAccount:self.emailInputView.value];
    [VESTUserTool savePassword:self.psdInputView.value];
    [VESTUserTool saveAge:[self.ageInoutView.value intValue]];
    if(self.boyButton.selected){
        [VESTUserTool saveSex:@"1"];
    }else{
        [VESTUserTool saveSex:@"2"];
    }
    
    VESTSignUpNameVC *vc = [[VESTSignUpNameVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

#pragma mark - event
#pragma mark - getter & setter
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"SIGN UP";
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
- (VESTAgeInputView *)ageInoutView
{
    if(!_ageInoutView){
        _ageInoutView = [[VESTAgeInputView alloc]init];
        [_ageInoutView xwDrawCornerWithRadiuce:28];
    }
    return _ageInoutView;
}

- (UIButton *)girlButton
{
    if(!_girlButton){
        _girlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_girlButton setImage:XWImageName(@"vest_GIRL") forState:UIControlStateNormal];
        [_girlButton setImage:XWImageName(@"vest_GIRL_on") forState:UIControlStateSelected];
        kXWWeakSelf(weakself);
        [_girlButton setAction:^{
            [weakself.girlButton setSelected:YES];
            [weakself.boyButton setSelected:NO];
            [VESTUserTool saveSex:@"2"];
        }];
    }
    return _girlButton;
}

- (UIButton *)boyButton
{
    if(!_boyButton){
        _boyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_boyButton setImage:XWImageName(@"vest_GUY") forState:UIControlStateNormal];
        [_boyButton setImage:XWImageName(@"vest_GUY_on") forState:UIControlStateSelected];
        kXWWeakSelf(weakself);
        [_boyButton setAction:^{
            [weakself.girlButton setSelected:NO];
            [weakself.boyButton setSelected:YES];
            [VESTUserTool saveSex:@"1"];
        }];
    }
    return _boyButton;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:XWImageName(@"vest_nextBtn") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            
            [weakself check];
//            ;
        }];
    }
    return _nextButton;
}



- (UIButton *)signInButton
{
    if(!_signInButton){
        _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signInButton setImage:XWImageName(@"vest_SignIn_btn") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_signInButton setAction:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _signInButton;
}


@end
