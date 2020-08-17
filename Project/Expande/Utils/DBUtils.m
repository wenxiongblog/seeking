//
//  DBUtils.m
//  Project
//
//  Created by XuWen on 2020/4/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Realm/Realm.h>
#import "DBUtils.h"

@implementation DBUtils

// 配置数据库
+ (void)configuration {
    // 设置数据库版本号，如果有字段更改需要升级改设置
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    //设置新的架构版本。这个版本号必须高于之前所用的版本号(如果您之前从未设置过架构版本，那么这个版本号设置为0)
    config.schemaVersion = 0;
    //设置闭包，这个闭包将会在打开低于上面所设置版本号的Realm数据库的时候被自动调用
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        //目前我们还未进行数据迁移，因此oldSchemaVersion == 0
        if (oldSchemaVersion < config.schemaVersion) {
            //什么都不要做! Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
        }
    };
    //告诉Realm 为默认的Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:config];
    //现在我们已经告诉了Realm如何处理架构的变化，打开文件之后将会自动执行迁移
    [RLMRealm defaultRealm];
}


@end
