//
//  NSObject+VC.h
//  SCGOV
//
//  Created by solehe on 2019/7/16.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VC)

// 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC;

// 检测相机权限
- (BOOL)allowUseCamera;

// 检测相册权限
- (BOOL)allowUseAlbum;

// 展示高斯模糊遮罩
- (void)showVisualEffectView;

// 移除高斯模糊遮罩
- (void)hiddenVisualEffectView;

@end

NS_ASSUME_NONNULL_END
