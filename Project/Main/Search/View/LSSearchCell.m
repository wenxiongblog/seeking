//
//  LSSearchCell.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSearchCell.h"

@interface LSSearchCell()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *infoBgImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UIImageView *cameraImageView;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIImageView *vipImageView;

@property (nonatomic,strong) UIImageView *newImageView;
@end

@implementation LSSearchCell

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
    [self.contentView xwDrawCornerWithRadiuce:5.0];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.infoBgImageView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.cameraImageView];
    [self.contentView addSubview:self.vipImageView];
    
    [self.contentView addSubview:self.newImageView];
}

- (void)baseConstaintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.infoBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgImageView);
        make.height.equalTo(@(XW(75)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.subTitleLabel.mas_top).offset(-5);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.right.equalTo(self.countLabel.mas_left).offset(-3);
        make.centerY.equalTo(self.countLabel);
    }];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14.5);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];
    
    [self.newImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.center.equalTo(self.titleLabel);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
//        _bgImageView.image = XWImageName(@"test");
//        _bgImageView.backgroundColor = [UIColor placeholderColor];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(12) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Martha Rojas, 24";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(8) aliment:NSTextAlignmentLeft];
        _subTitleLabel.text = @"New York，Distance：10.5km";
    }
    return _subTitleLabel;
}

- (UIImageView *)infoBgImageView
{
    if(!_infoBgImageView){
        _infoBgImageView = [[UIImageView alloc]init];
        _infoBgImageView.image = XWImageName(@"jianbian_middle");
    }
    return _infoBgImageView;
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
    self.subTitleLabel.text = subTitle;
    self.vipImageView.hidden = !customer.isVIPCustomer;
    
//    self.newImageView.hidden = customer.isOnline;
}

- (void)setShowDistance:(BOOL)showDistance
{
    _showDistance = showDistance;
    self.subTitleLabel.hidden = !showDistance;
}
    
- (UIImageView *)vipImageView
{
    if(!_vipImageView){
        _vipImageView = [[UIImageView alloc]initWithImage:XWImageName(@"huangguan")];
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}

- (UIImageView *)newImageView
{
    if(!_newImageView){
        _newImageView = [[UIImageView alloc]init];
        _newImageView.backgroundColor = [UIColor yellowColor];
        _newImageView.hidden = YES;
    }
    return _newImageView;
}

@end
