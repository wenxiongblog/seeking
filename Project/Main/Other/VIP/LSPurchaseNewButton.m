//
//  LSPurchaseNewButton.m
//  Project
//
//  Created by XuWen on 2020/7/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPurchaseNewButton.h"

@interface LSPurchaseNewButton()
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UILabel *dayCountLabel;
@property (nonatomic,strong) UILabel *dayLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@end

@implementation LSPurchaseNewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    self.backgroundColor = [UIColor xwColorWithHexString:@"#00A708"];
    [self xwDrawCornerWithRadiuce:5];
    [self addSubview:self.whiteView];
    [self addSubview:self.dayCountLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.button];
}

- (void)baseConstraintsConfig
{
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(self.whiteView.mas_width);
    }];
    [self.dayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView);
        make.top.equalTo(self.whiteView).offset(10);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView);
        make.top.equalTo(self.dayCountLabel.mas_bottom).offset(2);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView);
        make.top.equalTo(self.whiteView.mas_bottom).offset(10);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - setter & getter
- (UIView *)whiteView
{
    if(!_whiteView){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_whiteView xwDrawCornerWithRadiuce:5];
    }
    return _whiteView;
}

- (UILabel *)dayCountLabel
{
    if(!_dayCountLabel){
        _dayCountLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontBold(42) aliment:NSTextAlignmentCenter];
        _dayCountLabel.text = @"180";
    }
    return _dayCountLabel;
}

- (UILabel *)dayLabel
{
    if(!_dayLabel){
        _dayLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontBold(20) aliment:NSTextAlignmentCenter];
        _dayLabel.text = kLanguage(@"DAYS");
    }
    return _dayLabel;
}

- (UILabel *)priceLabel
{
    if(!_priceLabel){
        _priceLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(16) aliment:NSTextAlignmentCenter];
    }
    return _priceLabel;
}

- (void)setModel:(LSPurchaseModel *)model
{
    _model = model;
    self.dayCountLabel.text = model.dayCount;
    self.priceLabel.text = model.priceStr;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if(selected){
        self.backgroundColor = [UIColor xwColorWithHexString:@"#00A708"];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.dayCountLabel.textColor = [UIColor projectMainTextColor];
        self.dayLabel.textColor = [UIColor projectMainTextColor];
        self.priceLabel.textColor = [UIColor whiteColor];
    }else{
        self.whiteView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor xwColorWithHexString:@"#19191D"];
        self.dayCountLabel.textColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.priceLabel.textColor = [UIColor xwColorWithHexString:@"#494956"];
    }
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
    }
    return _button;
}

@end
