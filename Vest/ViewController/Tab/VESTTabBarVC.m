//
//  VESTTabBarVC.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTTabBarVC.h"
#import "VESTOneVC.h"
#import "VESTTwoVC.h"
#import "VESTThreeVC.h"
#import "VESTFourVC.h"

@implementation VESTTabBarVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
//        self.selectedIndex = 2;
    }
    return self;
}

- (void)initialize
{
    self.viewControllers = @[
                             [[LSBaseNavigationController alloc] initWithRootViewController:[VESTOneVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[VESTTwoVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[VESTThreeVC new]],
                             [[LSBaseNavigationController alloc] initWithRootViewController:[VESTFourVC new]]
                             ];
    self.images = @[[UIImage imageNamed:@"tab_0"],
                    [UIImage imageNamed:@"tab_1"],
                    [UIImage imageNamed:@"tab_2"],
                    [UIImage imageNamed:@"tab_3"],
    ];
    
    self.selectedImages = @[[UIImage imageNamed:@"tab_0_selected"],
                            [UIImage imageNamed:@"tab_1_selected"],
                            [UIImage imageNamed:@"tab_2_selected"],
                            [UIImage imageNamed:@"tab_3_selected"]];
    
    [self setTitleColor:[UIColor blackColor] andFont:[UIFont systemFontOfSize:14] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blueColor] andFont:[UIFont systemFontOfSize:14] forState:UIControlStateSelected];
    [self setTitlePositionAdjustment:UIOffsetZero andimageInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
