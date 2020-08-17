//
//  AlertView.m
//  SCZW
//
//  Created by solehe on 2018/10/14.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import "AlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define LOADINGTAG   6362728  //加载提示
#define PROGRESSTAG  6362727  //进度提示
#define TOASTTAG     6362726  //文字提示

@implementation AlertView

/**
 加载等待框
 */
+ (void)showLoading:(NSString *)msg inView:(UIView *)view {
    
    if (!view) { return; }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil || [hud tag] != LOADINGTAG) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        [hud.bezelView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
//        [hud.label setFont:[UIFont systemFontOfSize:14.f]];
//        [hud setContentColor:[UIColor whiteColor]];
        [hud setMode:MBProgressHUDModeIndeterminate];
//        [hud setOffset:CGPointMake(0, -30)];
        [hud setMargin:20.f];
        [hud setTag:LOADINGTAG];
    }
    hud.labelText = msg;
}

+ (void)hiddenLoadingInView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud != nil || [hud tag] == LOADINGTAG) {
//        [hud hideAnimated:YES];
        [hud hide:YES afterDelay:0];
    }
}

/**
 进度提示框
 */
+ (void)showProgress:(float)progress inView:(UIView *)view {
    
    if (!view) { return; }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil || [hud tag] != PROGRESSTAG) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        [hud.bezelView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
//        [hud.label setFont:[UIFont systemFontOfSize:14.f]];
//        [hud setContentColor:[UIColor whiteColor]];
        [hud setMode:MBProgressHUDModeAnnularDeterminate];
//        [hud setOffset:CGPointMake(0, -30)];
        [hud setMargin:20.f];
        [hud setTag:PROGRESSTAG];
    }
    hud.labelText = [NSString stringWithFormat:@"Progress: %.0f%%", progress*100];
    [hud setProgress:progress];
}

+ (void)hiddenProgressInView:(UIView *)view {
    if (!view) { return; }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud != nil || [hud tag] == PROGRESSTAG) {
        [hud hide:YES afterDelay:0];
    }
}

/**
 类似于安卓的底部弹出提示
 
 @param msg 提示信息
 */
+ (void)toast:(NSString *)msg inView:(UIView *)view {
    
    if (!view) { return; }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil || [hud tag] != TOASTTAG) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        [hud.bezelView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
//        [hud.label setFont:[UIFont systemFontOfSize:15.f]];
//        [hud.label setNumberOfLines:0];
//        [hud setContentColor:[UIColor whiteColor]];
        [hud setMode:MBProgressHUDModeText];
//        [hud setOffset:CGPointMake(0, YH(0))];
        [hud setMargin:10.f];
        [hud setTag:TOASTTAG];
    }
    
//    [hud.label setText:msg];
    hud.labelText = msg;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [hud hideAnimated:YES];
        [hud hide:YES afterDelay:0];
    });
}

#pragma mark -
/**
 系统提醒弹出框（带取消和自定义按钮，不带标题）

 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(NSString *)title msg:(NSString * __nullable)msg button:(NSString *)name action:(void(^)(void))action cancel:(void(^)(void))cancel {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull a) {
        if (cancel) { cancel(); }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull a) {
        if (action) { action(); }
    }]];
    [[self getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
}

/**
 系统提醒弹出框（自定义按钮，不带标题）

 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(NSString *)title msg:(NSString * __nullable)msg button:(NSString *)name cancelText:(NSString *)cancelText action:(void(^)(void))action cancel:(void(^)(void))cancel {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull a) {
        if (cancel) { cancel(); }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull a) {
        if (action) { action(); }
    }]];
    [[self getCurrentVC] presentViewController:alertVc animated:YES completion:nil];
}

/**
 系统提醒弹出框（带取消和自定义按钮，不带标题）
 
 @param vc 控制器
 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(UIViewController *)vc title:(NSString *)title msg:(NSString *)msg button:(NSString *)name action:(void(^)(void))action cancel:(void(^)(void))cancel {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull a) {
        if (cancel) { cancel(); }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull a) {
        if (action) { action(); }
    }]];
    [vc presentViewController:alertVc animated:YES completion:nil];
}

@end
