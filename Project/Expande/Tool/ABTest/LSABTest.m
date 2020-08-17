//
//  LSABTest.m
//  Project
//
//  Created by XuWen on 2020/6/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSABTest.h"

@implementation LSABTest

- (void)ABTest:(void (^)(int testResult)) ABTestBlock
{
    [self get:@"" cache:YES success:^(Response * _Nonnull response) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
//    [[FIRRemoteConfig remoteConfig]fetchWithExpirationDuration:0 completionHandler:^(FIRRemoteConfigFetchStatus status, NSError * _Nullable error) {
//        [[FIRRemoteConfig remoteConfig] activateWithCompletionHandler:^(NSError * _Nullable error) {
//
//            FIRRemoteConfigValue *vipdic = [[FIRRemoteConfig remoteConfig] objectForKeyedSubscript:@"msgVIP"];
//            if(error){
//                kUser.abTest = 0;
//            }else{
//                kUser.abTest = [[vipdic numberValue]integerValue];
//            }
//
//        }];
//
//
//    }];
    
}

@end
