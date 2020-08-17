//
//  LSChooseYourselfView.m
//  Project
//
//  Created by XuWen on 2020/2/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSChooseYourselfView.h"

@interface LSChooseYourselfView()<UITextViewDelegate>
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *doneButton;
@property (nonatomic,strong) UIButton *skipButton;
@end

@implementation LSChooseYourselfView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstaintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleView];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.textView];
    [self addSubview:self.doneButton];
    [self addSubview:self.skipButton];
}

- (void)baseConstaintsConfig
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(60));
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(XW(130)));
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(23);
        make.centerX.equalTo(self);
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@(XW(300)));
        make.centerX.equalTo(self);
        make.top.equalTo(self.textView.mas_bottom).offset(22.5);
    }];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.doneButton);
        make.centerX.equalTo(self);
        make.top.equalTo(self.doneButton.mas_bottom).offset(12.5);
    }];
}



#pragma mark - setter & getter1
- (UIView *)titleView
{
    if(!_titleView){
        _titleView = [[UIView alloc]init];
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(24) aliment:NSTextAlignmentCenter];
        label.text = @"Tell us a little about yourself";
        label.numberOfLines = 0;
        [_titleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleView);
            make.centerY.equalTo(self.titleView);
        }];
    }
    return _titleView;
}

- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8E8E8E"] font:Font(12) aliment:NSTextAlignmentCenter];
        _subTitleLabel.text = @"No pressure, you can change this later";
    }
    return _subTitleLabel;
}

- (UITextView *)textView
{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor xwColorWithHexString:@"#E9E9E9"];
        _textView.textColor = [UIColor blackColor];
        [_textView xwDrawCornerWithRadiuce:5];
        _textView.delegate = self;
    }
    return _textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.doneButton.selected = [textView.text trim].length > 0;
    self.doneButton.userInteractionEnabled = [textView.text trim].length > 0;
}

- (UIButton *)doneButton
{
    if(!_doneButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"DONE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            if(weakself.chooseBlock){
                weakself.chooseBlock(1, [self.textView.text trim]);
            }
        }];
        _doneButton = button;
    }
    return _doneButton;
}

- (UIButton *)skipButton
{
    if(!_skipButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Skip") font:Font(18) titleColor:[UIColor xwColorWithHexString:@"#8E8E8E"] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [button setAction:^{
            if(weakself.chooseBlock){
                weakself.chooseBlock(1, @"");
            }
        }];
        _skipButton = button;
    }
    return _skipButton;
}


@end
