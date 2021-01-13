//
//  VESTChargeCell.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTChargeCell.h"

@interface  VESTChargeCell()

@property (nonatomic,strong) UIView *moneyView;
@property (nonatomic,strong) UIImageView *coinImageView;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@end

@implementation VESTChargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    [self commonTableViewCellConfig];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.moneyView];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - setter & getter
- (UIView *)moneyView
{
    if(!_moneyView){
        _moneyView = [[UIView alloc]init];
        _moneyView.backgroundColor = [UIColor whiteColor];
        [_moneyView xwDrawCornerWithRadiuce:10];
        
        [_moneyView addSubview:self.coinImageView];
        [_moneyView addSubview:self.countLabel];
        [_moneyView addSubview:self.moneyLabel];
        [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@23);
            make.height.equalTo(@32);
            make.centerY.equalTo(self.moneyView);
            make.left.equalTo(self.moneyView).offset(16);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coinImageView.mas_right).offset(13);
            make.centerY.equalTo(self.coinImageView);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.coinImageView);
            make.right.equalTo(self.moneyView).offset(-15);
        }];
    }
    return _moneyView;
}

- (UIImageView *)coinImageView
{
    if(!_coinImageView){
        _coinImageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_coins")];
    }
    return _coinImageView;
}

- (UILabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#171351"] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _countLabel.text = @"200";
    }
    return _countLabel;
}

- (UILabel *)moneyLabel
{
    if(!_moneyLabel){
        _moneyLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#171351"] font:FontBold(18) aliment:NSTextAlignmentRight];
        _moneyLabel.text = @"$4.99";
    }
    return _moneyLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.countLabel.text = title;
    NSInteger count = [title integerValue];
    switch (count) {
            case 60:
            self.moneyLabel.text = @"$0.99";
            break;
            case 300:
            self.moneyLabel.text = @"$4.99";
            break;
            case 600:
            self.moneyLabel.text = @"$9.99";
            break;
            case 1500:
            self.moneyLabel.text = @"$19.99";
            break;
            case 3000:
            self.moneyLabel.text = @"$39.99";
            break;
            case 7000:
            self.moneyLabel.text = @"$59.99";
            break;
            
        default:
            break;
    }
}
@end
