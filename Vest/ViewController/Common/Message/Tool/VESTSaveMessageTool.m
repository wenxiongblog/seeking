//
//  VESTSaveMessageTool.m
//  Project
//
//  Created by XuWen on 2020/9/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTSaveMessageTool.h"

@implementation VESTSaveMessageTool

+ (void)saveMessage:(VESTMessageModel *)message WithKey:(NSString *)key;
{
    NSMutableArray *array =  [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:key]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [array addObject:data];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:key];
}

+ (NSArray <VESTMessageModel *>*)getMessageWithKey:(NSString *)key
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSMutableArray *messageArray = [NSMutableArray array];
    for(NSData *data in array){
        VESTMessageModel *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [messageArray addObject:message];
    }
    return messageArray;
}

+ (NSArray <VESTMessageModel *>*)getAllConversation
{
    NSArray *conversation1 = [self getMessageWithKey:@"Neiro"];
    NSArray *conversation2 = [self getMessageWithKey:@"Mabbsy"];
    NSArray *conversation3 = [self getMessageWithKey:@"Lrina"];
    NSMutableArray *array = [NSMutableArray array];
    if(conversation1.count > 0){
        [array addObject:conversation1.lastObject];
    }
    if(conversation2.count > 0){
        [array addObject:conversation2.lastObject];
    }
    if(conversation3.count > 0){
        [array addObject:conversation3.lastObject];
    }
    return array;
}

@end
