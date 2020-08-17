//
//  AlertView.h
//  SCZW
//
//  Created by solehe on 2018/10/14.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 弹出提醒框
 */
@interface AlertView : UIView

/**
 加载等待框
 */
+ (void)showLoading:(NSString *)msg inView:(UIView *)view ;
+ (void)hiddenLoadingInView:(UIView *)view ;

/**
 进度提示框
 */
+ (void)showProgress:(float)progress inView:(UIView *)view ;
+ (void)hiddenProgressInView:(UIView *)view ;

/**
 类似于安卓的底部弹出提示

 @param msg 提示信息
 */
+ (void)toast:(NSString *)msg inView:(UIView *)view ;


/**
 系统提醒弹出框（带取消和自定义按钮，不带标题）
 
 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(NSString *)title msg:(NSString * __nullable)msg button:(NSString *)name action:(void(^)(void))action cancel:(void(^)(void))cancel;

/**
 系统提醒弹出框（带取消和自定义按钮，不带标题）
 
 @param vc 控制器
 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(UIViewController *)vc title:(NSString *)title msg:(NSString *)msg button:(NSString *)name action:(void(^)(void))action cancel:(void(^)(void))cancel;

/**
 系统提醒弹出框（自定义按钮，不带标题）

 @param title 标题
 @param msg 提示消息
 @param name 自定义按钮名称
 @param action 自定义按钮事件
 @param cancel 取消按钮事件
 */
+ (void)alert:(NSString *)title msg:(NSString * __nullable)msg button:(NSString *)name cancelText:(NSString *)cancelText action:(void(^)(void))action cancel:(void(^)(void))cancel;

@end

NS_ASSUME_NONNULL_END
