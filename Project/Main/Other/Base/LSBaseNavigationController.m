//
//  LSBaseNavigationController.m
//  Project
//
//  Created by XuWen on 2020/1/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseNavigationController.h"

@interface LSBaseNavigationController ()

@end

@implementation LSBaseNavigationController

- (instancetype)init
{
    self = [super init];
    if(self){
//        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 解决侧滑返回失效
    [self.interactivePopGestureRecognizer setDelegate:self];
    
//    UIImage *image = [[UIColor whiteColor] imageWithSize:CGSizeMake(SCREEN_WIDTH, 44)];
//    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium]};
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setTranslucent:NO];
}

/**
 重写该方法，自定义push到下级页面的返回按钮
 
 @param viewController 下级页面
 @param animated 动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    [self setNavigationBarHidden:NO animated:YES];
    
    if (![self.viewControllers[0] isEqual:viewController]) {
        //修改返回按钮
        [viewController customNaviBackItem:@"公用-返回"];
    }
}

#pragma mark - 解决侧滑返回失效
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return !self.closeScrollBack;
}

// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 将导航栏变成透明
- (void)barTransparent {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 其他
//状态栏为ViewController中设定值
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.viewControllers lastObject].preferredStatusBarStyle;
}


@end
