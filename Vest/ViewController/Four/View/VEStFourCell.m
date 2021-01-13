//
//  VEStFourCell.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VEStFourCell.h"

@interface VEStFourCell()
@property (nonatomic,strong) UIView *placeView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@end

@implementation VEStFourCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.subTitleLabel];
}

- (void)baseConstriantsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.placeView);
        make.left.equalTo(self.placeView).offset(15);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.placeView).offset(-15);
        make.centerY.equalTo(self.placeView);
    }];
}

#pragma mark - setter & getter
-(UIView *)placeView
{
    if(!_placeView){
        _placeView = [[UIView alloc]init];
        _placeView.backgroundColor = [UIColor whiteColor];
    }
    return _placeView;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:FontMediun(18) aliment:NSTextAlignmentLeft];
        _nameLabel.text = @"Semibold";
    }
    return _nameLabel;
}
- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#C6C6C6"] font:Font(18) aliment:NSTextAlignmentRight];
        _subTitleLabel.text = @"1.0.0v";
    }
    return _subTitleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.nameLabel.text = title;
    self.subTitleLabel.hidden = ![title containsString:@"Version"];
}
@end
