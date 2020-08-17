//
//  LSMatchLikeView.m
//  Project
//
//  Created by XuWen on 2020/4/15.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMatchLikeView.h"

@interface LSMatchLikeView()
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView0;
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;
@end

@implementation LSMatchLikeView


-  (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.placeView addSubview:self.contentView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@335);
        make.height.equalTo(@426);
        make.center.equalTo(self);
    }];
}


#pragma mark - setter & gette
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:10];
        
        //添加渐变色
        CGRect frame = CGRectMake(0, 0, 335, 426);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = frame;
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.colors = @[(__bridge id)[UIColor xwColorWithHexString:@"#FF0098"].CGColor,(__bridge id)[UIColor xwColorWithHexString:@"#FF8E66"].CGColor];
        gradientLayer.locations = @[@(0.0),@(1.0)];
        [_contentView.layer addSublayer:gradientLayer];
        
        
        //title
        UILabel *titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(36) aliment:NSTextAlignmentCenter];
        titleLabel.text = @"You May Like";
        [_contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(13);
        }];
        
        //ImageView
        self.imageView0 = [self createImageView];
        self.imageView1 = [self createImageView];
        self.imageView2 = [self createImageView];
        self.imageView3 = [self createImageView];
        [_contentView addSubview:self.imageView0];
        [_contentView addSubview:self.imageView1];
        [_contentView addSubview:self.imageView2];
        [_contentView addSubview:self.imageView3];
        [self.imageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@100);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_centerX).offset(-10);
        }];
        [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.imageView0);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_centerX).offset(10);
        }];
        [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.imageView0);
            make.top.equalTo(self.imageView0.mas_bottom).offset(10);
            make.left.equalTo(self.imageView0);
        }];
        [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.imageView0);
            make.top.equalTo(self.imageView2);
            make.right.equalTo(self.imageView1);
        }];
        
        //button
        UIButton *messageButton = [UIButton creatCommonButtonConfigWithTitle:@"Like theme" font:FontBold(18) titleColor:[UIColor xwColorWithHexString:@"#FF268A"] aliment:UIControlContentHorizontalAlignmentCenter];
        messageButton.backgroundColor = [UIColor whiteColor];
        [messageButton xwDrawCornerWithRadiuce:25];
        [self.contentView addSubview:messageButton];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.equalTo(@(271));
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_bottom).offset(-140);
        }];
        kXWWeakSelf(weakself);
        [messageButton setAction:^{
            [weakself disappearAnimation];
            
//            LSRYChatViewController *chatVC = [[LSRYChatViewController alloc]init];
//            chatVC.conversationType = ConversationType_PRIVATE;
//            chatVC.targetId = weakself.customer.conversationId;
//            chatVC.title = [weakself.customer.name filter];
//            chatVC.hidesBottomBarWhenPushed = YES;
//            [[weakself getCurrentVC].navigationController pushViewController:chatVC animated:YES];
            
        }];
        
        UIButton *playButton = [UIButton creatCommonButtonConfigWithTitle:@"Keep playing" font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [playButton xwDrawCornerWithRadiuce:25];
        [self.contentView addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.equalTo(@(271));
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(messageButton.mas_bottom).offset(4);
        }];
        [playButton setAction:^{
            [weakself disappearAnimation];
        }];
        
    }
    return _contentView;
}

//- (UIImageView *)taImageView
//{
//    if(!_taImageView){
//        _taImageView = [[UIImageView alloc]init];
//        _taImageView.backgroundColor = [UIColor placeholderColor];
//        _taImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_taImageView xwDrawBorderWithColor:[UIColor whiteColor] radiuce:67 width:2];    }
//    return _taImageView;
//}

- (UIImageView *)createImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor placeholderColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView xwDrawBorderWithColor:[UIColor whiteColor] radiuce:50 width:2];
    return imageView;
}


//- (void)setCustomer:(SEEKING_Customer *)customer
//{
//    _customer = customer;
//    [self.taImageView sd_setImageWithURL:[NSURL URLWithString:customer.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
//}


@end
