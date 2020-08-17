//
//  LSDetailCell.m
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDetailCell.h"

@interface LSDetailCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong)UIView *tagsView;
@end

@implementation LSDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstraintConfig];
    }
    return self;
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self commonTableViewCellConfig];
    self.contentView.backgroundColor = [UIColor projectBackGroudColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.tagsView];
}

- (void)baseConstraintConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - private
- (void)updateTags {
    
    // 移除之前的
    for (UIButton *button in self.tagsView.subviews) {
        [button removeFromSuperview];
    }
    
    // 添加新的
    NSInteger row = 0; //第几行
    CGFloat width = 0.f; //当前行累计宽度
    UIFont *font = FontMediun(18);
    for (int i=0; i<self.tags.count; i++) {
        UIButton *button = [self buttonWithTitle:self.tags[i] font:font];
        [self.tagsView addSubview:button];
        
        CGFloat w = [self.tags[i] sizeWithAttributes:@{NSFontAttributeName : font}].width;
        if (width + w + 20 > W(self.tagsView)) {
            width = 0.f;  row += 1;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w + 20);
            make.left.mas_equalTo(width);
            make.top.mas_equalTo(40 * row);
            make.height.mas_equalTo(30);
            if (i >= self.tags.count-1) {
                make.bottom.mas_equalTo(0);
            }
            if (width + (w + 10.f + 20.f) > kSCREEN_WIDTH-40.f) {
                make.right.mas_equalTo(-20);
            }
        }];
        width += (w + 10.f + 20.f);
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor xwColorWithHexString:@"#2E2A5D"]];
    [button.titleLabel setFont:font];
    [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor xwRandomDarkLightColor] forState:UIControlStateNormal];
    [button xwDrawCornerWithRadiuce:5];
    if([_titleLabel.text isEqualToString:@"Looking for"]){
        [button setBackgroundColor:[UIColor xwRandomDarkColor]];
         [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return button;
}



#pragma mark - setter & getter1
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#A7A6B6"] font:FontMediun(18) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"ABOUT";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(18) aliment:NSTextAlignmentLeft];
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UIView *)tagsView
{
    if(!_tagsView){
        _tagsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-40, 30)];
    }
    return _tagsView;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.titleLabel.text = name;
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    self.subTitleLabel.text = _detail;
}

- (void)setTags:(NSArray<NSString *> *)tags
{
    _tags = tags;
    // 更新数据
    [self updateTags];
}

@end
