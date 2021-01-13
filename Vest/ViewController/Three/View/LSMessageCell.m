//
//  LSMessageCell.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMessageCell.h"

@interface LSMessageCell()
@property (nonatomic,strong) UIView *placeView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *messagLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation LSMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstraitsConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    [self commonTableViewCellConfig];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.placeView];
    [self.placeView addSubview:self.headImageView];
    [self.placeView addSubview:self.nameLabel];
    [self.placeView addSubview:self.messagLabel];
    [self.placeView addSubview:self.timeLabel];
}

- (void)baseConstraitsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.greaterThanOrEqualTo(@(86));
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@66);
        make.left.equalTo(self.placeView).offset(12.5);
        make.top.equalTo(self.placeView).offset(10);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self.placeView).offset(20);
    }];
    [self.messagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.placeView).offset(-25);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.placeView).offset(-20);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.placeView).offset(-25);
        make.top.equalTo(self.placeView).offset(16);
    }];
}

#pragma mark - setter & getter
- (UIView *)placeView
{
    if(!_placeView){
        _placeView = [[UIView alloc]init];
        _placeView.backgroundColor = [UIColor whiteColor];
        [_placeView xwDrawCornerWithRadiuce:43];
    }
    return _placeView;
}
- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor xwRandomColor];
        [_headImageView xwDrawCornerWithRadiuce:33];
    }
    return _headImageView;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentLeft];
        _nameLabel.text = @"name";
    }
    return _nameLabel;
}

- (UILabel *)messagLabel
{
    if(!_messagLabel){
        _messagLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#BBBBBB"] font:Font(12) aliment:NSTextAlignmentLeft];
        _messagLabel.numberOfLines = 0;
        _messagLabel.text = @"asdfasdfasdfasdfasdfasdfa";
    }
    return _messagLabel;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#BBBBBB"] font:Font(12) aliment:NSTextAlignmentRight];
        _timeLabel.text = @"2010-11-11";
    }
    return _timeLabel;
}

- (void)setMessageModel:(VESTMessageModel *)messageModel
{
    _messageModel = messageModel;
    self.headImageView.image = XWImageName(messageModel.headUrl);
    self.nameLabel.text = messageModel.name;
    self.messagLabel.text = messageModel.text;
    self.timeLabel.text = messageModel.time;
}

@end
