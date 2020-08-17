//
//  LSSearchPrivilegeVC.m
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSearchPrivilegeVC.h"
#import "LSUploadPhotoVC.h"
#import "LSMineCPConfig.h"
#import "LSMinePCNav.h"
#import "LSCuteManVC.h"

@interface LSSearchPrivilegeVC ()

@property (nonatomic,strong) UILabel *titleLabel1;
@property (nonatomic,strong) UIProgressView *progress1;
@property (nonatomic,strong) UILabel *crrentLabel1;
@property (nonatomic,strong) UIButton *uploadButton1;

@property (nonatomic,strong) UILabel *titleLabel2;
@property (nonatomic,strong) UIProgressView *progress2;
@property (nonatomic,strong) UILabel *crrentLabel2;
@property (nonatomic,strong) UIButton *uploadButton2;

@property (nonatomic,strong) UIButton *nextButton;

@end

@implementation LSSearchPrivilegeVC

//埋点
- (void)MDCute_man_photo{};
- (void)MDCute_man_profile{};
- (void)MDCute_man_nextstep{};
- (void)MDCute_woman_photo{};
- (void)MDCute_woman_profile{};
- (void)MDCute_woman_nextstep{};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self uplaodData];
}

#pragma mark - data
- (void)uplaodData
{
    //照片
    NSInteger imageCount = 0;
    if(kUser.images !=nil){
        imageCount++;
    }
    
    NSArray *imageArray = nil;
    if(kUser.imageslist.length > 10){
        [kUser.imageslist componentsSeparatedByString:@","];
    }
    
    imageCount = imageCount + imageArray.count;
    self.progress1.progress = imageCount/3.0;
    self.crrentLabel1.text = [NSString stringWithFormat:@"%@ %ld/3",kLanguage(@"Current"),imageCount];
    
    //profile
    self.progress2.progress = kUser.infoPersent/100.0;
    self.crrentLabel2.text = [NSString stringWithFormat:@"%@ %d%%",kLanguage(@"Current"),kUser.infoPersent];
    
    //按钮是否可用
    self.nextButton.selected = (self.progress1.progress>=1 && self.progress2.progress>=1);
    self.nextButton.userInteractionEnabled = (self.progress1.progress>=1 && self.progress2.progress>=1);
//    self.nextButton.userInteractionEnabled = YES;
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentCenter];
    label.text = kLanguage(@"Privilege of view");
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.centerX.equalTo(self.view);
    }];
    [self.backButton setImage:XWImageName(@"Elite_Close") forState:UIControlStateNormal];
    self.backButton.hidden = NO;
    
    //
    [self.view addSubview:self.titleLabel1];
    [self.view addSubview:self.progress1];
    [self.view addSubview:self.crrentLabel1];
    [self.view addSubview:self.uploadButton1];
    
    [self.view addSubview:self.titleLabel2];
    [self.view addSubview:self.progress2];
    [self.view addSubview:self.crrentLabel2];
    [self.view addSubview:self.uploadButton2];
    
    [self.view addSubview:self.nextButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight+40);
    }];
    [self.progress1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(9));
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(20);
    }];
    [self.crrentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progress1);
        make.top.equalTo(self.progress1.mas_bottom).offset(10);
    }];
    [self.uploadButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(335)));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.crrentLabel1.mas_bottom).offset(22);
    }];
    
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.uploadButton1.mas_bottom).offset(60);
    }];
    [self.progress2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(9));
        make.top.equalTo(self.titleLabel2.mas_bottom).offset(20);
    }];
    [self.crrentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progress2);
        make.top.equalTo(self.progress2.mas_bottom).offset(10);
    }];
    [self.uploadButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(335)));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.crrentLabel2.mas_bottom).offset(22);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(335)));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.uploadButton2.mas_bottom).offset(60);
    }];
}


#pragma mark - setter & getter1
- (UILabel *)titleLabel1
{
    if(!_titleLabel1){
        _titleLabel1 = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _titleLabel1.text = kLanguage(@"More than 3 photos");
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2
{
    if(!_titleLabel2){
        _titleLabel2 = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _titleLabel2.text = kLanguage(@"Profile progress");
    }
    return _titleLabel2;
}

- (UILabel *)crrentLabel1
{
    if(!_crrentLabel1){
        _crrentLabel1 = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8A8B9A"] font:Font(15) aliment:NSTextAlignmentRight];
    }
    return _crrentLabel1;
}

- (UILabel *)crrentLabel2
{
    if(!_crrentLabel2){
        _crrentLabel2 = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8A8B9A"] font:Font(15) aliment:NSTextAlignmentLeft];
    }
    return _crrentLabel2;
}

- (UIProgressView *)progress1
{
    if(!_progress1){
        _progress1 = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, XW(335), 10)];
        _progress1.backgroundColor = [UIColor xwColorWithHexString:@"#1E2E4D"];
        _progress1.tintColor = [UIColor themeColor];
        [_progress1 xwDrawCornerWithRadiuce:4.5];

    }
    return _progress1;
}

- (UIProgressView *)progress2
{
    if(!_progress2){
        _progress2 = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, XW(335), 10)];
        _progress2.backgroundColor = [UIColor xwColorWithHexString:@"#1E2E4D"];
        _progress2.tintColor = [UIColor themeColor];
        [_progress2 xwDrawCornerWithRadiuce:4.5];
    }
    return _progress2;
}

- (UIButton *)uploadButton1
{
    if(!_uploadButton1){
        _uploadButton1 = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Upload photos") font:FontBold(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _uploadButton1.backgroundColor = [UIColor themeColor];
        [_uploadButton1 xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_uploadButton1 setAction:^{
            if(kUser.sex == 1){
                [weakself MDCute_man_photo];
            }else if(kUser.sex == 2){
                [weakself MDCute_woman_photo];
            }
            
            LSUploadPhotoVC *vc = [[LSUploadPhotoVC alloc]init];
             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [weakself presentViewController:nav animated:YES completion:nil];
        }];
    }
    return _uploadButton1;
}

- (UIButton *)uploadButton2
{
    if(!_uploadButton2){
        _uploadButton2 = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Prefect the profile") font:FontBold(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _uploadButton2.backgroundColor = [UIColor themeColor];
        [_uploadButton2 xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_uploadButton2 setAction:^{
            
           if(kUser.sex == 1){
               [weakself MDCute_man_profile];
           }else if(kUser.sex == 2){
               [weakself MDCute_woman_profile];
           }
            
           LSMineCPConfig *config = [[LSMineCPConfig alloc]init];
           LSMinePCNav *nav = [[LSMinePCNav alloc]initWithRootViewController:config.vc];
           nav.modalPresentationStyle = UIModalPresentationFullScreen;
           [weakself presentViewController:nav animated:YES completion:nil];
        }];
    }
    return _uploadButton2;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"CONTINUE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            
            if(kUser.sex == 1){
                [weakself MDCute_man_nextstep];
            }else if(kUser.sex == 2){
                [weakself MDCute_woman_nextstep];
            }
            
            LSCuteManVC *vc = [[LSCuteManVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _nextButton = button;
    }
    return _nextButton;
}
@end
