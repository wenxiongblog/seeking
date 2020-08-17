//
//  CountDownButton.m
//  SCZW
//
//  Created by solehe on 2018/12/21.
//  Copyright © 2018 solehe. All rights reserved.
//

#import "CountDownButton.h"

@interface CountDownButton ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation CountDownButton

- (void)dealloc {
    [self stopCountDown];
}

/**
 开始倒计时
 
 @param sec 倒计时时长
 */
- (void)startCountDown:(NSTimeInterval)sec {
    
    __block NSInteger time = sec; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    @weak(self)
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            [weakself stopCountDown];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
//                [weakself setTitle:@"" forState:UIControlStateNormal];
//                [weakself setUserInteractionEnabled:YES];
                if(self.CountDownFinishBlock){
                    self.CountDownFinishBlock(YES);
                }
                if(self.CountDownProgressBlock){
                    self.CountDownProgressBlock(YES, 0);
                }
            });
        }else{
            int seconds = (int)time;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NSString *hour = [NSString stringWithFormat:@"%02d",seconds/3600];
                NSString *minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
                NSString *second = [NSString stringWithFormat:@"%02d",seconds%60];
                if(weakself.showTimeStyle == ShowTimeStyleHour){
                    [weakself setTitle:[NSString stringWithFormat:@"%@:%@:%@", hour,minute,second] forState:UIControlStateNormal];
                }else if(weakself.showTimeStyle == ShowTimeStyleMinite){
                    [weakself setTitle:[NSString stringWithFormat:@"%@:%@",minute,second] forState:UIControlStateNormal];
                }else if(weakself.showTimeStyle == ShowTimeStyleCustomer){
                    [weakself setTitle:[NSString stringWithFormat:@"%@ %@:%@    ",kLanguage(@"Waiting for"),minute,second] forState:UIControlStateNormal];
                }
                
                [weakself setUserInteractionEnabled:NO];
                if(self.CountDownProgressBlock){
                    self.CountDownProgressBlock(NO, seconds);
                }
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

/**
 停止倒计时
 */
- (void)stopCountDown {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        [self setTimer:nil];
    }
}



#pragma mark - match 倒计时相关
/*
 开始计时的时间，
 */
+ (NSInteger)countDownSecond
{
    long time = [[NSUserDefaults standardUserDefaults]integerForKey:@"CountDown"];
    long currentTime = [[NSDate getNowTimeTimestamp3]longLongValue];
    long t = 60*60*24 - (currentTime-time);
    return t;
}

/**
 是否需要倒计时
 */
+ (BOOL)isNeedCountDown
{
    if(kUser.isVIP){
        //如果是VIP 不用倒计时
        return NO;
    }else{
        long time = [[NSUserDefaults standardUserDefaults]integerForKey:@"CountDown"];
        if(time == 0){
            //如果没有存储数据，不用倒计时
            return NO;
        }
        long currentTime = [[NSDate getNowTimeTimestamp3]longLongValue];
        long t = currentTime - time;
        if(currentTime - time < 60*60*24){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

/**存储倒计时开始时间*/
+ (void)saveCountTime
{
    long time = [[NSDate getNowTimeTimestamp3]longLongValue];
    [[NSUserDefaults standardUserDefaults]setInteger:time forKey:@"CountDown"];
}

#pragma mark - 账号删除 倒计时相关
/*
 开始计时的时间，
 */
+ (NSInteger)countDownSecond_deleteAcount
{
    long time = [[NSUserDefaults standardUserDefaults]integerForKey:@"CountDown_deleteAcount"];
    long currentTime = [[NSDate getNowTimeTimestamp3]longLongValue];
    long t = 60*60*24*3 - (currentTime-time);
    return t;
}
/**
 是否需要倒计时
 */
+ (BOOL)isNeedCountDown_deleteAcount
{
    if(kUser.isVIP){
           //如果是VIP 不用倒计时
           return NO;
       }else{
           long time = [[NSUserDefaults standardUserDefaults]integerForKey:@"CountDown_deleteAcount"];
           if(time == 0){
               //如果没有存储数据，不用倒计时
               return NO;
           }
           long currentTime = [[NSDate getNowTimeTimestamp3]longLongValue];
           if(currentTime - time < 60*60*24*3){
               return YES;
           }else{
               return NO;
           }
       }
       return YES;
}

/**存储倒计时开始时间*/
+ (void)saveCountTime_deleteAcount
{
    long time = [[NSDate getNowTimeTimestamp3]longLongValue];
    [[NSUserDefaults standardUserDefaults]setInteger:time forKey:@"CountDown_deleteAcount"];
}

@end
