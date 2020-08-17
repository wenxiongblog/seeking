//
//  LSMessageBannerView.h
//  Project
//
//  Created by XuWen on 2020/3/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSMessageBannerView : UIView
@property (nonatomic,strong) UIButton *tapbutton;
+ (instancetype)createWithMessage:(RCMessage *)message;
@end

NS_ASSUME_NONNULL_END
