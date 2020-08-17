//
//  LSSignUpChooseCell.m
//  Project
//
//  Created by XuWen on 2020/2/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpChooseCell.h"

@interface LSSignUpChooseCell()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation LSSignUpChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstaintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.contentView xwDrawCornerWithRadiuce:10.0];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)baseConstaintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.backgroundColor = [UIColor placeholderColor];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(24) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Hookup";
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.hidden = YES;
    NSString *name = [NSString stringWithFormat:@"login_%@",title];
    self.bgImageView.image = XWImageName(name);
}

@end
