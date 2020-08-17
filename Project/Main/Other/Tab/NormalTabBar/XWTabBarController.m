//
//  XWTabBarController.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWTabBarController.h"
#import "NSArray+XWUtils.h"

@interface XWTabBarController ()
@property (nonatomic, assign) XWTabStyle style;
@property (nonatomic, assign) NSUInteger controllerCout;
@end

@implementation XWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor projectBackGroudColor]];
    self.tabBar.backgroundImage = XWImageName(@"tab_bg");
//    self.tabBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - interface methods
- (void)setTitleColor:(nullable UIColor *)color andFont:(nullable UIFont*)font forState:(UIControlState)state {
    for (NSInteger i = 0; i < self.controllerCout; i++) {
        UIViewController *viewController = self.viewControllers[i];
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} forState:state];
    }
}
- (void)setTitlePositionAdjustment:(UIOffset)offset andimageInsets:(UIEdgeInsets)inset
{
    for (NSInteger i = 0; i < self.controllerCout; i++) {
        UIViewController *viewController = self.viewControllers[i];
        viewController.tabBarItem.imageInsets = inset;
        [viewController.tabBarItem setTitlePositionAdjustment:offset];
    }
    
    //图片和title的偏移
    
}

- (instancetype)init {
    return [self initWithStyle:XWTabDefault];
}

- (instancetype)initWithStyle:(XWTabStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

#pragma mark - private methods

- (void)setImages:(NSArray *)images forState:(XWTabBarItemImageState)state {
    if (!(images && images.count > 0)) {
        return;
    }
    NSArray *tempArray = [NSArray fillArraySomeCount:self.controllerCout byOtherArray:images withPlaceholderObject:[NSNull null]];
    for (NSInteger i = 0; i < self.controllerCout; i++) {
        UIViewController *viewController = self.viewControllers[i];
        if (![tempArray[i] isKindOfClass:[UIImage class]]) {
            continue;
        }
        if (state == XWTabBarItemImageStateNormal) {
            viewController.tabBarItem.image = [tempArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (state == XWTabBarItemImageStateSelected) {
            viewController.tabBarItem.selectedImage = [tempArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        viewController.tabBarItem.tag = i;
    }
}

#pragma mark - getter and setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    if (!(titles && titles.count > 0)) {
        return;
    }
    //#warning 目前的逻辑必须使用者先设置self.viewControllers,不太好
    NSArray *tempArray = [NSArray fillArraySomeCount:self.controllerCout byOtherArray:titles withPlaceholderObject:@""];
    for (NSInteger i = 0; i < self.controllerCout; i++) {
        UIViewController *viewController = self.viewControllers[i];
        viewController.tabBarItem.title = tempArray[i];
    }
}

- (void)setImages:(NSArray *)images {
    _images = images;
    [self setImages:images forState:XWTabBarItemImageStateNormal];
}

- (void)setSelectedImages:(NSArray *)selectedImages {
    _selectedImages = selectedImages;
    [self setImages:selectedImages forState:XWTabBarItemImageStateSelected];
}

- (NSUInteger)controllerCout {
    return self.viewControllers.count;
}
@end
