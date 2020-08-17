//
//  LSUploadPhotoVC.m
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSUploadPhotoVC.h"
#import "LSSignUpHeadVC.h"

@interface LSUploadPhotoVC ()
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) UIImageView *uploadView0;
@property (nonatomic,strong) UIImageView *uploadView1;
@property (nonatomic,strong) UIImageView *uploadView2;
@property (nonatomic,strong) UIImageView *uploadView3;
@property (nonatomic,strong) UIImageView *uploadView4;
@property (nonatomic,strong) UIImageView *uploadView5;

@property (nonatomic,strong) UIButton *nextButton;

//临时数据
@property (nonatomic,strong) NSMutableArray *imageStrArray;

@end

@implementation LSUploadPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.uploadView0 = [[UIImageView alloc]initWithImage:XWImageName(@"model1")];
    self.uploadView1 = [[UIImageView alloc]initWithImage:XWImageName(@"model2")];
    self.uploadView2 = [[UIImageView alloc]initWithImage:XWImageName(@"model3")];
    self.uploadView3 = [[UIImageView alloc]initWithImage:XWImageName(@"model4")];
    self.uploadView4 = [[UIImageView alloc]initWithImage:XWImageName(@"model5")];
    self.uploadView5 = [[UIImageView alloc]initWithImage:XWImageName(@"model6")];
    
    [self.view addSubview:self.uploadView0];
    [self.view addSubview:self.uploadView1];
    [self.view addSubview:self.uploadView2];
    [self.view addSubview:self.uploadView3];
    [self.view addSubview:self.uploadView4];
    [self.view addSubview:self.uploadView5];
    
    
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.subTitleLable];
    
    [self.view addSubview:self.nextButton];
}



- (void)baseConstriantsConfig
{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTabbarHeight+20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    CGFloat width = (kSCREEN_WIDTH - 60 -20)/3.0;
    [self.uploadView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(width/100*142));
        make.top.equalTo(self.subTitleLable.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
    }];
    [self.uploadView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.uploadView0);
        make.top.equalTo(self.uploadView0);
        make.left.equalTo(self.uploadView0.mas_right).offset(10);
    }];
    [self.uploadView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.uploadView0);
        make.top.equalTo(self.uploadView0);
        make.left.equalTo(self.uploadView1.mas_right).offset(10);
    }];
    [self.uploadView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.uploadView0);
        make.top.equalTo(self.uploadView0.mas_bottom).offset(10);
        make.left.equalTo(self.uploadView0);
    }];
    [self.uploadView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.uploadView0);
        make.top.equalTo(self.uploadView3);
        make.left.equalTo(self.uploadView1);
    }];
    [self.uploadView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.uploadView0);
        make.top.equalTo(self.uploadView3);
        make.left.equalTo(self.uploadView2);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadView3);
        make.right.equalTo(self.uploadView5);
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.uploadView5.mas_bottom).offset(20);
    }];
    
}


#pragma mark - setter & getter1
- (UILabel *)titleLable
{
    if(!_titleLable){
        _titleLable = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentLeft];
        _titleLable.numberOfLines = 2;
        _titleLable.text = kLanguage( @"Upload your profile photo");
    }
    return _titleLable;
}

- (UILabel *)subTitleLable
{
    if(!_subTitleLable){
        _subTitleLable = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8B8B8B"] font:FontMediun(18) aliment:NSTextAlignmentLeft];
        _subTitleLable.text = kLanguage(@"Please keep your profile photo clearly visible, no nudes, blurred and fake photos allowed.");
        _subTitleLable.numberOfLines = 0;
    }
    return _subTitleLable;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"UPLOAD PHOTO") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [button setAction:^{
            LSSignUpHeadVC *vc = [[LSSignUpHeadVC alloc]init];
            vc.isReUpload = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _nextButton = button;
    }
    return _nextButton;
}



@end
