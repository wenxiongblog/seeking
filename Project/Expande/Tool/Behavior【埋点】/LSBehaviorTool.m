//
//  LSBehaviorTool.m
//  Project
//
//  Created by XuWen on 2020/3/17.
//  Copyright © 2020 xuwen. All rights reserved.
//
            
#import "LSBehaviorTool.h"
#import <Aspects/Aspects.h>
#import <UMAnalytics/MobClick.h>

@implementation LSBehaviorTool

+(void)Aspect
{
    //注册登录模块
    [self aspectLogin];
    //通知
    [self notification];
    //购买流程
    [self purchaseBehavior];
    //操作流程
    [self handleBehavior];
    //profile
    [self profileBehavior];
    //cute
    [self cute];
    //say Hi
    [self sayHi];
}

//打招呼
+ (void)sayHi
{
    [LSBehaviorTool AspectwithClassName:@"LSSearchSayHiCell" methodName:@"MDSayHi_search" keyWord:@"sayHi_search"];
    [LSBehaviorTool AspectwithClassName:@"LSConversationVC" methodName:@"MDSayHi_message" keyWord:@"sayHi_message"];
    
    //女进入到say hi 页面
    [LSBehaviorTool AspectwithClassName:@"LSSayHiAlertView" methodName:@"MDSayHi" keyWord:@"say_hi"];
    //女性使用 say hi 功能
    [LSBehaviorTool AspectwithClassName:@"LSSayHiAlertView" methodName:@"MDSayHiOK" keyWord:@"say_hi_ok"];
    //女性关闭say hi 功能
    [LSBehaviorTool AspectwithClassName:@"LSSayHiAlertView" methodName:@"MDSayHiFailed" keyWord:@"say_hi_no"];
}


// 精品用户
+ (void)cute
{
    [LSBehaviorTool AspectwithClassName:@"LSSearchVC" methodName:@"MDCute_Man_Clicked" keyWord:@"MDCute_Man_Clicked"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchVC" methodName:@"MDCute_Woman_Clicked" keyWord:@"MDCute_Woman_Clicked"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_man_photo" keyWord:@"cute_man_photo"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_man_profile" keyWord:@"cute_man_profile"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_man_nextstep" keyWord:@"cute_man_nextpage"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_woman_photo" keyWord:@"MDCute_woman_photo"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_woman_profile" keyWord:@"MDCute_woman_profile"];
    [LSBehaviorTool AspectwithClassName:@"LSSearchPrivilegeVC" methodName:@"MDCute_woman_nextstep" keyWord:@"MDCute_woman_nextstep"];
}

+ (void)profileBehavior
{
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_1" keyWord:@"profile_1"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_2" keyWord:@"profile_2"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_3" keyWord:@"profile_3"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_4" keyWord:@"profile_4"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_5" keyWord:@"profile_5"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_6" keyWord:@"profile_6"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_7" keyWord:@"profile_7"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_8" keyWord:@"profile_8"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_9" keyWord:@"profile_9"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_10" keyWord:@"profile_10"];
    [LSBehaviorTool AspectwithClassName:@"LSMineCPConfig" methodName:@"MDProfile_11" keyWord:@"profile_11"];
//    LSMineCPBaseVC
    [LSBehaviorTool AspectwithClassName:@"LSMineCPFinishVC" methodName:@"MDProfileFinish" keyWord:@"profile_complete"];
}

+ (void)handleBehavior
{
    //用户通过进入到个人设置页面 上传照片数目。
    [LSBehaviorTool AspectwithClassName:@"LSMineEditVC" methodName:@"MDUploadPhoto" keyWord:@"setting_UPLOAD_PHOTO"];
    //用户总滑牌次数
    [LSBehaviorTool AspectwithClassName:@"LSMatchVC" methodName:@"MDMatch" keyWord:@"match"];
    //用户总match成功次数
    [LSBehaviorTool AspectwithClassName:@"LSMatchVC" methodName:@"MDMatchSuccess" keyWord:@"match_success"];
    //用户向普通用户发送消息
    //用户查看其它用户详情的次数
    [LSBehaviorTool AspectwithClassName:@"LSDetailViewController" methodName:@"viewDidLoad" keyWord:@"uers_View_users"];
    
    //用户通过 滑牌进入到上传照片
    [LSBehaviorTool AspectwithClassName:@"LSAddPhotoAlert" methodName:@"MDUPloadEnter" keyWord:@"Match_upload_photo"];
    //用户通过 滑牌进入到上传照片成功
    [LSBehaviorTool AspectwithClassName:@"LSAddPhotoAlert" methodName:@"MDUploadOK" keyWord:@"Match_upload_photo_complete"];
    //用户通过 滑牌进入到上传照片点击跳过
    [LSBehaviorTool AspectwithClassName:@"LSAddPhotoAlert" methodName:@"MDUploadFaild" keyWord:@"Match_upload_photo_skip"];
    
    
}

#pragma mark - 购买流程
+ (void)purchaseBehavior
{
    ///////////////////////////////   用户进入购买流程    /////////////////////////////////
    //    0. 点击购买
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"MDpurchase_begin" keyWord:@"upgrade_begin"];
    //    1. 首页底部
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase01_searchMore_Begin" keyWord:@"search_upgrade_begin"];
    //    2. 精品用户底部
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase02_cute_Begin" keyWord:@"cute_upgrade_begin"];
    //    3. 筛选
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase03_filter_Begin" keyWord:@"filter_upgrade_begin"];
    //    4. 看喜欢我的人
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase04_likeMe_Begin" keyWord:@"likesme_upgrade_begin"];
    //    5. 查看我的人
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase05_viewMe_Begin" keyWord:@"viewme_upgrade_begin"];
    //    6. 发送消息
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase06_message_Begin" keyWord:@"message_upgrade_begin"];
    //    7. 设置界面
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase07_Setting_Begin" keyWord:@"setting_upgrade_begin"];
    //    8. 开通权限Features
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase08_Feature_Begin" keyWord:@"feature_upgrade_begin"];
    //    9. 隐私模式
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase09_Incognito_Begin" keyWord:@"incognito_upgrade_begin"];
    //    10.匹配界面限制
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase10_Match_Begin" keyWord:@"match_upgrade_begin"];
    
    ///////////////////////////////   用户完成购买    /////////////////////////////////
    //    1. 首页底部
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase01_searchMore" keyWord:@"serach_upgrade"];
    //    2. 精品用户底部
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase02_cute" keyWord:@"cute_upgrade"];
    //    3. 筛选
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase03_filter" keyWord:@"filter_upgrade"];
    //    4. 看喜欢我的人
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase04_likeMe" keyWord:@"likesme_upgrade"];
    //    5. 查看我的人
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase05_viewMe" keyWord:@"viewme_upgrade"];
    //    6. 发送消息
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase06_message" keyWord:@"message_upgrade"];
    //    7. 设置界面
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase07_Setting" keyWord:@"setting_upgrade"];
    //    8. 开通权限Features
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase08_Feature" keyWord:@"feature_upgrade"];
    //    9. 隐私模式
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase09_Incognito" keyWord:@"incognito_upgrade"];
    //    10.匹配界面限制
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"purchase10_Match" keyWord:@"match_upgrade"];
    
    ///////////////////////////////   进入    /////////////////////////////////
    //用户进入内购页面次数
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"SEEKING_baseUIConfig" keyWord:@"All_upgrade"];
    
    ///////////////////////////////   关闭    /////////////////////////////////
    //用户进入内购页面次数点击关闭
    [LSBehaviorTool AspectwithClassName:@"LSVIPAlertView" methodName:@"MDPurchaseClose" keyWord:@"upgrade_Close"];
    
    
    ///////////////////////////////   购买类型  /////////////////////////////////
    //用户进入内购页面 购买7Day
    [LSBehaviorTool AspectwithClassName:@"LSPurchaseManager" methodName:@"MDVIP7" keyWord:@"upgrade_7"];
    //用户进入内购页面 购买30Day
    [LSBehaviorTool AspectwithClassName:@"LSPurchaseManager" methodName:@"MDVIP30" keyWord:@"upgrade_30"];
    //用户进入内购页面 购买90Day
    [LSBehaviorTool AspectwithClassName:@"LSPurchaseManager" methodName:@"MDVIP90" keyWord:@"upgrade_90"];
    
    ///////////////////////////////   购买失败  /////////////////////////////////
    //购买失败
    [LSBehaviorTool AspectwithClassName:@"LSPurchaseManager" methodName:@"MDpurchase_failed" keyWord:@"upgrade_failed"];
    //购买连接失败
    [LSBehaviorTool AspectwithClassName:@"LSPurchaseManager" methodName:@"MDpurchase_failed_connect" keyWord:@"upgrade_failed_connect"];
}

//通知流程
+ (void)notification
{
    [LSBehaviorTool AspectwithClassName:@"JumpUtils" methodName:@"MDNotificationRequire" keyWord:@"notification"];
    //关闭
    [LSBehaviorTool AspectwithClassName:@"LSNotificationAlertView" methodName:@"MDNotEnable" keyWord:@"notification_no"];
    [LSBehaviorTool AspectwithClassName:@"LSNotificationAlertView" methodName:@"MDEnable" keyWord:@"notification_yes"];
    //开启通知
    [LSBehaviorTool AspectwithClassName:@"LSConversationVC" methodName:@"MDOpenNotification" keyWord:@"notification_open"];
    
    
    [LSBehaviorTool AspectwithClassName:@"LSSignUpNotifyVC" methodName:@"MDEnable" keyWord:@"notification_yes"];
    [LSBehaviorTool AspectwithClassName:@"LSSignUpNotifyVC" methodName:@"MDnotEnable" keyWord:@"notification_no"];
    
    
    
}

//登录注册流程
+ (void)aspectLogin
{
    //第一次进入
    [LSBehaviorTool AspectwithClassName:@"LSSignInVC" methodName:@"MDloginBegin" keyWord:@"logon"];
    //facebook注册开始
    [LSBehaviorTool AspectwithClassName:@"LSSignInVC" methodName:@"MDloginFaceBook_Begin" keyWord:@"logon_fa_begin"];
    //apple注册开始
    [LSBehaviorTool AspectwithClassName:@"LSSignInVC" methodName:@"MDloginApple_Begin" keyWord:@"logon_ap_begin"];
    //邮箱注册开始
    [LSBehaviorTool AspectwithClassName:@"LSSignInVC" methodName:@"MDlogonEmail_Begin" keyWord:@"logon_email_begin"];
    //邮箱登录开始
    [LSBehaviorTool AspectwithClassName:@"LSSignInVC" methodName:@"MDdengluEmail_Begin" keyWord:@"login_email_begin"];
    
    //用户一次选择facebook注册
    [LSBehaviorTool AspectwithClassName:@"LSSignUpBaseVC" methodName:@"MDloginFaceBook" keyWord:@"logon_fa"];
    //用户一次选择apple注册
    [LSBehaviorTool AspectwithClassName:@"LSSignUpBaseVC" methodName:@"MDloginApple" keyWord:@"logon_ap"];
    //用户一次选择邮箱注册
    [LSBehaviorTool AspectwithClassName:@"LSSignInEmailVC" methodName:@"MDLogonSuccess" keyWord:@"logon_email"];
    //用户一次选择邮箱登录
    [LSBehaviorTool AspectwithClassName:@"LSSignInEmailVC" methodName:@"MDLoginSuccess" keyWord:@"login_email"];
    
    
    //用户注册失败
    [LSBehaviorTool AspectwithClassName:@"LSSignUpBaseVC" methodName:@"MDloginFailed" keyWord:@"logon_failed"];
    
    // 来到性别填写页面 注册步骤1
    [LSBehaviorTool AspectwithClassName:@"LSLogChooseVC" methodName:@"MDChooseGender01" keyWord:@"logon_fa_1"];
    //来到名字填写页面注册步骤2
    [LSBehaviorTool AspectwithClassName:@"LSSignUpNameVC" methodName:@"MDChooseName03" keyWord:@"logon_fa_2"];
    // 来到age填写页面 注册步骤3
    [LSBehaviorTool AspectwithClassName:@"LSSignUpAgeVC" methodName:@"MDChooseAge04" keyWord:@"logon_fa_3"];
    // 来到height填写页面 注册步骤4
    [LSBehaviorTool AspectwithClassName:@"LSSignUpHeightVC" methodName:@"MDChooseHeight05" keyWord:@"logon_fa_4"];
    // 来到photo填写页面 注册步骤5
    [LSBehaviorTool AspectwithClassName:@"LSSignUpHeadVC" methodName:@"MDChooseHeadImage06" keyWord:@"logon_fa_5"];
    //来到通知页面 注册步骤6
    [LSBehaviorTool AspectwithClassName:@"LSSignUpNotifyVC" methodName:@"MDSignupNotifiy" keyWord:@"logon_fa_6"];
    //来到定位同意页面 注册步骤7
    [LSBehaviorTool AspectwithClassName:@"LSSignUpLocationVC" methodName:@"MDchooseLocation" keyWord:@"logon_fa_7"];
    
    [LSBehaviorTool AspectwithClassName:@"LSSignUpLocationVC" methodName:@"chooseLocation13" keyWord:@"logon_fa_6_IP_yes"];
    [LSBehaviorTool AspectwithClassName:@"LSSignUpLocationVC" methodName:@"chooseDisagreeLocation13" keyWord:@"logon_fa_6_IP_no"];
    
    //注销账号
    [LSBehaviorTool AspectwithClassName:@"LSMineSettingVC" methodName:@"MDDeleteCount_open" keyWord:@"deleteCount_open"];
    [LSBehaviorTool AspectwithClassName:@"LSMineSettingVC" methodName:@"MDDeleteCount_success" keyWord:@"deleteCount_success"];
}

/**
    钩取某个类的方法
 */
+(void)AspectwithClassName:(NSString *)className methodName:(NSString *)methodName keyWord:(NSString*)keyword {
    //view will appear
    //设备 uuid
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    Class class = NSClassFromString(className);
    SEL selectro = NSSelectorFromString(methodName);
    
    NSString *key = keyword;
    #ifdef DEBUG
        key = [NSString stringWithFormat:@"DEBUG_%@",keyword];
    #else
        key = keyword;
    #endif
        [class aspect_hookSelector:selectro
                              withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> info){
                                    NSLog(@"\n🍌🍌🍌\n%@\nkey:%@\n🍌🍌🍌",deviceUUID,key);
                                    [MobClick event:key];
        
                                }error:NULL];
}


+(void)AspectMorewithClassName:(NSString *)className methodName:(NSString *)methodName keyWord:(NSString*)keyword {
    //view will appear
    //设备 uuid
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    Class class = NSClassFromString(className);
    SEL selectro = NSSelectorFromString(methodName);
    
    NSString *key = keyword;
    #ifdef DEBUG
        key = [NSString stringWithFormat:@"DEBUG_%@",keyword];
    #else
        key = keyword;
    #endif
    
    [class aspect_hookSelector:selectro
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> info,NSString *string){
                        NSLog(@"\n🍌🍌🍌\n%@\nkey:%@\n%@\n🍌🍌🍌",deviceUUID,key,string);
                        [MobClick event:key];
                        
                    }error:NULL];
}

@end
