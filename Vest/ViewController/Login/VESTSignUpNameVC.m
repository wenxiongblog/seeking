//
//  VESTSignUpNameVC.m
//  Project
//
//  Created by XuWen on 2020/9/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTSignUpNameVC.h"
#import "VESTNameInputView.h"
#import "XWChooseImageButton.h"
#import "VESTUserTool.h"
#import "VESTSignUpVC.h"
#import "VESTTabBarVC.h"

@interface VESTSignUpNameVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) XWChooseImageButton *headButton;
@property (nonatomic,strong) VESTNameInputView *nameInputView;
@property (nonatomic,strong) UIButton *nextButton;

//iamge
@property (nonatomic,strong) UIImage *image;

@end

@implementation VESTSignUpNameVC

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
    [self.view addSubview:self.headButton];
    [self.view addSubview:self.nameInputView];
    [self.view addSubview:self.nextButton];
}
- (void)baseConstraitsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.view).offset(100+kStatusBarAndNavigationBarHeight-20);
    }];
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(82*2)));
        make.height.equalTo(@(XW(100*2)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    [self.nameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(265)));
        make.height.equalTo(@(56));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headButton.mas_bottom).offset(20);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@62);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nameInputView.mas_bottom).offset(62);
    }];
}

#pragma mark - private
- (BOOL)check
{
    if(self.image == nil){
        [AlertView toast:@"Please choose your head image" inView:self.view];
        return NO;
    }
    if(self.nameInputView.value.length == 0){
        [AlertView toast:@"Input your name" inView:self.view];
        return NO;
    }
    
    //保存信息
    [VESTUserTool SaveHeadImageToLocal:self.image];
    [VESTUserTool saveName:self.nameInputView.value];
    
    //跳转
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"kVestIsLogin"];
    [VESTTabBarVC jumpVESTTabVC];
    
    return YES;
}

#pragma mark - getter & setter
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"SIGN UP";
    }
    return _titleLabel;
}

- (XWChooseImageButton *)headButton
{
    if(!_headButton){
        _headButton = [[XWChooseImageButton alloc]initWithFrame:CGRectZero eventViewController:self];
        _headButton.allowsEditing = YES;
        _headButton.isNeedUpload = NO;
        [_headButton xwDrawCornerWithRadiuce:25];
        [_headButton setBackgroundImage:XWImageName(@"vest_add_photo") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        _headButton.chooseImageBlock = ^(UIImage *image) {
            //本地保存图片
            weakself.image = image;
            [weakself.headButton setBackgroundImage:[VESTUserTool GetHeadImageFromLocal] forState:UIControlStateNormal];
        };
    }
    return _headButton;
}

- (VESTNameInputView *)nameInputView
{
    if(!_nameInputView){
        _nameInputView = [[VESTNameInputView alloc]init];
        [_nameInputView xwDrawCornerWithRadiuce:28];
    }
    return _nameInputView;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:XWImageName(@"vest_nextBtn") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            [weakself check];
        }];
    }
    return _nextButton;
}
@end
