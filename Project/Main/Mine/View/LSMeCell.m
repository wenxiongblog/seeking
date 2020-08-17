//
//  LSMeCell.m
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMeCell.h"
#define angleValue(angle) ((angle) * M_PI / 180.0)

@interface LSMeCell()
@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,strong) UIView *jumpView;
@property (nonatomic,strong) UILabel *persentLabel;

@property (nonatomic,strong) UIImageView *redPodView;

@end

@implementation LSMeCell

 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConifg];
        [self baseConstriantsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)baseUIConifg
{
    [self commonTableViewCellConfig];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor projectBlueColor];
    [self.contentView addSubview:self.titleImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.jumpView];
    [self.contentView addSubview:self.redPodView];
//    [self.contentView showBottomLineWithXSpace:65 andColor:[UIColor xwColorWithHexString:@"#E3E3E3"]];
}

- (void)baseConstriantsConfig
{
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(self.contentView).offset(25);
        make.centerY.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [self.jumpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@52);
        make.height.equalTo(@26);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.leftImageView);
    }];
    [self.redPodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.top.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(6);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)titleImageView
{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]init];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.titleLabel.text = kLanguage(name);
    NSString *strimg = [NSString stringWithFormat:@"Mine_%@",name];
    self.titleImageView.image = XWImageName(strimg);
    
    if([name isEqualToString:@"My features"] && kUser.isVIP == NO){
        self.redPodView.hidden = NO;
    }else{
        self.redPodView.hidden = YES;
    }
}

- (UIImageView *)leftImageView
{
    if(!_leftImageView){
        _leftImageView = [[UIImageView alloc]initWithImage:XWImageName(@"向右1")];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIView *)jumpView
{
    if(!_jumpView){
        _jumpView = [[UIView alloc]init];
        _jumpView.backgroundColor = [UIColor themeColor];
        [_jumpView xwDrawCornerWithRadiuce:5];
        
        self.persentLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
        self.persentLabel.text = @"0%";
        
        [_jumpView addSubview:self.persentLabel];
        [self.persentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_jumpView);
        }];
    }
    return _jumpView;
}


- (void)setIsJump:(BOOL)isJump
{
    _isJump = isJump;
    if(isJump){
        CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
        anima.keyPath = @"transform.rotation";
        anima.values = @[@(angleValue(-5)),@(angleValue(5)),@(angleValue(-5))];
        anima.repeatCount = MAXFLOAT;
        [self.jumpView.layer addAnimation:anima forKey:nil];
    }else{
        [self.jumpView.layer removeAllAnimations];
    }
}

- (void)setIsPersent:(BOOL)isPersent
{
    _isPersent = isPersent;
    self.jumpView.hidden = !isPersent;
}

- (void)setPersent:(CGFloat)persent
{
    _persent = persent;
    self.isJump = (persent == 0);
    self.persentLabel.text = [NSString stringWithFormat:@"%.0f%%",persent];
}


- (void)setIsTop:(BOOL)isTop
{
    _isTop = isTop;
    if(isTop){
        [self.contentView xwDrawbyRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadiuce:10];
    }else{
        [self.contentView xwDrawCornerWithRadiuce:0];
    }
}

- (void)setIsBottom:(BOOL)isBottom
{
    _isBottom = isBottom;
    if(isBottom){
        [self.contentView xwDrawbyRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft withRadiuce:10];
    }else{
        [self.contentView xwDrawCornerWithRadiuce:0];
    }
}

- (UIImageView *)redPodView
{
    if(!_redPodView){
        _redPodView = [[UIImageView alloc]init];
        _redPodView.backgroundColor = [UIColor redColor];
        [_redPodView xwDrawCornerWithRadiuce:3];
    }
    return _redPodView;
}
@end
