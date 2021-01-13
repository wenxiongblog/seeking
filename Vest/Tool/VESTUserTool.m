//
//  VESTUserTool.m
//  Project
//
//  Created by XuWen on 2020/9/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTUserTool.h"

#define kHeadKey @"headKey"

@implementation VESTUserTool

//保存用户年龄
+ (void)saveAge:(NSInteger)age
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:age forKey:@"kUserAge"];
}
//获取用户年龄
+ (NSInteger)age
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSInteger age = [preferences integerForKey:@"kUserAge"];
    if(age < 18){
        return 18;
    }else{
        return age;
    }
}


//保存用户性别
+ (void)saveSex:(NSString *)sex
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:sex forKey:@"kUserSex"];
}
//获取用户性别
+ (NSString *)sex
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString * sex = [preferences objectForKey:@"kUserSex"];
    if(sex.length > 0){
        return sex;
    }else{
        return nil;
    }
}



//保存用户姓名
+ (void)saveAccount:(NSString *)account
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:account forKey:@"kUseraccount"];
}

//获取用户姓名
+ (NSString *)account
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString * account = [preferences objectForKey:@"kUseraccount"];
    if(account.length > 0){
        return account;
    }else{
        return nil;
    }
}




//保存用户密码
+ (void)savePassword:(NSString *)password
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:password forKey:@"kUserpassword"];
}

//获取用户密码
+ (NSString *)password
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString * password = [preferences objectForKey:@"kUserpassword"];
    if(password.length > 0){
        return password;
    }else{
        return nil;
    }
}


//保存用户姓名
+ (void)saveName:(NSString *)name
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:name forKey:@"kUserName"];
}

//获取用户姓名
+ (NSString *)name
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString * name = [preferences objectForKey:@"kUserName"];
    if(name.length > 0){
        return name;
    }else{
        return @"Test Name";
    }
}



//本地保存图片
+ (void)SaveHeadImageToLocal:(UIImage*)image{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:kHeadKey];
}

//从本地获取图片
+ (UIImage*)GetHeadImageFromLocal{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:kHeadKey];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}


@end
