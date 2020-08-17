//
//  LSLocationManager.h
//  Project
//
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LocationBlock)(BOOL isSuccess,double lan,double lon, NSString *cityName);
@interface LSLocationManager : NSObject

+ (instancetype)share;

- (void)startLocation:(LocationBlock)locationBlock;

+ (void)requestAuthorization;


//首页定位，判断是否要去更改
@end

NS_ASSUME_NONNULL_END
