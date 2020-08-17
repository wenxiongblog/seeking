//
//  LSIncognitoModeCell.m
//  Project
//
//  Created by XuWen on 2020/6/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSIncognitoModeCell.h"
#import "LSVIPAlertView.h"

@interface LSIncognitoModeCell ()
@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UISwitch *swich;
@end

@implementation LSIncognitoModeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self commonTableViewCellConfig];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor projectBlueColor];
    [self.contentView addSubview:self.titleImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.swich];
    
    [self.contentView xwDrawbyRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadiuce:10];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(self.contentView).offset(25);
        make.centerY.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView).offset(-12);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
    }];
    [self.swich mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}

#pragma mark - eventChange
- (void)swithchChanged:(UISwitch *)swich
{
    if(kUser.isVIP){
        if(self.ISIncognitoBlock){
            self.ISIncognitoBlock(swich.isOn?1:0);
        }
    }else{
        [self.swich setOn:NO];
        [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_Incognito];
    }
    
}


#pragma mark - setter & getter1
- (UIImageView *)titleImageView
{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]init];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#5B5977"] font:Font(12) aliment:NSTextAlignmentLeft];
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = kLanguage(@"Only people you message or like\nwill be able to see you");
    }
    return _subTitleLabel;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.titleLabel.text = kLanguage(name);
    self.titleImageView.image = XWImageName(name);
}

- (UISwitch *)swich
{
    if(!_swich){
        _swich = [[UISwitch alloc]init];
        [_swich addTarget:self action:@selector(swithchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _swich;
}

- (void)setIsIncognito:(BOOL)isIncognito
{
    _isIncognito = isIncognito;
    [self.swich setOn:isIncognito];
}
@end
