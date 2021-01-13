//
//  LSRongYunHelper.m
//  Project
//
//  Created by XuWen on 2020/2/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSRongYunHelper.h"
#import <EBCustomBannerView.h>
#import "LSMessageBannerView.h"
#import "LSRYChatViewController.h"
#import "LSConversationVC.h"
#import "LSSayHiAlertView.h"
#import "LSSignUpBaseVC.h"
#import "LSMatchVC.h"
#import "LSRYUserInfo.h"
#import "NSObject+LSCommonRequest.h"

@interface LSRongYunHelper()<RCIMUserInfoDataSource,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

@end

@implementation LSRongYunHelper

 static LSRongYunHelper *__singletion;

 + (instancetype)share {
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         if (__singletion == nil) {
             __singletion = [[self alloc] init];
         }
     });
     return __singletion;
 }

#pragma mark - public
/**
    配置融云
 */
- (void)configRongYun
{
    //融云初始化
    [[RCIM sharedRCIM] initWithAppKey:kRongYunKey];
    //头像、昵称等用户信息，用户信息提供者，通过代理获取
    [[RCIM sharedRCIM]setUserInfoDataSource:self];
     // IMKit连接状态的监听器
    [RCIM sharedRCIM].connectionStatusDelegate = self;
     // 设置发送消息时消息体中携带用户信息。 property(nonatomic, strong) RCUserInfo *senderUserInfo;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    // 设置接受消息的监听
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    // 设置当前融云头像和昵称
    [LSRongYunHelper uploadMyRongYunUserInfo];
    //聊天界面的头像是圆形
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(0, 0);

    //***这里尝试连接一次,以后每次进入程序只要kUser.toker不为空就会建立连接了。
    [self connectRongYun:kUser.token success:^(BOOL isSuccess, NSString * _Nonnull userId) {
        if(isSuccess){
            kUser.isLogin = YES;
            NSLog(@"%@,%@",kUser.id,userId);
            //进来的时候 未读消息数量显示
            [LSRongYunHelper notifyUpdateUnreadMessageCount];
        }
    }];
}

/**接受更新未读消息数量*/
+ (void)notifyUpdateUnreadMessageCount
{
//    kXWWeakSelf(weakself);
    dispatch_async(dispatch_get_main_queue(), ^{
            int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_SYSTEM)]];
            NSString *countStr = [NSString stringWithFormat:@"%d",count];
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"unreadMessageCount" object:nil userInfo:@{@"unreadcount":countStr}]];
            //图标上未读标志
            UIApplication *application = [UIApplication sharedApplication];
            [application setApplicationIconBadgeNumber:count];
        });
    [self notifyUpdateLikesandViewedMeUnreadMessageCount];
}

/**更新未读的like me 和 viewed Me的系统消息数量*/
+ (void)notifyUpdateLikesandViewedMeUnreadMessageCount
{
    //获取到系统会话
    NSArray <RCConversation *>*conversationArray = [[RCIMClient sharedRCIMClient]getConversationList:@[@(ConversationType_SYSTEM)]];
    if(conversationArray.count > 0){
        //在会话中找到未读消息
        RCConversation *convensation = conversationArray.firstObject;
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_SYSTEM)]];
        NSArray <RCMessage *>*messageArray = [[RCIMClient sharedRCIMClient]getLatestMessages:ConversationType_SYSTEM targetId:convensation.targetId count:count];
        int likemeCount = 0;
        int viewmeCount = 0;
        for(RCMessage *message in messageArray){
            //喜欢我的未读消息
            if([[RCKitUtility formatMessage:message.content] containsString:@"personal assistant"]){
                continue;
            }
            
            if([[RCKitUtility formatMessage:message.content] containsString:@"liked you"] && message.receivedStatus == ReceivedStatus_UNREAD){
                likemeCount = likemeCount + 1;
            }
            //见过我的未读消息
            if([[RCKitUtility formatMessage:message.content] containsString:@"viewed your"] && message.receivedStatus == ReceivedStatus_UNREAD){
                viewmeCount = viewmeCount + 1;
            }
        }
        
        NSLog(@"%@",messageArray);
        NSLog(@"😄%d",likemeCount);
        NSLog(@"👀%d",viewmeCount);
        NSString *countStr = [NSString stringWithFormat:@"%d",likemeCount+viewmeCount];
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"unreadLikedViewedMessageCount" object:nil userInfo:@{@"unreadcount":countStr}]];
        //喜欢我的
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kNotification_LikeMe object:nil userInfo:@{@"unreadcount":@(likemeCount)}]];
        //看过我的
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kNotification_ViewMe object:nil userInfo:@{@"unreadcount":@(viewmeCount)}]];
    }
    //拿到viewedMe 消息
    //拿到 likesMe 消息
}

/**
 在like中阅读了系统消息
 */
+ (void)readNotificationLikeMe
{
    //获取到系统会话
       NSArray <RCConversation *>*conversationArray = [[RCIMClient sharedRCIMClient]getConversationList:@[@(ConversationType_SYSTEM)]];
       if(conversationArray.count > 0){
           //在会话中找到未读消息
           RCConversation *convensation = conversationArray.firstObject;
           int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_SYSTEM)]];
           NSArray <RCMessage *>*messageArray = [[RCIMClient sharedRCIMClient]getLatestMessages:ConversationType_SYSTEM targetId:convensation.targetId count:count];
           
           for(RCMessage *message in messageArray){
               //喜欢我的未读消息
               if([[RCKitUtility formatMessage:message.content] containsString:@"liked you"] && message.receivedStatus == ReceivedStatus_UNREAD){
                   
                   //标记为已读
                   [[RCIMClient sharedRCIMClient]setMessageReceivedStatus:message.messageId receivedStatus:ReceivedStatus_READ];
                   
               }
              
           }
           //刷新已读
           [self notifyUpdateUnreadMessageCount];
       }
}

//阅读了看过我详情的消息
+ (void)readNotificationViewedMe
{
    //获取到系统会话
    NSArray <RCConversation *>*conversationArray = [[RCIMClient sharedRCIMClient]getConversationList:@[@(ConversationType_SYSTEM)]];
    if(conversationArray.count > 0){
        //在会话中找到未读消息
        RCConversation *convensation = conversationArray.firstObject;
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_SYSTEM)]];
        NSArray <RCMessage *>*messageArray = [[RCIMClient sharedRCIMClient]getLatestMessages:ConversationType_SYSTEM targetId:convensation.targetId count:count];
        for(RCMessage *message in messageArray){
            
            //见过我的未读消息
            if([[RCKitUtility formatMessage:message.content] containsString:@"viewed your"] && message.receivedStatus == ReceivedStatus_UNREAD){
                //标记为已读
                [[RCIMClient sharedRCIMClient]setMessageReceivedStatus:message.messageId receivedStatus:ReceivedStatus_READ];
            }
        }
        //刷新已读
        [self notifyUpdateUnreadMessageCount];
    }
}

/**
    断开与融云服务器的连接，但仍然接收远程推送
 */
+ (void)disConnect
{
    [[RCIM sharedRCIM]disconnect];
}

/**
   断开与融云服务器的连接，不接收远程推送
*/
+ (void)logout
{
    [[RCIM sharedRCIM]logout];
}

/*
    与融云服务器建立连接
    将通过 Server 获取到的 Token，通过 RCIM 的单例，调用下面的方法，即可建立与服务器的连接。
 */
- (void)connectRongYun:(NSString *)token success:(void(^)(BOOL isSuccess,NSString *userId))Success
{
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:kUser.conversationId name:kUser.name portrait:kUser.images];
    [RCIM sharedRCIM].currentUserInfo.extra = kUser.rongYunExtra;

    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NSLog(@"%@",[NSThread currentThread]);
        //回到主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            Success(YES,userId);
        });
    } error:^(RCConnectErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Success(NO,@"");
        });
    } tokenIncorrect:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [AlertView toast:@"Token incorrect" inView:[self getCurrentVC].view];
            Success(NO,@"");
        });
    }];
}

+ (RCUserInfo *)getUserInfoCach:(NSString *)targetId
{
    RCUserInfo *userInfo = [[RCIM sharedRCIM]getUserInfoCache:targetId];
    if(userInfo == nil){
        userInfo = [LSRYUserInfo userInfoWithKey:targetId];
    }
    return userInfo;
}

- (void)getUserWithTargietID:(NSString *)targetId complete:(void(^)(RCUserInfo *userInfo))complete
{
    RCUserInfo *userInfo = [[RCIM sharedRCIM]getUserInfoCache:targetId];
    //1.缓存中去找
    if(userInfo != nil){
        //缓存中找到
        complete(userInfo);
        return;
    }else{
        //2.数据库中去找
        userInfo = [LSRYUserInfo userInfoWithKey:targetId];
        if(userInfo != nil){
            //数据库中找到
            complete(userInfo);
            return;
        }else{
            //进行网络请求，请求后要做缓存和文件存储。
            NSString *userID = [targetId componentsSeparatedByString:@"_"].lastObject;
            if(userID.length > 0){
                [self postUserWithID:userID complete:^(SEEKING_Customer * _Nonnull customer) {
                    //做缓存 如果是空的话写一个空置
                    if(customer == nil){
                        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:targetId name:@" " portrait:@""];
                        [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:targetId];
                        complete(userInfo);
                    }else{
                        RCUserInfo *userInfo = [LSRongYunHelper ryCashUser:customer];
                        complete(userInfo);
                    }
                    return;
                }];
            }else{
                complete(nil);
            }
            
            
        }
    }
    
}


// 缓存单个用户的头像和用户信息到本地
+ (RCUserInfo *)ryCashUser:(SEEKING_Customer *)user
{
    //缓存用户单个信息
    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:user.conversationId name:user.name portrait:user.images];
    userInfo.extra = user.rongYunExtra;
    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:user.conversationId];
    
    //存用户信息到本地的数据库中
    LSRYUserInfo *bendiUserInfo = [[LSRYUserInfo alloc]initWithUserInfo:userInfo];
    [LSRYUserInfo addOrUpdate:bendiUserInfo];
    
//    RLMResults *reuslt = [LSRYUserInfo allObjects];
//    NSLog(@"%@",reuslt);
    
    return userInfo;
}

// 缓存用户组的头像和用户信息到本地
+ (void)ryCashUserArray:(NSArray <SEEKING_Customer *>*)userarray
{
    for(SEEKING_Customer *user in userarray){
        [self ryCashUser:user];
    }
}

//上传我的融云的头像和用用户信息
+ (void)uploadMyRongYunUserInfo
{
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:kUser.conversationId name:kUser.name portrait:kUser.images];
    [RCIM sharedRCIM].currentUserInfo.extra = kUser.rongYunExtra;
}

+ (void)dazhaohu:(SEEKING_Customer *)customer finish:(void(^)(BOOL isFinish))isFinish
{
    RCTextMessage *ms = [RCTextMessage messageWithContent:[LSSayHiAlertView zhaohuYuju]];
    ms.senderUserInfo = [[RCUserInfo alloc]initWithUserId:customer.conversationId name:[customer.name filter] portrait:customer.images];
    ms.senderUserInfo.extra = [kUser rongYunExtraWithZhaoHu];
    
    NSString *pushContent = [NSString stringWithFormat:@"%@:%@",ms.senderUserInfo.name,ms.content];
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:customer.conversationId content:ms pushContent:pushContent pushData:nil success:nil error:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //去手动刷新列表
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotifidation_DazhaHuReloead object:nil];
        isFinish(YES);
    });
}

+ (void) matchsendMessage:(NSString *)message customer:(SEEKING_Customer *)customer finish:(void(^)(BOOL isFinish))isFinish
{
    RCTextMessage *ms = [RCTextMessage messageWithContent:message];
    NSString *pushContent = [NSString stringWithFormat:@"%@:%@",customer.name,message];
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:customer.conversationId content:ms pushContent:pushContent pushData:nil success:nil error:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isFinish(YES);
    });
}


#pragma mark - RCIMSendMessageDelegate


#pragma mark - RCIMReceiveMessageDelegate
/**
 这里需要做
 1.更新未读消息
 2.前台消息弹窗
 3.判断系统消息是否是 喜欢我的和 看过我的 然后通知刷新数据
 */

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //0.更新未读消息
        [LSRongYunHelper notifyUpdateUnreadMessageCount];
        
        //1.接受消息代理，做前台消息推送
        //缓存发送者信息
        [[RCIM sharedRCIM]refreshUserInfoCache:message.content.senderUserInfo withUserId:message.content.senderUserInfo.userId];
        
        // 如果当前是聊天界面，并且会话的就是此人，那么久不做前台消息弹窗了。
        if([self.getCurrentVC isKindOfClass:[RCConversationViewController class]]){
            RCConversationViewController *vc = (RCConversationViewController *)self.getCurrentVC;
            if([vc.targetId isEqualToString:message.targetId]){
                return ;
            }else{
                
            }
        }
        
        //进行前台消息弹出
        LSMessageBannerView *alert = [LSMessageBannerView createWithMessage:message];
        EBCustomBannerView *banner = [EBCustomBannerView customView:alert block:^(EBCustomBannerViewMaker *make) {
            if([[self getCurrentVC] isKindOfClass:[LSMatchVC class]]){
                make.stayDuration = 3.0;
            }else{
                make.stayDuration = 2.0;
            }
        }];
        [banner show];
        
        //2.判断消息类型，如果是系统消息 喜欢我 和 看过我 刷新数据
        if([[RCKitUtility formatMessage:message.content] containsString:@"liked you"] && message.conversationType == ConversationType_SYSTEM){
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_LikesMe_add object:nil];
        }
        
        if([[RCKitUtility formatMessage:message.content] containsString:@"viewed your"] && message.conversationType == ConversationType_SYSTEM){
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_ViewedMe_changed object:nil];
        }
        
    });
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    NSLog(@"代理实现");
}

#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    switch (status) {
        case ConnectionStatus_Connected:
        {
            //连接成功
        }
        break;
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:
        {
            //当前用户在其他设备上登录，此设备被踢下线
            kUser.isLogin = NO;
            [AlertView toast:@"KICKED OFFLINE BY OTHER CLIENT" inView:[self getCurrentVC].view];
        }
        break;
        case ConnectionStatus_Unconnected:
        {
            //连接失败或未连接
        }
        break;
        case ConnectionStatus_SignUp:
        {
            //已注销
        }
        break;
            
        default:
            break;
    }
//    if(status == ConnectionStatus_Connected){
//        //连接成功
//    }
//
//    if(status == ConnectionStatus_NETWORK_UNAVAILABLE){
//        //网络不可用
//    }
//
//    if(status == )
//
//
//
//    if(status ==ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
//
//    }
}

@end
