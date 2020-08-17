//
//  SEEKING_FilterModel.m
//  Project
//
//  Created by XuWen on 2020/3/19.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "SEEKING_FilterModel.h"

@implementation SEEKING_FilterModel

static SEEKING_FilterModel *__singletion;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [self fetchFilterModel];
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
                [self setValue:value forKey:strName];
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

+ (SEEKING_FilterModel *)fetchFilterModel
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"FilterModel"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)synchronize {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[SEEKING_FilterModel share]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"FilterModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)clear {
    __singletion = [[SEEKING_FilterModel alloc] init];
    [self synchronize];
}

- (NSString *)startage
{
    if(_startage == nil){
        return @"18";
    }else{
        return _startage;
    }
}

- (NSString *)endage
{
    if(_endage == nil){
        return @"60";
    }else{
        return _endage;
    }
}

@end
