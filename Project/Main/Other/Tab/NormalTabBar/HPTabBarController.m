//
//  HPTabBarController.m
//  Project
//
//  Created by XuWen on 2020/6/1.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "HPTabBarController.h"
#import "LSSearchVC.h"
#import "LSMatchVC.h"
#import "LSNotificationsVC.h"
#import "LSConversationVC.h"
#import "LSMineVC.h"

@interface HPTabBarController ()

@end

@implementation HPTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
        self.selectedIndex = 2;
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //跳转到卡片页面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(select2Index) name:kNotification_Logout_TabChanged object:nil];
    //注册未读消息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unreadMessageCount:) name:@"unreadMessageCount" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unreadLikedViewedMessageCount:) name:@"unreadLikedViewedMessageCount" object:nil];
}

- (void)select2Index
{
    self.selectedIndex = 2;
}

/** 未读消息*/
- (void)unreadMessageCount:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo[@"unreadcount"]);
    int count = [notification.userInfo[@"unreadcount"]intValue];
    UITabBarItem *tabBarItem = self.tabBar.items[1];
    if(count == 0){
       [tabBarItem setBadgeValue:nil];// 隐藏角标
    }else{
       [tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",count]];
    }
    NSLog(@"－－－－－接收到通知------");
}

/** 未读like*/
- (void)unreadLikedViewedMessageCount:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo[@"unreadcount"]);
    int count = [notification.userInfo[@"unreadcount"]intValue];
    UITabBarItem *tabBarItem = self.tabBar.items[3];
    if(count == 0){
       [tabBarItem setBadgeValue:nil];// 隐藏角标
    }else{
       [tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",count]];
    }
}

- (void)initialize
{
    self.viewControllers = @[
                             [[LSBaseNavigationController alloc] initWithRootViewController:[LSSearchVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[LSConversationVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[LSMatchVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[LSNotificationsVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[LSMineVC new]],
                             ];
    self.images = @[[UIImage imageNamed:@"tab_0"],
                    [UIImage imageNamed:@"tab_1"],
                    [UIImage imageNamed:@"tab_2"],
                    [UIImage imageNamed:@"tab_3"],
                    [UIImage imageNamed:@"tab_4"]];
    
    self.selectedImages = @[[UIImage imageNamed:@"tab_0_selected"],
                            [UIImage imageNamed:@"tab_1_selected"],
                            [UIImage imageNamed:@"tab_2_selected"],
                            [UIImage imageNamed:@"tab_3_selected"],
                            [UIImage imageNamed:@"tab_4_selected"]];
    
    [self setTitleColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:14] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blueColor] andFont:[UIFont systemFontOfSize:14] forState:UIControlStateSelected];
    [self setTitlePositionAdjustment:UIOffsetZero andimageInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
