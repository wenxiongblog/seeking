//
//  LSMineProfileChooseCell.m
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineProfileChooseCell.h"

@interface LSMineProfileChooseCell()
@property (nonatomic,strong) UILabel *titleLable;
@end

@implementation LSMineProfileChooseCell

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
    [self.contentView addSubview:self.titleLable];
    [self.contentView xwDrawCornerWithRadiuce:5];
    self.contentView.backgroundColor = [UIColor themeColor];
}
- (void)SEEKING_baseConstraintsConfig
{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - setter & getter1
- (UILabel *)titleLable
{
    if(!_titleLable){
        _titleLable = [[UILabel alloc]init];
        [_titleLable commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentCenter];
        _titleLable.backgroundColor = [UIColor themeColor];
        _titleLable.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLable;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLable.text = kLanguage(title);
}

- (void)setIsChoosed:(BOOL)isChoosed
{
    _isChoosed  = isChoosed;
    if(isChoosed){
        [self.titleLable commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentCenter];
        self.titleLable.backgroundColor = [UIColor themeColor];
    }else{
        [self.titleLable commonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
        self.titleLable.backgroundColor = [UIColor themeColor];
    }
}

@end
