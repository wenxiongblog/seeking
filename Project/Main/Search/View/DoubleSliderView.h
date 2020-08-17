//
//  DoubleSliderView.h
//  DoubleSliderView-OC
//
//  Created by 杜奎 on 2019/1/13.
//  Copyright © 2019 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleSliderView : UIView

@property (nonatomic, assign) CGFloat curMinValue;//当前最小的值
@property (nonatomic, assign) CGFloat curMaxValue;//当前最大的值
@property (nonatomic, assign) BOOL needAnimation;//是否需要动画
@property (nonatomic, assign) CGFloat minInterval;//间隔大小

//滑动回调
@property (nonatomic, copy)   void (^sliderBtnLocationChangeBlock)(BOOL isLeft, BOOL finish);//滑块位置改变后的回调 isLeft 是否是左边 finish手势是否结束

//颜色设置
@property (nonatomic, strong) UIColor *minTintColor;
@property (nonatomic, strong) UIColor *midTintColor;
@property (nonatomic, strong) UIColor *maxTintColor;


@property (nonatomic,assign) CGFloat initMinValue;
@property (nonatomic,assign) CGFloat initMaxValue;


- (void)changeLocationFromValue;

@end

