//
//  VESTMineHeadView.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTMineHeadView.h"
#import "VESTChargeVC.h"
#import "VESTUserTool.h"

@interface VESTMineHeadView()
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *vipImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIButton *editButton;

@property (nonatomic,strong) UIView *moneyView;
@property (nonatomic,strong) UIImageView *coinImageView;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIButton *chargeButton;

@end

@implementation VESTMineHeadView

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
    [self addSubview:self.headView];
    [self addSubview:self.moneyView];
}

- (void)baseConstraintsConfig
{
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(145));
        make.top.equalTo(self);
    }];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(14);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(81));
    }];
}

#pragma mark - setter & getter
- (UIView *)headView
{
    if(!_headView){
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView xwDrawCornerWithRadiuce:25];
        
        
        [_headView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@100);
            make.centerY.equalTo(self.headView);
            make.left.equalTo(self.headView).offset(12.5);
        }];
        
        [_headView addSubview:self.nameLabel];
        [_headView addSubview:self.ageLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.top.equalTo(self.headView).offset(70);
        }];
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        }];
        
        [_headView addSubview:self.editButton];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.bottom.right.equalTo(self.headImageView);
        }];
        
        [_headView addSubview:self.vipImageView];
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(73));
            make.height.equalTo(@(38));
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-10);
        }];
    }
    return _headView;
}
- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor xwRandomColor];
        [_headImageView xwDrawCornerWithRadiuce:50];
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _nameLabel.text = @"niahs";
    }
    return _nameLabel;
}
- (UILabel *)ageLabel
{
    if(!_ageLabel){
        _ageLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#129BF5"] font:Font(15) aliment:NSTextAlignmentLeft];
        _ageLabel.text = @"27 yers";
    }
    return _ageLabel;
}

- (UIButton *)editButton
{
    if(!_editButton){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:XWImageName(@"vest_edit") forState:UIControlStateNormal];
        _editButton.hidden = YES;
    }
    return _editButton;
}

- (UIView *)moneyView
{
    if(!_moneyView){
        _moneyView = [[UIView alloc]init];
        _moneyView.backgroundColor = [UIColor whiteColor];
        [_moneyView xwDrawCornerWithRadiuce:25];
        
        [_moneyView addSubview:self.coinImageView];
        [_moneyView addSubview:self.countLabel];
        [_moneyView addSubview:self.chargeButton];
        [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
            make.height.equalTo(@40);
            make.centerY.equalTo(self.moneyView);
            make.left.equalTo(self.moneyView).offset(30);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coinImageView.mas_right).offset(30);
            make.centerY.equalTo(self.coinImageView);
        }];
        [self.chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@90);
            make.height.equalTo(@38);
            make.centerY.equalTo(self.moneyView);
            make.right.equalTo(self.moneyView).offset(-30);
        }];
    }
    return _moneyView;
}

- (UIImageView *)coinImageView
{
    if(!_coinImageView){
        _coinImageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_coins")];
    }
    return _coinImageView;
}

- (UILabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#171351"] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _countLabel.text = @"0";
    }
    return _countLabel;
}

- (UIButton *)chargeButton
{
    if(!_chargeButton){
        _chargeButton = [UIButton creatCommonButtonConfigWithTitle:@"Recharge" font:FontBold(15) titleColor:[UIColor whiteColor] aliment:0];
        [_chargeButton setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateNormal];
        [_chargeButton xwDrawCornerWithRadiuce:19];
        kXWWeakSelf(weakself);
        [_chargeButton setAction:^{
            VESTChargeVC *vc = [[VESTChargeVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakself.eventVC.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _chargeButton;
}

- (void)setHeadImage:(UIImage *)headImage
{
    _headImage = headImage;
    self.headImageView.image = headImage;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setAge:(NSInteger)age
{
    _age = age;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld yrs",(long)age];
}

- (UIImageView *)vipImageView
{
    if(!_vipImageView){
        _vipImageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_VIP_icon")];
    }
    return _vipImageView;
}

- (void)setIsVIP:(BOOL)isVIP
{
    _isVIP = isVIP;
    self.vipImageView.hidden = !isVIP;
}

- (void)setCoins:(NSInteger)coins
{
    _coins = coins;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",coins];
}
@end
