//
//  LSRYUserInfo.h
//  Project
//  
//  Created by XuWen on 2020/4/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Realm/Realm.h>
#import <RongIMLib/RCUserInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSRYUserInfo : RLMObject

/*!
 用户ID 主键
 */
@property (nonatomic, copy) NSString *userId;

/*!
 用户名称
 */
@property (nonatomic, copy) NSString *name;

/*!
 用户头像的URL
 */
@property (nonatomic, copy) NSString *portraitUri;

/**
 用户信息附加字段
 */
@property (nonatomic, copy) NSString *extra;


/// 初始化操作
/// @param userInfo 融云的用户模型
- (instancetype)initWithUserInfo:(RCUserInfo *)userInfo;

// 存储一条记录
+ (void)addOrUpdate:(LSRYUserInfo *)model;

//查找更加主键（用户id）查找存储的用户
+ (RCUserInfo *)userInfoWithKey:(NSString *)primaryKey;

@end

NS_ASSUME_NONNULL_END
