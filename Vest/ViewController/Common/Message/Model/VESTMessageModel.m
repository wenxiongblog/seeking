//
//  VESTMessageModel.m
//  Project
//  
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTMessageModel.h"

@implementation VESTMessageModel

+ (VESTMessageModel *)createMsgWithUser:(VESTUserModel *)user direction:(BOOL)direction text:(NSString *)text
{
    VESTMessageModel *model = [[VESTMessageModel alloc]init];
    model.name = user.name;
    model.headUrl = user.headUrl;
    model.age = user.age;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    //设置时区
    NSDate *datenow = [NSDate date];
    NSString *strDate = [formatter stringFromDate:datenow];
    model.time = strDate;
    
    model.direction = direction;
    model.text = text;
    return model;
}

-(NSDictionary *)toJson
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i++) {
        const char *cname = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:cname];
        NSString *key = [name substringFromIndex:1];
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSString class]]&&[(NSString*)value length]) {
            [params setValue:value forKey:key];
        }
    }
    return params;
}

#pragma mark-------NSCoding,归接档协议,运行时

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i++) {
        const char *cname = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:cname];
        NSString *key = [name substringFromIndex:1];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        unsigned  int count = 0;
        Ivar *ivars = class_copyIvarList(self.class, &count);
        
        for (int i = 0; i < count; i++) {
            const char *cname = ivar_getName(ivars[i]);
            NSString *name = [NSString stringWithUTF8String:cname];
            NSString *key = [name substringFromIndex:1];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    
    for (int i = 0; i < count; i++) {
        const char *cname = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:cname];
        NSString *key = [name substringFromIndex:1];
        id value = [self valueForKey:key];
        [copy setValue:value forKey:key];
    }
    return copy;
}

@end
