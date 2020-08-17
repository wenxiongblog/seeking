//
//  LSRYUserInfo.m
//  Project
//
//  Created by XuWen on 2020/4/16.
//  Copyright © 2020 xuwen. All rights reserved.
//
            
#import "LSRYUserInfo.h"

@implementation LSRYUserInfo

+ (NSString *)primaryKey
{
    return @"userId";
}

- (instancetype)initWithUserInfo:(RCUserInfo *)userInfo
{
    self = [super init];
    if(self){
        self.userId = userInfo.userId;
        self.name = userInfo.name;
        self.portraitUri = userInfo.portraitUri;
        self.extra = userInfo.extra;
    }
    return self;
}

+ (NSArray <LSRYUserInfo *>*)userInfoArrayWithList:(NSArray<RCUserInfo *> *)users
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(RCUserInfo *model in users){
        [mutableArray addObject:model];
    }
    return [NSArray arrayWithArray:mutableArray];
}

//在数据库中获取对象
+ (RCUserInfo *)userInfoWithKey:(NSString *)primaryKey
{
    LSRYUserInfo *userInfo = [LSRYUserInfo objectForPrimaryKey:primaryKey];
    if(userInfo == nil){
        return nil;
    }else{
        RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userInfo.userId name:userInfo.name portrait:userInfo.portraitUri];
        user.extra = userInfo.extra;
        return user;
    }
}

//添加或者更新多个对象
//+ (void)addOrUpdateList:(NSArray <LSRYUserInfo *> *)modelList
//{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    // 开放RLMRealm事务
//    [realm beginWriteTransaction];
//    // 在开放开放/提交事务之间进行数据处理
//    [realm addOrUpdateObjects:modelList];
//    // 提交事务
//    [realm commitWriteTransaction];
//}

// 添加或者更新
+ (void)addOrUpdate:(LSRYUserInfo *)model {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开放RLMRealm事务
    [realm beginWriteTransaction];
    // 在开放开放/提交事务之间进行数据处理
    [realm addOrUpdateObject:[LSRYUserInfo newModel:model]];
    // 提交事务
    [realm commitWriteTransaction];
}

// 删除指定记录
+ (void)deleteWithModel:(LSRYUserInfo *)model {
    
    // 删除时只能使用从数据库中查出的对象
    LSRYUserInfo *m = [LSRYUserInfo objectForPrimaryKey:model.userId];
    if (m != nil) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 开放RLMRealm事务
        [realm beginWriteTransaction];
        // 在开放开放/提交事务之间进行数据处理
        [realm deleteObject:m];
        // 提交事务
        [realm commitWriteTransaction];
    }
}

// 清空所有
+ (void)clear {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 开放RLMRealm事务
    [realm beginWriteTransaction];
    // 在开放开放/提交事务之间进行数据处理
    [realm deleteAllObjects];
    // 提交事务
    [realm commitWriteTransaction];
}

+ (LSRYUserInfo *)newModel:(LSRYUserInfo *)model {
    
    if (!model) { return nil; }
    
    LSRYUserInfo *m = [[LSRYUserInfo alloc]init];
    [m setUserId:model.userId];
    [m setName:model.name];
    [m setPortraitUri:model.portraitUri];
    return m;
}



@end
