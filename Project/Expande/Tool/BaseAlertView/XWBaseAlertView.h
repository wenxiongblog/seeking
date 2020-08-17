//
//  XWBaseAlertView.h
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XWBaseAlertViewStyle) {
    XWBaseAlertViewStyleCenter =0,
    XWBaseAlertViewStyleBottom
};

@interface XWBaseAlertView : UIView
/** 基础弹出视图*/
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
/** 初始化方法，默认占全屏*/
- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style;


/** 承载元素的view,需要上层确定坐标与大小*/
@property (nonatomic, strong, readonly) UIView *placeView;
/** 开始动画*/
- (void)appearAnimation;
/** 结束动画*/
- (void)disappearAnimation;

@end
