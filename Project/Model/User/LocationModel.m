//
//  LocationModel.m
//  SCGov
//
//  Created by solehe on 2019/8/23.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

+ (LocationModel *)defaultLocation {
    LocationModel *location = [[LocationModel alloc] init];
    [location setAreaName:@"四川省"];
    [location setAreaSimpleName:@"四川省"];
    [location setAreaCode:@"510000000000"];
    [location setAreaLevel:@(1)];
    return location;
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

@end
