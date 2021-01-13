//
//  LSConversationCell.m
//  Project
//
//  Created by XuWen on 2020/3/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSConversationCell.h"
#import "LSRongYunHelper.h"
#import <CoreImage/CoreImage.h>

@interface LSConversationCell()
@property (nonatomic,strong) UIImageView *supportImageView; //客服的名字标志
@property (nonatomic,strong) UIView *placeView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *unreadLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *lastMessageLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *matchImageView; //是否匹配的图标
@property (nonatomic,strong) UIImageView *priorImageView; //是否是VIP图标

@end

@implementation LSConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}

#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self commonTableViewCellConfig];
    [self.contentView xwDrawCornerWithRadiuce:0];
    [self.contentView addSubview:self.placeView];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //点击的背景颜色
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = view;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)baseConstriantsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@(90));
        make.top.equalTo(self.contentView);
    }];
}


#pragma mark - setter & getter1
- (UIView *)placeView
{
    if(!_placeView){
        _placeView = [[UIView alloc]init];
        _placeView.backgroundColor = [UIColor projectBlueColor];
        [_placeView xwDrawCornerWithRadiuce:5];
        
        //头像
        self.headImageView = [[UIImageView alloc]init];
        self.headImageView.backgroundColor = [UIColor xwColorWithHexString:@"#4C5971"];
        [self.headImageView xwDrawCornerWithRadiuce:30.0];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_placeView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.placeView);
            make.width.height.equalTo(@60);
            make.left.equalTo(self.placeView).offset(10);
        }];
        
        //unreadLabel
        self.unreadLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(9) aliment:NSTextAlignmentCenter];
        self.unreadLabel.backgroundColor = [UIColor xwColorWithHexString:@"#FF0E93"];
        self.unreadLabel.text = @"20";
        [self.unreadLabel xwDrawBorderWithColor:[UIColor whiteColor] radiuce:8 width:2];
        [_placeView addSubview:self.unreadLabel];
        [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@16);
            make.right.top.equalTo(self.headImageView);
        }];
        
        //是否匹配
        [_placeView addSubview:self.matchImageView];
        [self.matchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@16);
            make.left.top.equalTo(self.headImageView);
        }];
        
        //客服标志
        self.supportImageView = [[UIImageView alloc]initWithImage:XWImageName(@"chat_support")];
        [_placeView addSubview:self.supportImageView];
        [self.supportImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.left.equalTo(self.headImageView.mas_right).offset(10);
            make.top.equalTo(self.headImageView).offset(4);
        }];
        
        //名字
        self.nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentLeft];
        self.nameLabel.text = @"";
        [_placeView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.supportImageView.mas_right).offset(10);
            make.top.equalTo(self.headImageView);
        }];
        
        //prior
        [_placeView addSubview:self.priorImageView];
        [self.priorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(16.5));
            make.width.equalTo(@(48));
            make.centerY.equalTo(self.nameLabel);
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
        }];
        
       //timeLabel
       self.timeLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#BCC1C9"] font:Font(12) aliment:NSTextAlignmentLeft];
       [_placeView addSubview:self.timeLabel];
       [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.nameLabel);
           make.right.equalTo(self.placeView).offset(-15);
       }];
        
        //last message
        self.lastMessageLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor grayColor] font:Font(12) aliment:NSTextAlignmentLeft];
        [_placeView addSubview:self.lastMessageLabel];
        [self.lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.placeView).offset(-21.5);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
    }
    return _placeView;
}

- (void)setModel:(RCConversationModel *)model
{
    [super setModel:model];
    
    //从缓存中获取聊天人的用户信息
//    RCUserInfo *userInfo = [LSRongYunHelper getUserInfoCach:model.targetId];
    
    //额外字段信息
//    NSString *ext = userInfo.extra;
//    NSLog(@"😃😃%@",ext);
    
    // 如果是系统消息，就展示系统名字和头像
    if(model.conversationType == ConversationType_SYSTEM){
        self.nameLabel.text = kLanguage(@"System messages");
        self.headImageView.image = XWImageName(@"head_placeholder");
        self.supportImageView.alpha = 1.0;
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.supportImageView.mas_right).offset(10);
            make.top.equalTo(self.headImageView);
        }];
        self.priorImageView.hidden = YES;
    }else{
        kXWWeakSelf(weakself);
        [[LSRongYunHelper share]getUserWithTargietID:model.targetId complete:^(RCUserInfo * _Nonnull userInfo) {
            weakself.nameLabel.text = userInfo.name;
            //头像
            [weakself.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
            weakself.supportImageView.alpha = 0.0;
            //姓名
            [weakself.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImageView.mas_right).offset(10);
                make.top.equalTo(self.headImageView);
            }];
            
            //获取到extra内容
            //判断是否是VIP
            weakself.priorImageView.hidden = YES;
            if(userInfo.extra){
                NSDictionary *dict = [userInfo.extra josnToDictionary];
                if(dict != nil){
                    if(dict[@"isVIP"]){
                        BOOL isVIP = [dict[@"isVIP"] boolValue];
                        NSLog(@"%d",isVIP);
                        self.priorImageView.hidden = !isVIP;
                    }
                    if(dict[@"sex"]){
                        int sex = [dict[@"sex"] intValue];
                        NSLog(@"%d",sex);
                    }
                }
            }
        }];
    }
    
    //时间
    if(model.lastestMessageDirection == MessageDirection_SEND){
        //最后一条是发送消息
        self.timeLabel.text = [RCKitUtility ConvertMessageTime:(model.sentTime/1000)];
    }else{
        //最后一条是接收消息
        self.timeLabel.text = [RCKitUtility ConvertMessageTime:(model.receivedTime/1000)];
    }
    //最后一条消息摘要
    self.lastMessageLabel.text = [RCKitUtility formatMessage:model.lastestMessage];
    //未读消息
    self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)model.unreadMessageCount];
    self.unreadLabel.hidden = model.unreadMessageCount == 0;
    //是否匹配,展示匹配图标
    self.matchImageView.hidden = ![kUser.matchArray containsObject:model.targetId];
    
}

- (UIImageView *)matchImageView
{
    if(!_matchImageView){
        _matchImageView = [[UIImageView alloc]init];
        _matchImageView.image = XWImageName(@"chat_match-1");
        [_matchImageView xwDrawBorderWithColor:[UIColor whiteColor] radiuce:8 width:2];
    }
    return _matchImageView;
}

- (UIImageView *)priorImageView
{
    if(!_priorImageView){
        _priorImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"prior"))];
    }
    return _priorImageView;
}

@end
