//
//  VESTVIPVC.h
//  Project
//
//  Created by XuWen on 2020/9/12.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VESTVIPVC : LSBaseViewController

+ (NSString *)getTimeFromTimesTamp:(long)time;
+ (BOOL)isVIP;

//每天获得40能量
+ (void)getVIPCoins;

@end

NS_ASSUME_NONNULL_END
