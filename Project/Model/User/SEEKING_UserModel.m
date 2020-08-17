//
//  SEEKING_UserModel.m
//  Project
//  
//  Created by XuWen on 2020/2/14.
//  Copyright © 2020 xuwen. All rights reserved.
//
     
#import "SEEKING_UserModel.h"
#import "LSPurchaseManager.h"
    
@implementation SEEKING_UserModel
    
static SEEKING_UserModel *__singletion;
    
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [self fetchUserModel];
        if (__singletion == nil) {
            __singletion = [[self alloc] init];
        }
    });
    return __singletion;
}

#pragma mark - 归档、解档
- (void)encodeWithCoder:(NSCoder *)encoder {
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [self valueForKey:strName];
            [encoder encodeObject:value forKey:strName];
        }
        free(ivar);
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int count = 0;
            //获取类中所有成员变量名
            Ivar *ivar = class_copyIvarList(class, &count);
            for (int i = 0; i < count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                //进行解档取值
                id value = [decoder decodeObjectForKey:strName];
                //利用KVC对属性赋值
                if(value != nil){
                    [self setValue:value forKey:strName];
                }
            }
            free(ivar);
            class = class_getSuperclass(class);//记住还要遍历父类的属性呢
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [[self valueForKey:strName] copy];//如果还套了模型也要copy呢
            [obj setValue:value forKey:strName];
        }
        free(ivar);
        
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
    return obj;
}

// 获取存储的用户信息
+ (SEEKING_UserModel *)fetchUserModel {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Dating_user_model"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

// 保存用户信息
- (void)synchronize {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[SEEKING_UserModel share]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Dating_user_model"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 清除用户信息
- (void)clear {
    
    // 新建用户(保留定位数据)
    LocationModel *model = [SEEKING_UserModel share].location;
    __singletion = [[SEEKING_UserModel alloc] init];
    [__singletion setLocation:model];
    
    [self synchronize];
}

#pragma mark - data
- (void)updateUserInfo:(NSDictionary *)dict complete:(void(^)(BOOL Success,NSString *msg))complete
{
    [self post:kURL_UpdateUserInfo params:dict success:^(Response * _Nonnull response) {
           if(response.isSuccess){
               NSDictionary *dict = [response.content objectForKey:@"outuser"];
               [kUser mj_setKeyValues:dict];
               [kUser synchronize];
               complete(YES,@"");
           }else{
               complete (NO,response.message);
           }
       } fail:^(NSError * _Nonnull error) {
           complete (NO,@"");
       }];
}



#pragma mark - setter & getter1
- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [self synchronize];
}

- (BOOL)isVIP
{
    return [LSPurchaseManager isVIP];
}

- (int)infoPersent
{
    int persent = 0;
    if(self.about.length > 0){
        persent = persent + 9;
    }
    if(self.school.length > 0){
        persent = persent + 9;
    }
    if(self.job.length > 0){
        persent = persent + 9;
    }
    if(![self.needfor isEqualToString:@"Secrete"]||![self.needfor isEqualToString:@"保密"]){
        persent = persent + 9;
    }
    if(self.kid.length > 0){
        persent = persent + 9;
    }
    if(self.pet.length > 0){
        persent = persent + 9;
    }
    if(self.belief.length > 0){
        persent = persent + 9;
    }
    if(self.bodyType.length > 0){
        persent = persent + 9;
    }
    if(self.drinking.length > 0){
        persent = persent + 9;
    }
    if(self.smoking.length > 0){
        persent = persent + 9;
    }
    if(self.diet.length > 0){
        persent = persent + 10;
    }
    return persent;
}

- (void)setMatchArray:(NSArray *)matchArray
{
    NSMutableArray *array = [NSMutableArray array];
    for(SEEKING_Customer *customer in matchArray){
        [array addObject:customer.conversationId];
    }
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"KUserDefalte_matchArray"];
}

- (NSArray *)matchArray
{
    NSArray *array = [[NSUserDefaults standardUserDefaults]arrayForKey:@"KUserDefalte_matchArray"];
    return array;
}


- (void)setAbTest:(NSInteger)abTest
{
    [[NSUserDefaults standardUserDefaults]setInteger:abTest forKey:@"kABtest"];
}

- (NSInteger)abTest
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"kABtest"];
}


@end
