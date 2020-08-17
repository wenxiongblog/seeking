//
//  LSRongYunHelper.h
//  Project
//
//  Created by XuWen on 2020/2/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSRongYunHelper : NSObject

+ (instancetype)share;
- (void)configRongYun;

/*
    与融云服务器建立连接
    将通过 Server 获取到的 Token，通过 RCIM 的单例，调用下面的方法，即可建立与服务器的连接。
 */
- (void)connectRongYun:(NSString *)token success:(void(^)(BOOL isSuccess,NSString *userId))Success;

/**
    断开与融云服务器的连接，但仍然接收远程推送
 */
+ (void)disConnect;

/**
+   断开与融云服务器的连接，不接收远程推送
*/
+ (void)logout;

/**
  更新未读消息数量
 */
+ (void)notifyUpdateUnreadMessageCount;

/**更新未读的like me 和 viewed Me的系统消息数量*/
//+ (void)notifyUpdateLikesandViewedMeUnreadMessageCount;

/**
 在like中阅读了系统消息
 */
+ (void)readNotificationLikeMe;

//阅读了看过我详情的消息
+ (void)readNotificationViewedMe;

/**
    将用户信息缓存到l聊天系统中，方便获取
 */
+ (RCUserInfo *)ryCashUser:(SEEKING_Customer *)user;
+ (void)ryCashUserArray:(NSArray <SEEKING_Customer *>*)userarray;


//获取用户信息
+ (RCUserInfo *)getUserInfoCach:(NSString *)targetId;
- (void)getUserWithTargietID:(NSString *)targetId complete:(void(^)(RCUserInfo *userInfo))complete;
/**
    更新自己的用户信息
 */
+ (void)uploadMyRongYunUserInfo;

// 给某人打招呼
+ (void)dazhaohu:(SEEKING_Customer *)customer finish:(void(^)(BOOL isFinish))isFinish;

//发送消息
+ (void)matchsendMessage:(NSString *)message customer:(SEEKING_Customer *)customer finish:(void(^)(BOOL isFinish))isFinish;

@end

NS_ASSUME_NONNULL_END
