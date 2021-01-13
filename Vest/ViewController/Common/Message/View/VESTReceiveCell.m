//
//  VESTReceiveCell.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTReceiveCell.h"

@interface VESTReceiveCell()
@property (nonatomic,strong) UIImageView *headImageview;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLable;
@end

@implementation VESTReceiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}
#pragma mark - baseConfig
- (void)baseUIConfig
{
    [self commonTableViewCellConfig];
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageview];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLable];
}
- (void)baseConstraintsConfig
{
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(5);
        make.width.height.equalTo(@(46));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview.mas_right).offset(9);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.contentView).offset(5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-50);
        make.height.greaterThanOrEqualTo(@(46));
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)headImageview
{
    if(!_headImageview){
        _headImageview = [[UIImageView alloc]init];
        [_headImageview xwDrawBorderWithColor:[UIColor whiteColor] radiuce:23 width:2];
    }
    return _headImageview;
}

- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_bgView xwDrawCornerWithRadiuce:15];
    }
    return _bgView;
}
- (UILabel *)titleLable
{
    if(!_titleLable){
        _titleLable = [[UILabel alloc]init];
        [_titleLable commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(14) aliment:NSTextAlignmentLeft];
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}

- (void)setMessage:(VESTMessageModel *)message
{
    _message = message;
    self.titleLable.text = message.text;
}

@end
