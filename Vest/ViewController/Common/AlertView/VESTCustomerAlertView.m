//
//  VESTCustomerAlertView.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTCustomerAlertView.h"
#import "LSThreeMsgVC.h"

@interface VESTCustomerAlertView ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *messageButton;

@end

@implementation VESTCustomerAlertView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}
#pragma mark - public
#pragma mark - private
#pragma mark - event
#pragma mark - baseConfig
- (void)baseUIConfig
{
   self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.placeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    tap.delegate = self;
    [self.placeView addGestureRecognizer:tap];
}

- (void)tapClicked
{
    [self disappearAnimation];
}

- (void)baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@320);
        make.height.equalTo(@(390));
        make.center.equalTo(self.placeView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(280);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isDescendantOfView:self.contentView]){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - setter & getter
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:30];
        
        [_contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(@320);
        }];
        
        [_contentView addSubview:self.messageButton];
        [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_test")];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(24) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Linda Luke";
    }
    return _titleLabel;
}

- (UIButton *)messageButton
{
    if(!_messageButton){
        _messageButton = [UIButton creatCommonButtonConfigWithTitle:@"Message" font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _messageButton.backgroundColor = [UIColor xwColorWithHexString:@"#09CBA8"];
        [_messageButton xwDrawCornerWithRadiuce:22];
        kXWWeakSelf(weakself);
        [_messageButton setAction:^{
            [weakself disappearAnimation];
            LSThreeMsgVC *vc = [[LSThreeMsgVC alloc]init];
            vc.userModel = weakself.userModel;
            [weakself.eventVC.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _messageButton;
}

- (void)setUserModel:(VESTUserModel *)userModel
{
    _userModel = userModel;
    self.imageView.image = XWImageName(userModel.headUrl);
    self.titleLabel.text = userModel.name;
}

@end
