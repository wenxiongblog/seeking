//
//  Const.h
//  SCGov
//
//  Created by solehe on 2019/7/8.
//  Copyright © 2019 solehe. All rights reserved.
//

#ifndef Const_h
#define Const_h

//颜色相关
#import "UIColor+LSConst.h"

//融云key
#define kRongYunKey   @"x4vkb1qpxgjhk"

//友盟key
#define kYouMengKey @"5edf4e59dbc2ec083df19d10"

// bugly应用ID
#define TX_BUGLY_KEY    @"46c8bb9f7d"

// 当前应用在AppStore的ID
#define kAPPID          @"1517568074"


/** 用到的数据存储定义 **/
//用户
#define kUser [SEEKING_UserModel share]


/* 用户登录完毕 */
#define kNotification_Login  @"kNotification_Login"
// likes Me数据变化
#define kNotification_LikesMe_add  @"kNotification_LikesMe_add"
// ViewedMe 数据变化
#define kNotification_ViewedMe_changed  @"Notification_ViewedMe_changed"
// I liked 数据变化
#define kNotification_Iliked_changed  @"Notification_Iliked_changed"
// my activity
#define kNotification_MyActivity_changed  @"Notification_MyActivity_changed"
// logouthuifuTab
#define kNotification_Logout_TabChanged @"FirstSelect"
// 购买成功
#define KNotification_PurchaseSuccess  @"Notification_PurchaseSuccess"

//上传照片大于三张了
#define kNOtification_ImageGreateThan3 @"kNOtification_ImageGreateThan3"

//打招呼发送了 刷新会话列表
#define kNotifidation_DazhaHuReloead @"Notifidation_DazhaHuReloead"

// 喜欢我的未读消息
#define kNotification_LikeMe @"Notification_LikeMe"
// 看过我信息的未读消息
#define kNotification_ViewMe @"Notification_ViewMe"

#pragma mark - 系统标记
#define kDefine_isNotificationAsk  @"kDefine_isNotificationAsk"  //是否唤醒过通知
#endif /* Const_h */
