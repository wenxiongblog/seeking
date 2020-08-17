//
//  LSHomeHeaderView.h
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSHomeHeaderView : UIView

// 男女？
@property (nonatomic,assign) BOOL isMan;


- (void)popJumpAnimationView;
// 开始动画？
- (void)startAnimation;

// 暂停动画？
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
