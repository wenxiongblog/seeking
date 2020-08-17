//      
//  LSSignInNavigationController.m
//  Project
//
//  Created by XuWen on 2020/3/31.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignInNavigationController.h"
#import "LSRongYunHelper.h"
#import "HPTabBarController.h"
    
#import "LSLogChooseVC.h"
#import "LSSignUpNameVC.h"
#import "LSSignUpAgeVC.h"
#import "LSSignUpHeadVC.h"
#import "LSSignUpHeightVC.h"
#import "LSSignUpLocationVC.h"
#import "LSRongYunHelper.h"
#import "LSProtocolViewController.h"


@interface LSSignInNavigationController ()

@end

@implementation LSSignInNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController Complete:(void(^)(BOOL success))block
{
    self = [super initWithRootViewController:rootViewController];
    if(self){
        self.loginResultBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self notificationConfig];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 发送登录完成的通知
//登录成功或注册完成后发送通知，回到主界面
- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNoti:) name:kNotification_Login object:nil];
}

- (void)loginNoti:(NSNotification *)notify
{
    NSDictionary *dic = [notify object];
    BOOL value = [dic[@"key"]boolValue];
    //先退出融云登录
    [LSRongYunHelper logout];
    //这里再进行环信注册和登录
    kXWWeakSelf(weakself);
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    NSLog(@"tokeng%@",kUser.token);
    [[LSRongYunHelper share]connectRongYun:kUser.token success:^(BOOL isSuccess, NSString * _Nonnull userId) {
       //登录成功，判断哪里信息没有完善
        [AlertView hiddenLoadingInView:weakself.view];
      
        if(isSuccess){
            //登录成功后进行回调
            if(self.loginResultBlock){
                [self dismissViewControllerAnimated:YES completion:^{
                    kUser.isLogin = value;
                    self.loginResultBlock(value);
                }];
            }else{
                if(value){
                    kUser.isLogin = value;
                    HPTabBarController *tabBar = [[HPTabBarController alloc]init];
                    CATransition *transtition = [CATransition animation];
                    transtition.duration = 0.3;
                    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
                    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
                }
            }
           
        }else{
            [AlertView hiddenLoadingInView:weakself.view];
            [AlertView toast:@"Login failed" inView:self.view];
        }
    }];
}


+ (LSSignUpBaseVC *)gofinishInfoVC
{
    LSSignUpBaseVC *vc = nil;
    if(kUser.sex == 0){
        // 性别选择
        vc = [[LSLogChooseVC alloc]init];
    }else if(kUser.name.length == 0){
        // 填写名字
        vc = [[LSSignUpNameVC alloc]init];
    }else if(kUser.age == 0){
        // 选择年龄
        vc = [[LSSignUpAgeVC alloc]init];
    }else if(kUser.height.length == 0){
        // 选择身高
        vc = [[LSSignUpHeightVC alloc]init];
    }
    else if(kUser.images.length == 0){
        //选择头像
        vc = [[LSSignUpHeadVC alloc]init];
    }
    else if([kUser.address isEqualToString:@"Secrete"] || [kUser.address isEqualToString:@"保密"]){
        //地理位置
        vc = [[LSSignUpLocationVC alloc]init];
    }
    return vc;
}

@end
