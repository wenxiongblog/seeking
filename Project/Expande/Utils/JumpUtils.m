//
//  JumpUtils.m
//  Project
//
//  Created by XuWen on 2020/1/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "JumpUtils.h"
#import "HPTabBarController.h"
#import "XXTransition.h"
#import "SEEKING_UserModel.h"
#import "LSSignInVC.h"
#import "LSSignUpLocationVC.h"
#import "LSSignInNavigationController.h"
#import "HPTabbarController.h"

#import <UserNotifications/UserNotifications.h>
//#import ""


// present转场动画
NSString *presentTransitionAnimationModalSink = @"PresentTransitionAnimationModalSink";

@implementation JumpUtils

+ (void)MDNotificationRequire{};

/**
 自定义转场动画
 
 */
+ (void)customTransition {
    
//    //启动XXTransition自定义转场
//    [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];

//    //更改全局NavTransiton效果
//    [XXTransition setNavTransitonKey:XXTransitionAnimationNavSink];
    
    // 自定义present转场动画
    [self customPresentTransitionAnimation];
}

+ (void)customPresentTransitionAnimation {
    
    __weak typeof(self) weakSelf = self;
    [XXTransition addPresentAnimation:presentTransitionAnimationModalSink animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
        fromView.hidden = YES;
        
        [containerView addSubview:tempView];
        [containerView addSubview:toView];
        
        toView.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = [weakSelf sinkTransformSecondPeriod];
                toView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(containerView.frame));
            }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
    [XXTransition addDismissAnimation:presentTransitionAnimationModalSink backGestureDirection:XXBackGestureNone animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [transitionContext containerView].subviews[0];
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                fromView.transform = CGAffineTransformIdentity;
                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = CATransform3DIdentity;
            }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if (![transitionContext transitionWasCancelled]) {
                toView.hidden = NO;
                [tempView removeFromSuperview];
            }
        }];
    }];
}

+ (CATransform3D)sinkTransformFirstPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-900;
    t = CATransform3DTranslate(t, 0, 0, -100);
    t = CATransform3DRotate(t, 15.0 * M_PI/180.0, 1, 0, 0);
    return t;
}

+ (CATransform3D)sinkTransformSecondPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = [self sinkTransformFirstPeriod].m34;
    t = CATransform3DTranslate(t, 0, -40, 0);
    t = CATransform3DScale(t, 0.8, 0.8, 1);
    return t;
}


// 跳转到启动模块
+ (void)jumpWelcomeModel
{
    UIViewController *vc = [[NSClassFromString(@"LSWelcomeVC") alloc] init];
    [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].delegate.window setBackgroundColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

// 跳转到马甲包登录页面
+ (void)jumpVestLoginModel
{
    UIViewController *vc = [[NSClassFromString(@"VESTSignInVC") alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
     [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}
// 跳转到马甲包正式界面
+ (void)jumpVestHomeModel
{
    
}

/**
 跳转到主模块
 */
+ (void)jumpMainModel {
    HPTabBarController *vc = [[HPTabBarController alloc]init];
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}


#pragma mark - 跳转
+ (void)jumpLoginModelComplete:(void(^)(BOOL success))block
{
    if (!kUser.isLogin){
        LSSignInVC *vc = [[LSSignInVC alloc]init];
        LSSignInNavigationController *nav = [[LSSignInNavigationController alloc]initWithRootViewController:vc Complete:block];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self getCurrentVC]presentViewController:nav animated:YES completion:^{
        }];
    }else{
        block(YES);
    }
}

+ (void)tabjumpLoginModelWithoutAnimation:(void(^)(BOOL success))block
{
    if (!kUser.isLogin){
        LSSignInVC *vc = [[LSSignInVC alloc]init];
        LSSignInNavigationController *nav = [[LSSignInNavigationController alloc]initWithRootViewController:vc Complete:block];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self getCurrentVC]presentViewController:nav animated:NO completion:^{
        }];
    }else{
        block(YES);
    }
}


+ (void)jumpSystemSetting
{
    
    [self MDNotificationRequire];
    UIApplication *application = [UIApplication sharedApplication];
    //如果没有打开过用弹窗
    if(![[NSUserDefaults standardUserDefaults]boolForKey:kDefine_isNotificationAsk]){
         if ([application
                respondsToSelector:@selector(registerUserNotificationSettings:)]) {
          //注册推送, 用于iOS8以及iOS8之后的系统
          UIUserNotificationSettings *settings = [UIUserNotificationSettings
              settingsForTypes:(UIUserNotificationTypeBadge |
                                UIUserNotificationTypeSound |
                                UIUserNotificationTypeAlert)
                    categories:nil];
          [application registerUserNotificationSettings:settings];
             
        } else {
          //注册推送，用于iOS8之前的系统
          UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeAlert |
                                             UIRemoteNotificationTypeSound;
          [application registerForRemoteNotificationTypes:myTypes];
          
        }
        [application registerForRemoteNotifications];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kDefine_isNotificationAsk];
    }else{
        //如果打开过用跳转setting
        if([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone){
            NSLog(@"没有打开");
            //打开设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }
        }else{
            NSLog(@"==========打开了");
            [application registerForRemoteNotifications];
        }
    }
}
@end
