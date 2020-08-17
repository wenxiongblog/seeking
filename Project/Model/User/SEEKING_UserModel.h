//
//  SEEKING_UserModel.h
//  Project
//
//  Created by XuWen on 2020/2/14.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "SEEKING_Customer.h"
#import "LocationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface SEEKING_UserModel : SEEKING_Customer

//@property (nonatomic, strong) NSString *rongyunUserID;
// 单例
+ (instancetype)share;

@property (nonatomic, assign) BOOL isVIP;

@property (nonatomic, assign) NSInteger abTest;

// 信息完善程度
@property (nonatomic, assign) int infoPersent;
//是否登录
@property (nonatomic, assign) BOOL isLogin;
//地理位置
@property (nonatomic,strong) LocationModel *location;
//用于标记
@property (nonatomic,assign) BOOL isZhuce; //是否是注册流程



//我匹配的用户持久化数组
@property (nonatomic,strong) NSArray *matchArray;

//存储用户信息
- (void)synchronize;
//清除用户信息
- (void)clear;

#pragma mark - data
- (void)updateUserInfo:(NSDictionary *)dict complete:(void(^)(BOOL Success,NSString *msg))complete;

@end

NS_ASSUME_NONNULL_END
