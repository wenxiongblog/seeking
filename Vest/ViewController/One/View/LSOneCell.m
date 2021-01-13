//
//  LSOneCell.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSOneCell.h"

@interface LSOneCell()
@property (nonatomic,strong) UIView *placeView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UIImageView *countBgImageView;
@property (nonatomic,strong) UIImageView *countImageView;
@property (nonatomic,strong) UILabel *countLabel;

@end

@implementation LSOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    [self commonTableViewCellConfig];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.placeView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.countBgImageView];
}

- (void)baseConstriantsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@110);
        make.centerY.equalTo(self.placeView);
        make.left.equalTo(self.placeView).offset(16);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeView).offset(40);
        make.left.equalTo(self.headImageView.mas_right).offset(14);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    [self.countBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.placeView);
        make.height.equalTo(@24);
        make.width.equalTo(@75);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-15);
    }];
}

#pragma mark - setter & getter
- (UIView *)placeView
{
    if(!_placeView){
        _placeView = [[UIView alloc]init];
        _placeView.backgroundColor = [UIColor whiteColor];
        [_placeView xwDrawCornerWithRadiuce:35];
    }
    return _placeView;
}

- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        [_headImageView xwDrawCornerWithRadiuce:55];
        _headImageView.backgroundColor =[UIColor xwRandomColor];
    }
    return _headImageView;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(24) aliment:NSTextAlignmentLeft];
        _nameLabel.text = @"Chat";
    }
    return _nameLabel;
}

- (UILabel *)typeLabel
{
    if(!_typeLabel){
        _typeLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwRandomColor] font:Font(15) aliment:NSTextAlignmentLeft];
        _typeLabel.text = @"CHAT";
    }
    return _typeLabel;
}

- (UIImageView *)countBgImageView
{
    if(!_countBgImageView){
        _countBgImageView = [[UIImageView alloc]init];
        _countBgImageView.backgroundColor = [UIColor xwColorWithHexString:@"#FB898B"];
        [_countBgImageView xwDrawbyRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft withRadiuce:12];
        //
        self.countImageView = [[UIImageView alloc]initWithImage:XWImageName(@"")];
        [_countBgImageView addSubview:self.countImageView];
        [self.countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.left.equalTo(self.countBgImageView).offset(10);
            make.centerY.equalTo(self.countBgImageView);
        }];
        //
        self.countLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(12) aliment:NSTextAlignmentLeft];
        self.countLabel.text = @"1/6";
        [self.countBgImageView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countBgImageView);
            make.left.equalTo(self.countImageView.mas_right).offset(10);
        }];
    }
    return _countBgImageView;
}

- (void)setUserModel:(VESTUserModel *)userModel
{
    _userModel = userModel;
    self.headImageView.image = XWImageName(userModel.headUrl);
    self.nameLabel.text = userModel.name;
}
@end
