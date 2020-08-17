//
//  AppDelegate+LSAnalysis.m
//  Project
//
//  Created by XuWen on 2020/3/23.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "AppDelegate+LSAnalysis.h"
#import "LSBehaviorTool.h"

@implementation AppDelegate (LSAnalysis)

#pragma mark - 统计
- (void)analysis:(UIApplication *)application Options:(NSDictionary *)launchOptions
{
    // 注册钩子
    [LSBehaviorTool Aspect];
    
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    return YES;
}

@end
