//
//  LSCuteManCell.m
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSCuteManCell.h"

@interface LSCuteManCell()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *infoBgImageView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *cameraView;
@property (nonatomic,strong) UIImageView *cameraImageView;
@property (nonatomic,strong) UILabel *countLabel;


@property (nonatomic,strong) UIImageView *onlineImageView;
@property (nonatomic,strong) UIImageView *ne24ImageView;
@property (nonatomic,strong) UIImageView *vipImageView;


@end

@implementation LSCuteManCell

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
    [self.contentView addSubview:self.infoBgImageView];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.cameraView];
    [self.contentView addSubview:self.onlineImageView];
    [self.contentView addSubview:self.ne24ImageView];
    [self.contentView addSubview:self.vipImageView];
}

- (void)baseConstaintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.infoBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgImageView);
        make.height.equalTo(@(XW(150)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-60);
    }];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@28);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
    }];
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(65));
        make.height.equalTo(@27.5);
        make.centerY.equalTo(self.cameraView);
        make.left.equalTo(self.cameraView.mas_right).offset(10);
    }];
    [self.ne24ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(57));
        make.height.equalTo(@27.5);
        make.centerY.equalTo(self.cameraView);
        make.left.equalTo(self.onlineImageView.mas_right).offset(10);
    }];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@27.5);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = XWImageName(@"EliteGirl");
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Martha Rojas, 24";
    }
    return _titleLabel;
}

- (UIImageView *)infoBgImageView
{
    if(!_infoBgImageView){
        _infoBgImageView = [[UIImageView alloc]init];
        _infoBgImageView.image = XWImageName(@"jianbian_middle");
    }
    return _infoBgImageView;
}

- (UIView *)cameraView
{
    if(!_cameraView){
        _cameraView = [[UIView alloc]init];
        [_cameraView xwDrawCornerWithRadiuce:14];
        _cameraView.backgroundColor = [UIColor blackColor];
        
        [_cameraView addSubview:self.cameraImageView];
        [_cameraView addSubview:self.countLabel];
        
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.right.equalTo(self.cameraView).offset(-6);
            make.centerY.equalTo(self.cameraView);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cameraView);
            make.right.equalTo(self.cameraImageView.mas_left).offset(-4);
        }];
    }
    return _cameraView;
}

- (UIImageView *)cameraImageView
{
    if(!_cameraImageView){
        _cameraImageView = [[UIImageView alloc]init];
        _cameraImageView.image = XWImageName(@"相机");
    }
    return _cameraImageView;
}

- (UILabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentRight];
        _countLabel.text = @"5";
    }
    return _countLabel;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    self.titleLabel.text = [NSString stringWithFormat:@"%@,%dyrs",[customer.name filter] ,customer.age];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:customer.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
    NSArray *imageArray = nil;
    if(customer.imageslist.length > 10){
        imageArray = [NSArray arrayWithArray:[customer.imageslist componentsSeparatedByString:@","]];
    }
    long count = imageArray.count + (customer.images.length == 0?0:1);
    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
    if([customer.name containsString:@"06"]){
        NSLog(@"%@",customer.address);
    }
    //城市和距离
    NSMutableString *subTitle = [NSMutableString string];
    if(customer.address.length > 0){
        [subTitle appendString:customer.address];
    }
    
    //是否在线
    if(!customer.isOnline){
        self.onlineImageView.hidden = NO;
        NSLog(@"%@",customer.creattime);
        NSDate *creatTimedate = [NSDate dateWithString:customer.creattime];
        //是否是新用户
        if([NSDate judgeisNews24HoursDate:creatTimedate]){
            self.ne24ImageView.hidden = NO;
            [self.ne24ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.onlineImageView.mas_right).offset(10);
            }];
        }else{
            self.ne24ImageView.hidden = YES;
        }
    }else{
        self.onlineImageView.hidden = YES;
        //是否是新用户
         NSDate *creatTimedate = [NSDate dateWithString:customer.creattime];
        if([NSDate judgeisNews24HoursDate:creatTimedate]){
            self.ne24ImageView.hidden = NO;
            [self.ne24ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cameraView.mas_right).offset(10);
            }];
        }else{
            self.ne24ImageView.hidden = YES;
        }
    }
    self.vipImageView.hidden = !customer.isVIPCustomer;
}

- (UIImageView *)onlineImageView
{
    if(!_onlineImageView){
        _onlineImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"match_Online"))];
    }
    return _onlineImageView;
}

- (UIImageView *)ne24ImageView
{
    if(!_ne24ImageView){
        _ne24ImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"match_new"))];
    }
    return _ne24ImageView;
}
- (UIImageView *)vipImageView
{
    if(!_vipImageView){
        _vipImageView = [[UIImageView alloc]initWithImage:XWImageName(@"huangguan")];
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}
@end
