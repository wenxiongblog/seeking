//
//  LSMessageBannerView.m
//  Project
//
//  Created by XuWen on 2020/3/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMessageBannerView.h"
#import "LSRYChatViewController.h"

@interface LSMessageBannerView ()
@property (nonatomic,strong) UIImageView *headImageview;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) RCMessage * message;
@end

@implementation LSMessageBannerView

+ (instancetype)createWithMessage:(RCMessage *)message
{
    LSMessageBannerView *bannerView = [[LSMessageBannerView alloc]initWithFrame:CGRectMake(XW(20), kStatusBarHeight+YH(25), kSCREEN_WIDTH-XW(40), 88.5)];
    bannerView.message = message;
    return  bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self xwDrawCornerWithRadiuce:5];
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}

#pragma mark - event
- (void)tapButtonClicked:(UIButton *)sender
{
    //点击进入消息界面
    LSRYChatViewController *chatVC = [[LSRYChatViewController alloc]initWithSystemInfo:self.message.conversationType == ConversationType_SYSTEM];
    chatVC.conversationType = self.message.conversationType;
    chatVC.targetId = self.message.targetId;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.getCurrentVC.navigationController pushViewController:chatVC animated:YES];
    sender.userInteractionEnabled = NO;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{   
    [self addSubview:self.headImageview];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.tapbutton];
}

- (void)baseConstriantsConfig
{
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview.mas_right).offset(10);
        make.top.equalTo(self.headImageview);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(-21.5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(-15);
    }];
    [self.tapbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - setter &getter
- (UIImageView *)headImageview
{
    if(!_headImageview){
        _headImageview = [[UIImageView alloc]init];
        [_headImageview xwDrawBorderWithColor:[UIColor whiteColor] radiuce:30 width:2];
        _headImageview.backgroundColor = [UIColor xwColorWithHexString:@"#4C5971"];
        _headImageview.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageview;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel
{
    if(!_messageLabel){
        _messageLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#4C5971"] font:Font(12) aliment:NSTextAlignmentLeft];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#BCC1C9"] font:Font(12) aliment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (void)setMessage:(RCMessage *)message
{
    _message = message;
    if(message.conversationType == ConversationType_SYSTEM){
        self.nameLabel.text =  @"NUMB Support";
        self.messageLabel.text = [RCKitUtility formatMessage:message.content];
        self.headImageview.image = XWImageName(@"head_placeholder");
        self.timeLabel.text = [RCKitUtility ConvertMessageTime:(message.sentTime/1000)];
    }else{
        self.messageLabel.text = [RCKitUtility formatMessage:message.content];
        self.nameLabel.text =  message.content.senderUserInfo.name;
        [self.headImageview sd_setImageWithURL:[NSURL URLWithString:message.content.senderUserInfo.portraitUri] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
        self.timeLabel.text = [RCKitUtility ConvertMessageTime:(message.sentTime/1000)];;
    }
}

- (UIButton *)tapbutton
{
    if(!_tapbutton){
        _tapbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapbutton.backgroundColor = [UIColor clearColor];
        [_tapbutton addTarget:self action:@selector(tapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapbutton;
}

@end
