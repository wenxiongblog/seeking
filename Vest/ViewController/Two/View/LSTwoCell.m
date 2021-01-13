//
//  LSTwoCell.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSTwoCell.h"
@interface LSTwoCell()
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation LSTwoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    [self.contentView xwDrawCornerWithRadiuce:35];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)baseConstriantsConfig
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(XW(122)));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(XW(15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(XW(15));
    }];
}

#pragma mark - setter & getter
- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        [_headImageView xwDrawCornerWithRadiuce:XW(61)];
        _headImageView.backgroundColor =[UIColor xwRandomColor];
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(15) aliment:NSTextAlignmentCenter];
        _titleLabel.text = @"第一次测试直播";
    }
    return _titleLabel;
}

- (void)setUserModel:(VESTUserModel *)userModel
{
    _userModel = userModel;
    self.headImageView.image = XWImageName(userModel.headUrl);
    self.titleLabel.text = userModel.name;
}

@end
