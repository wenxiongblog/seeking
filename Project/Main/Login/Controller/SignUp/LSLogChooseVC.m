//
//  LSLogChooseVC.m
//  Project
//
//  Created by XuWen on 2020/2/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSLogChooseVC.h"
#import "LSSignInVC.h"
#import "SEEKING_UserModel.h"
#import "LSSignUpNameVC.h"
#import "LSProtocolViewController.h"
#import "LSGenderChooseView.h"

@interface LSLogChooseVC ()

@property (nonatomic,strong) UIButton *manButton;
@property (nonatomic,strong) UIButton *womanButton;

@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UILabel *termLabel;
@property (nonatomic,strong) UIButton *termButton;
@property (nonatomic,strong) UIButton *privateButton;
@end
    
@implementation LSLogChooseVC
    
#pragma mark - 埋点
- (void)MDChooseGender01{}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    //埋点
    [self MDChooseGender01];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.titleLabel.text = kLanguage(@"I‘m a");
    [self.titleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(30) aliment:NSTextAlignmentLeft];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.manButton];
    [self.view addSubview:self.womanButton];
    
    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.termLabel];
    [self.view addSubview:self.termButton];
    [self.view addSubview:self.privateButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(kStatusBarHeight+100);
    }];
    
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(126)));
        make.height.equalTo(@(XW(166)));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.right.equalTo(self.view.mas_centerX).offset(-20);
    }];
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.manButton);
        make.top.equalTo(self.manButton);
        make.left.equalTo(self.view.mas_centerX).offset(20);
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.termLabel.mas_top).offset(-100);
    }];
    
    [self.termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.termButton.mas_top).offset(-2);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view);
    }];
    [self.termButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.bottom.equalTo(self.privateButton);
    }];
    [self.privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
    }];
 
}


#pragma mark - setter & getter1

- (UILabel *)termLabel
{
    if(!_termLabel){
        _termLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor darkGrayColor] font:Font(12) aliment:NSTextAlignmentCenter];
        _termLabel.text = kLanguage(@"By continuing you agree with");
    }
    return _termLabel;
}

- (UIButton *)termButton
{
    if(!_termButton){
        _termButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Terms of service") font:Font(12) titleColor:[UIColor darkGrayColor] aliment:UIControlContentHorizontalAlignmentRight];
        kXWWeakSelf(weakself);
        [_termButton setAction:^{
            LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
            vc.fileType = 0;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _termButton;
}

- (UIButton *)privateButton
{
    if(!_privateButton){
        _privateButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Privacy agreement") font:Font(12) titleColor:[UIColor darkGrayColor] aliment:UIControlContentHorizontalAlignmentLeft];
        kXWWeakSelf(weakself);
        [_privateButton setAction:^{
            LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
            vc.fileType = 1;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _privateButton.hidden = YES;
    }
    return _privateButton;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Next") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            LSSignUpNameVC *vc = [[LSSignUpNameVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (UIButton *)manButton
{
    if(!_manButton){
        _manButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_manButton xwDrawCornerWithRadiuce:20];
        _manButton.backgroundColor = [UIColor whiteColor];
        [_manButton setBackgroundImage:XWImageName(kLanguage(@"man")) forState:UIControlStateNormal];
        [_manButton setBackgroundImage:XWImageName(kLanguage(@"man_s")) forState:UIControlStateSelected];
        kXWWeakSelf(weakself);
        [_manButton setAction:^{
            kUser.sex = 1;
            kUser.seeking = 2;
            weakself.manButton.selected = YES;
            weakself.womanButton.selected = NO;
            weakself.nextButton.userInteractionEnabled = YES;
            weakself.nextButton.selected = YES;
        }];
    }
    return _manButton;
}

- (UIButton *)womanButton
{
    if(!_womanButton){
        _womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_womanButton xwDrawCornerWithRadiuce:20];
        _womanButton.backgroundColor = [UIColor whiteColor];
        [_womanButton setBackgroundImage:XWImageName(kLanguage(@"woman")) forState:UIControlStateNormal];
        [_womanButton setBackgroundImage:XWImageName(kLanguage(@"woman_s")) forState:UIControlStateSelected];
        kXWWeakSelf(weakself);
        [_womanButton setAction:^{
            kUser.sex = 2;
            kUser.seeking = 1;
            weakself.manButton.selected = NO;
            weakself.womanButton.selected = YES;
            weakself.nextButton.userInteractionEnabled = YES;
            weakself.nextButton.selected = YES;
        }];
    }
    return _womanButton;
}

@end
