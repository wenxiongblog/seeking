//
//  VESTTabBarVC.m
//  Project
//
//  Created by XuWen on 2020/9/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTTabBarVC.h"
#import "VESTTabBar.h"

#import "VESTOneVC.h"
#import "VESTTwoVC.h"
#import "VESTThreeVC.h"
#import "VESTFourVC.h"

@interface VESTTabBarVC ()<VESTTabBarDelegate>
/** 所有子控制器的tabBarItem*/
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) VESTTabBar *myTabBar;
@end

@implementation VESTTabBarVC

+ (void)jumpVESTTabVC
{
       VESTTabBarVC *tabBar = [[VESTTabBarVC alloc]init];
       CATransition *transtition = [CATransition animation];
       transtition.duration = 0.3;
       transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
       [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
       [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray array];
    [self setChildVC];
    [self setUpTabBar];
    [self selectedItemWithIndex:0];
}

- (void)setChildVC
{
    NSMutableArray * controllerArr = [NSMutableArray array];
    //1
    VESTOneVC *VC1 = [[VESTOneVC alloc] init];
    //2
    VESTTwoVC *VC2 = [[VESTTwoVC alloc] init];
    //3
    VESTThreeVC *VC3 = [[VESTThreeVC alloc] init];
    //4
    VESTFourVC *VC4 = [[VESTFourVC alloc] init];
    
    [controllerArr addObject:[self setOneChildViewController:VC1 withImage:[UIImage imageNamed:@"vest_tab_1"] selectedImage:[UIImage imageNamed:@"vest_tab_1"] title:@"1"]];
    [controllerArr addObject:[self setOneChildViewController:VC2 withImage:[UIImage imageNamed:@"vest_tab_2"] selectedImage:[UIImage imageNamed:@"vest_tab_2"] title:@"2"]];
    [controllerArr addObject:[self setOneChildViewController:VC3 withImage:[UIImage imageNamed:@"vest_tab_3"] selectedImage:[UIImage imageNamed:@"vest_tab_3"] title:@"3"]];
    [controllerArr addObject:[self setOneChildViewController:VC4 withImage:[UIImage imageNamed:@"vest_tab_4"] selectedImage:[UIImage imageNamed:@"vest_tab_4"] title:@"4"]];
    self.viewControllers = controllerArr;
}

- (void)setUpTabBar
{
    self.myTabBar = [[VESTTabBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTabbarHeight)];
    self.myTabBar.delegate = self;
    //设置为透明
    for(UIView *subViews in self.tabBar.subviews){
        subViews.alpha = 0.0;
    }
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    //items
    self.myTabBar.items = self.items;
    [self.tabBar addSubview:self.myTabBar];
    [self.tabBar bringSubviewToFront:self.myTabBar];
}

#pragma mark private
- (UINavigationController *)setOneChildViewController:(UIViewController *)viewController withImage:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    viewController.title = title;
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    [self.items addObject:viewController.tabBarItem];
    UINavigationController *nvg = [[UINavigationController alloc] initWithRootViewController:viewController];
    return nvg;
}

#pragma mark - VESTTabBarDelegate
- (void)tabBar:(VESTTabBar *)tabBar didSelectedItemFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

- (void)selectedItemWithIndex:(NSInteger)index
{
    self.myTabBar.seletedIndex = index;
}
@end
