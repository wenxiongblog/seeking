//
//  JumpUtils.h
//  Project
//
//  Created by XuWen on 2020/1/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 搜索页面转场动画
extern NSString * _Nullable presentTransitionAnimationModalSink;

@interface JumpUtils : NSObject
+ (void)customTransition;

// 跳转到启动模块
+ (void)jumpWelcomeModel;

// 跳转到马甲包登录页面
+ (void)jumpVestLoginModel;
// 跳转到马甲包正式界面
+ (void)jumpVestHomeModel;
/**
 跳转到主模块
 */
+ (void)jumpMainModel;

//切换到登录界面
+ (void)jumpLoginModelComplete:(void(^)(BOOL success))block;
//切换没有动画
+ (void)tabjumpLoginModelWithoutAnimation:(void(^)(BOOL success))block;

//跳转到系统设置界面
+ (void)jumpSystemSetting;
@end

NS_ASSUME_NONNULL_END
