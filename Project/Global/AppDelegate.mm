//
//  AppDelegate.m
//  Project
//
//  Created by XuWen on 2019/12/9.
//  Copyright © 2019 xuwen. All rights reserved.
//  

#import "AppDelegate.h"
#import "AppDelegate+LSAnalysis.h"
#import "LSWelcomeVC.h"
#import "LSSignInVC.h"
#import "LSRongYunHelper.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Bugly/Bugly.h>
#import <UserNotifications/UserNotifications.h>

#import "LSSignInVC.h"
#import <UMCommon/UMCommon.h>
#import "LSSignInNavigationController.h"
#import "LSPurchaseManager.h"
#import "DBUtils.h"

// google 统计
#import "LSSignUpLocationVC.h"
#import "LSSignUpHeadVC.h"

#import "HPTabBarController.h"

#import "LSSignUpLocationVC.h"
#import "LSSignUpNotifyVC.h"
#import "LSLogChooseVC.h" //性别
#import "LSSignUpNameVC.h" //姓名
#import "LSSignUpAgeVC.h" //年龄
#import "LSSignUpHeightVC.h" //高度
#import "LSSignUpHeadVC.h" //照片
#import "LSSignUpLocationVC.h" //定位
#import "LSSignUpNotifyVC.h" //通知

//facebook 登录
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//购买
#import "LSPurchaseManager.h"
#import "LSImageVC.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
    
@end

@implementation AppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //购买预加载
    [[LSPurchaseManager share]preGetPurchaseInfo:^(NSArray<LSPurchaseModel *> * _Nonnull array) {
        
    }];
    //腾讯bugly
    [Bugly startWithAppId:TX_BUGLY_KEY];
    //友盟统计
    [UMConfigure initWithAppkey:kYouMengKey channel:@"App Store"];
    //统计
    [self analysis:application Options:launchOptions];
    //facebook 登录
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //融云配置
    [[LSRongYunHelper share]configRongYun];
    // 注册转场动画
    [JumpUtils customTransition];
    //Realm
    [DBUtils configuration];
    
    // 设定主界面
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    UIViewController *vc = nil;
    vc = [[LSImageVC alloc]init];
//    if(kUser.isLogin){
//        //进行判断是否填完善了信息
//        LSSignUpBaseVC *infoVC = [LSSignInNavigationController gofinishInfoVC];
//        if(infoVC){
//            //未完成信息
//            vc = [[LSSignInNavigationController alloc]initWithRootViewController:infoVC Complete:nil];
//        }else{
//            //全部完成
//            vc = [[HPTabBarController alloc]init];
//        }
//    }else{
//        vc = [[LSSignInNavigationController alloc]initWithRootViewController:[[LSSignInVC alloc]init] Complete:nil];
//    }
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    //状态栏颜色
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    // 键盘管理
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    return YES;
}


#pragma mark -quickSDK初始化完成
- (void)smpcQpInitResult:(NSNotification *)notify
{
    NSLog(@"%@",notify); //初始化成功，进行下一步流程
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey] ];
    return handled;
}

/**
    * 推送处理2
    */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[RCIMClient sharedRCIMClient] setDeviceTokenData:deviceToken];
}
    

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if(kUser.isLogin){
        [[LSRongYunHelper share] connectRongYun:kUser.token success:^(BOOL isSuccess, NSString * _Nonnull userId) {
            
        }];
    }
}



@end
