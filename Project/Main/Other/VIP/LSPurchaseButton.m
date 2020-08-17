//
//  LSPurchaseButton.m
//  Project
//
//  Created by XuWen on 2020/3/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPurchaseButton.h"

@interface LSPurchaseButton ()
@property (nonatomic,strong) UILabel *dayCountLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@end

@implementation LSPurchaseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self addSubview:self.button];
    [self addSubview:self.dayCountLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
}

- (void)baseConstriantsConfig
{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.dayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.mas_centerY).offset(-0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.dayCountLabel.mas_right).offset(0);
        make.bottom.equalTo(self.mas_centerY).offset(-3);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(3);
    }];
}


#pragma mark - setter & getter1
- (UIButton *)button
{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:XWImageName(@"purchaseBg") forState:UIControlStateSelected];
    }
    return _button;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.button.selected = selected;
    self.dayCountLabel.textColor = self.titleLabel.textColor = self.priceLabel.textColor = selected?[UIColor whiteColor]:[UIColor xwColorWithHexString:@"#959595"];
}
- (UILabel *)dayCountLabel
{
    if(!_dayCountLabel){
        _dayCountLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#959595"] font:FontBold(24) aliment:NSTextAlignmentLeft];
    }
    return _dayCountLabel;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#959595"] font:Font(16) aliment:NSTextAlignmentCenter];
        _titleLabel.userInteractionEnabled = NO;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if(!_priceLabel){
        _priceLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#959595"] font:Font(16) aliment:NSTextAlignmentCenter];
        _priceLabel.userInteractionEnabled = NO;
    }
    return _priceLabel;
}

- (void)setModel:(LSPurchaseModel *)model
{
    _model = model;
//    self.dayCountLabel.text = model.dayCount;
//    self.titleLabel.text = @"DAYS";
//    self.priceLabel.text = model.priceStr;
    [self.button setBackgroundImage:XWImageName(model.imageStr) forState:UIControlStateNormal];
    NSString *str = [NSString stringWithFormat:@"%@_on",model.imageStr];
    [self.button setBackgroundImage:XWImageName(str) forState:UIControlStateSelected];
}
@end
