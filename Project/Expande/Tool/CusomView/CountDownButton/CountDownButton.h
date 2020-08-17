//
//  CountDownButton.h
//  SCZW
//
//  Created by solehe on 2018/12/21.
//  Copyright © 2018 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^CountDownFinishBlock)(BOOL finished);
typedef NS_ENUM(NSInteger, CountDownState) {
    CountDownStateNormal,  //正常状态，可点击
    CountDownStateStart,   //开始倒计时
    CountDownStateRunning, //倒计时中
    CountDownStateStop     //倒计时结束
};

typedef NS_ENUM(NSInteger, ShowTimeStyle) {
    ShowTimeStyleHour,   //00:00:00
    ShowTimeStyleMinite, //00:00
    ShowTimeStyleCustomer, //00:00
};

NS_ASSUME_NONNULL_BEGIN

@interface CountDownButton : UIButton

//展示时间的形式
@property (nonatomic, assign) ShowTimeStyle showTimeStyle;
// 倒计时状态(只读)
@property (nonatomic, assign, readonly) CountDownState countDownState;
@property (nonatomic, copy) void(^CountDownFinishBlock)(BOOL finished);
@property (nonatomic, copy) void(^CountDownProgressBlock)(BOOL finished,int progress);
/**
 开始倒计时

 @param sec 倒计时时长
 */
- (void)startCountDown:(NSTimeInterval)sec;

/**
 停止倒计时
 */
- (void)stopCountDown;

#pragma mark - 匹配 match 倒计时相关
/*
 开始计时的时间，
 */
+ (NSInteger)countDownSecond;
/**
 是否需要倒计时
 */
+ (BOOL)isNeedCountDown;

/**存储倒计时开始时间*/
+ (void)saveCountTime;


#pragma mark - 账号删除 倒计时相关
/*
 开始计时的时间，
 */
+ (NSInteger)countDownSecond_deleteAcount;
/**
 是否需要倒计时
 */
+ (BOOL)isNeedCountDown_deleteAcount;

/**存储倒计时开始时间*/
+ (void)saveCountTime_deleteAcount;

@end

NS_ASSUME_NONNULL_END
