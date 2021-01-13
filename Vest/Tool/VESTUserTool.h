//
//  VESTUserTool.h
//  Project
//
//  Created by XuWen on 2020/9/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESTUserTool : NSObject

//保存用户年龄
+ (void)saveAge:(NSInteger)age;
//获取用户年龄
+ (NSInteger)age;

//保存用户性别
+ (void)saveSex:(NSString *)sex;
//获取用户性别
+ (NSString *)sex;


//保存用户姓名
+ (void)saveAccount:(NSString *)account;
//获取用户姓名
+ (NSString *)account;


//保存用户密码
+ (void)savePassword:(NSString *)password;
//获取用户密码
+ (NSString *)password;



//保存用户姓名
+ (void)saveName:(NSString *)name;
//获取用户姓名
+ (NSString *)name;

//保存用户头像
+ (void)SaveHeadImageToLocal:(UIImage*)image;
//获取用户头像
+ (UIImage*)GetHeadImageFromLocal;
@end

NS_ASSUME_NONNULL_END
