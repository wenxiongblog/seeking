//
//  XXLockTouchIdTool.m
//  SCGov
//
//  Created by solehe on 2019/8/20.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <LocalAuthentication/LAContext.h>
#import "XXLockTouchIdTool.h"

@implementation XXLockTouchIdTool

// 验证指纹
+ (void)touch:(void(^)(BOOL success, NSString *error))block {
    [self startTouchIdVerfity:LAPolicyDeviceOwnerAuthenticationWithBiometrics result:block];
}

// 开始验证指纹数据
+ (void)startTouchIdVerfity:(LAPolicy)policy result:(void(^)(BOOL success, NSString *error))block {
    @weak(self)
    [[[LAContext alloc] init] evaluatePolicy:policy
                 localizedReason:@"通过Home键验证已有指纹"
                           reply:^(BOOL success, NSError * _Nullable error) {
                               if (success) {
                                   if (policy == LAPolicyDeviceOwnerAuthentication) {
                                       [weakself startTouchIdVerfity:LAPolicyDeviceOwnerAuthenticationWithBiometrics result:block];
                                   } else {
                                       block(YES, @"请先开启FaceID权限");
                                   }
                               } else if (error.code == -3) {
                                   [weakself startTouchIdVerfity:LAPolicyDeviceOwnerAuthentication result:block];
                               } else if (error.code == -6) {
                                   block(NO, @"请先开启FaceID权限");
                               } else if (error.code == -7) {
                                   block(NO, @"没有可用的指纹");
                               } else if (error.code == -2) {
                                   block(NO, @"取消校验");
                               } else {
                                   block(NO, @"校验失败");
                               }
                           }];
}

@end
