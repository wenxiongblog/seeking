//
//  LSBaseNavigationController.h
//  Project
//
//  Created by XuWen on 2020/1/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSBaseNavigationController : UINavigationController
<
    UIGestureRecognizerDelegate
>

// 是否开启侧滑返回
@property (nonatomic, assign) BOOL closeScrollBack;

// 将导航栏变成透明
- (void)barTransparent;
@end

NS_ASSUME_NONNULL_END
