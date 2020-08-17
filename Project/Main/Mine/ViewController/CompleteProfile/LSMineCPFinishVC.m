//
//  LSMineCPFinishVC.m
//  Project
//
//  Created by XuWen on 2020/5/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineCPFinishVC.h"

@interface LSMineCPFinishVC()


@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *nextButton; //下一步
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subLabel;
@end

@implementation LSMineCPFinishVC

- (void)MDProfileFinish{}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self baseConstrainsConfig];
    [self MDProfileFinish];
}


- (void)SEEKING_baseUIConfig
{
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor xwColorWithHexString:@"#4B75EC"];
    [self.view addSubview:self.closeButton];
    
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
    label.text = kLanguage(@"Complete profile");
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeButton);
        make.centerX.equalTo(self.view);
    }];
    //contentView
    [self.view addSubview:self.contentView];
}

- (void)baseConstrainsConfig
{
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.equalTo(self.view).offset(15);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-100);
    }];
}


#pragma mark - setter & getter1
- (UIButton *)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage: XWImageName(@"Mine_complete_close") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_closeButton setAction:^{
            if(weakself.closeBlock){
                weakself.closeBlock(YES);
            }
        }];
    }
    return _closeButton;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView xwDrawCornerWithRadiuce:5];
        
        // 下一步按钮
        [_contentView addSubview:self.nextButton];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.right.equalTo(self.contentView).offset(-13);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
            make.height.equalTo(@50);
        }];
        
        //文字
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.subLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        
        UIImageView *goodImageView = [[UIImageView alloc]initWithImage:XWImageName(@"Mine_complete_finish")];
        goodImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentView addSubview:goodImageView];
        [goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@125);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-80);
        }];
    }
    
    return _contentView;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Meet new people") font:FontMediun(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_nextButton xwDrawCornerWithRadiuce:5];
        _nextButton.backgroundColor = [UIColor themeColor];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            
            if(weakself.closeBlock){
                weakself.closeBlock(YES);
            }
        }];
    }
    return _nextButton;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(18) aliment:NSTextAlignmentCenter];
        _titleLabel.text = kLanguage(@"Your profile photos look nice!");
    }
    return _titleLabel;
}

- (UILabel *)subLabel
{
    if(!_subLabel){
        _subLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor lightGrayColor] font:Font(12) aliment:NSTextAlignmentCenter];
        _subLabel.text = kLanguage(@"Go to Finder and show it to new people");
    }
    return _subLabel;
}


@end
