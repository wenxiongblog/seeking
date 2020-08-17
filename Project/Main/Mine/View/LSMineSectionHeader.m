//
//  LSMineSectionHeader.m
//  Project
//
//  Created by XuWen on 2020/6/8.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineSectionHeader.h"

@interface LSMineSectionHeader ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subtitleLabel;

@end

@implementation LSMineSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
    }
    return self;
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@63);
        make.top.equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];
}

- (void)tapClicked{
    if(self.SectionHeaderBlock){
        self.SectionHeaderBlock();
    }
}


#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor xwColorWithHexString:@"#FB3818"];
        [_contentView xwDrawCornerWithRadiuce:15];
        
        self.imageView = [[UIImageView alloc]initWithImage:XWImageName(@"Mine_VIP")];
        [_contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@35);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        self.titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(17) aliment:NSTextAlignmentLeft];
        self.titleLabel.text = kLanguage(@"Get more membership");
        self.subtitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(12) aliment:NSTextAlignmentLeft];
        self.subtitleLabel.text = kLanguage(@"Know more about VIP membership");
        
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.subtitleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(15);
            make.bottom.equalTo(self.imageView.mas_centerY);
        }];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        
        self.rightImageView = [[UIImageView alloc]initWithImage:XWImageName(@"Mine_red_right")];
        [_contentView addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@21);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return _contentView;
}

- (void)setVipSection:(BOOL)vipSection
{
    _vipSection = vipSection;
    if(vipSection){
        self.imageView.image = XWImageName(@"Mine_VIP");
        self.rightImageView.image = XWImageName(@"Mine_red_right");
        self.titleLabel.text = kLanguage(@"Get more membership");
        self.subtitleLabel.text = kLanguage(@"Know more about VIP membership");
    }else{
        self.contentView.backgroundColor = [UIColor xwColorWithHexString:@"#9547CC"];
        self.imageView.image = XWImageName(@"Mine_profile-1");
        self.rightImageView.image = XWImageName(@"Mine_blue_right");
        self.titleLabel.text = kLanguage(@"Profile");
        self.subtitleLabel.text = [NSString stringWithFormat:@"%@:%d%%",kLanguage(@"Progress"),kUser.infoPersent];
    }
}

@end
