//
//  NSObject+VC.m
//  SCGOV
//
//  Created by solehe on 2019/7/16.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import "NSObject+VC.h"

@implementation NSObject (VC)

// 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    //从根控制器开始查找
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activityVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activityVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activityVC = [(UITabBarController *)rootVC selectedViewController];
        } else if (rootVC.presentedViewController) {
            activityVC = rootVC.presentedViewController;
        } else {
            break;
        }
        
        rootVC = activityVC;
    }
    
    return activityVC;
}

// 检测相机权限
- (BOOL)allowUseCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return (status != AVAuthorizationStatusDenied);
}

// 检测相册权限
- (BOOL)allowUseAlbum {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return (status != PHAuthorizationStatusDenied);
}

// 展示高斯模糊遮罩
- (void)showVisualEffectView {

    UIImage *snapshotImage = [[UIApplication sharedApplication].delegate.window snapshotImage];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kSCREEN_BOUNDS];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setImage:[snapshotImage blurryImageWithBlurLevel:10]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView setTag:80191];
    [[UIApplication sharedApplication].delegate.window addSubview:imageView];
    
//    UIVisualEffectView *effectView = [UIView visualEffectView:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [effectView setAlpha:1.f];
//    [effectView setTag:80191];
//    [[UIApplication sharedApplication].delegate.window addSubview:effectView];
    
}

// 移除高斯模糊遮罩
- (void)hiddenVisualEffectView {
    UIView *effectView = [[UIApplication sharedApplication].delegate.window viewWithTag:80191];
    [UIView animateWithDuration:0.05 animations:^{
        [effectView setAlpha:0.f];
    } completion:^(BOOL finished) {
        [effectView removeFromSuperview];
    }];
}


@end
