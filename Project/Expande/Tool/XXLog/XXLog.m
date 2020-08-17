//
//  XXLog.m
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXLog.h"
#import "XXLogView.h"

@interface XXLog ()

// 日志界面
@property (nonatomic, strong) XXLogView *logView;

@end

@implementation XXLog

+ (instancetype)share {
    static XXLog *_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[super alloc] init];
    });
    return _singleton;
}

- (XXLogView *)logView {
    if (!_logView) {
        _logView = [[XXLogView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_logView setCenter:CGPointMake(kSCREEN_WIDTH-40, kSCREEN_HEIGHT-100)];
        [_logView setBackgroundColor:[UIColor greenColor]];
        [_logView.layer setCornerRadius:30.f];
        [_logView.layer setMasksToBounds:YES];
        [_logView setHidden:YES];
    }
    return _logView;
}

/**
 获取网络请求地址
 
 @param url 默认地址
 */
+ (NSString *)requestUrl:(NSString *)url {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"BASE_URL"];
    return (str.length > 0) ? str : url;
}

/**
 是否展示日志打印浮窗
 
 @param isShow 展示：YES，隐藏：NO
 */
+ (void)show:(BOOL)isShow {
    [[XXLog share].logView setHidden:!isShow];
    [[UIApplication sharedApplication].keyWindow addSubview:[XXLog share].logView];
}

/**
 打印日志（记录的同时也会打印到控制台）
 
 @param msg 日志信息
 */
+ (void)log:(NSString *)msg,... {
    
    va_list vargs; // C语言的字符指针, 指针根据offset来指向需要的参数,从而读取参数
    va_start(vargs, msg); // 设置指针的起始地址为方法的...参数的第一个参数
    NSString *str = [[NSString alloc] initWithFormat:msg arguments:vargs];
    va_end(vargs);
    
    // 打印到控制台
    NSString *dateTime = [[NSDate date] stringWithFormat:@"HH:mm:ss"];
    NSLog(@"%@", [NSString stringWithFormat:@"[%@] %@", dateTime, [str substringToIndex:MIN(str.length, 500)]]);
    
    // 隐藏时不记录日志信息
    if (![[XXLog share].logView isHidden]) {
        XXLogModel *model = [[XXLogModel alloc] init];
        [model setTime:dateTime];
        [model setMsg:str];
        [[XXLog share].logView addLog:model];
    }
}

/**
 清空日志
 */
+ (void)clear {
    [[XXLog share].logView  clear];
}

@end
