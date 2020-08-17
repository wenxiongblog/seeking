//
//  LSGenderChooseView.m
//  Project
//
//  Created by XuWen on 2020/5/12.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSGenderChooseView.h"

@interface LSGenderChooseView ()
@property (nonatomic,strong)UIButton *manButton;
@property (nonatomic,strong)UIButton *womanButton;
@property (nonatomic,assign,readwrite) int gender;
@property (nonatomic,strong)UIView *lineView;
@end


@implementation LSGenderChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstraintConfig];
    }
    return self;
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self xwDrawCornerWithRadiuce:5];
    self.backgroundColor = [UIColor xwColorWithHexString:@"#DCDCDC"];
    [self addSubview:self.manButton];
    [self addSubview:self.womanButton];
    [self addSubview:self.lineView];
}

- (void)baseConstraintConfig
{
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.mas_centerX);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.height.equalTo(@20);
        make.center.equalTo(self);
    }];
}

#pragma mark - event
- (void)buttonClicked:(UIButton *)sender
{
    //1男，2女
    self.gender = (int)sender.tag;
    self.manButton.selected = sender.tag == 1;
    self.womanButton.selected = sender.tag == 2;
    if(self.genderChooseBlock){
        self.genderChooseBlock((int)sender.tag);
    }
    
}


#pragma mark - setter & getter1
- (UIButton *)manButton
{
    if(!_manButton){
        _manButton = [UIButton creatCommonButtonConfigWithTitle:@"Man" font:Font(18) titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _manButton.tag = 1;
        [_manButton setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateSelected];
        [_manButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manButton;
}

- (UIButton *)womanButton
{
    if(!_womanButton){
        _womanButton = [UIButton creatCommonButtonConfigWithTitle:@"Woman" font:Font(18) titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_womanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _womanButton.tag = 2;
        [_womanButton setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateSelected];
        [_womanButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _womanButton;
}

- (UIView *)lineView
{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor xwColorWithHexString:@"#AEAEAE"];
        [_lineView xwDrawCornerWithRadiuce:1];
    }
    return _lineView;
}


@end
