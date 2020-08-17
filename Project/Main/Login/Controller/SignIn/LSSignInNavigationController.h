//
//  LSSignInNavigationController.h
//  Project
//
//  Created by XuWen on 2020/3/31.
//  Copyright © 2020 xuwen. All rights reserved.
//
    
#import "LSBaseNavigationController.h"
#import "LSSignUpBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSSignInNavigationController : LSBaseNavigationController
@property (nonatomic, copy) void(^loginResultBlock)(BOOL success);

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController Complete:(void(^)(BOOL success))block;

//去完善信息
+ (LSSignUpBaseVC *)gofinishInfoVC;
@end

NS_ASSUME_NONNULL_END
