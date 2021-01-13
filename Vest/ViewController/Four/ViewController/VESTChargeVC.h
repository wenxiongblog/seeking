//
//  VESTChargeVC.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VESTChargeVC : LSBaseViewController
+ (NSInteger)currentCoins;

//购买
+ (void)addCoins:(NSInteger)coins;
//消费
+ (BOOL)costCoins:(NSInteger)coins;
@end

NS_ASSUME_NONNULL_END
