//
//  LSNotiLikeCell.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotiLikeCell.h"

@interface LSNotiLikeCell()
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *subtitleLabel;
@end

@implementation LSNotiLikeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}



#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.contentView.backgroundColor = [UIColor projectBlueColor];
    [self.contentView addSubview:self.headImageView];
    [self.contentView xwDrawCornerWithRadiuce:5];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.subtitleLabel];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(XW(60)));
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.bottom.equalTo(self.headImageView.mas_centerY).offset(-5);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headImageView xwDrawCornerWithRadiuce:XW(30)];
    }
    return _headImageView;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentLeft];
        _nameLabel = label;
    }
    return _nameLabel;
}
- (UILabel *)subtitleLabel
{
    if(!_subtitleLabel){
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor grayColor] font:Font(12) aliment:NSTextAlignmentLeft];
        _subtitleLabel = label;
    }
    return _subtitleLabel;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:customer.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
    self.nameLabel.text = [customer.name filter];
    self.subtitleLabel.text = [NSString stringWithFormat:@"%dyrs,City:%@",customer.age,customer.address];
}

@end
