//
//  LSMessageMatchCell.m
//  Project
//
//  Created by XuWen on 2020/3/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMessageMatchCell.h"

@interface LSMessageMatchCell()
@property (nonatomic,strong) UIImageView *headImageView;
@end

@implementation LSMessageMatchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstrainsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView xwDrawCornerWithRadiuce:30];
}

- (void)baseConstrainsConfig
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:customer.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
    
}
@end
