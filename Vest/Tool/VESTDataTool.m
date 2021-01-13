//
//  VESTDataTool.m
//  Project
//
//  Created by XuWen on 2020/9/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTDataTool.h"

@implementation VESTDataTool
+ (NSArray *)allYuyinUser
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"yuyin.json" ofType:@""];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *listArray = dict[@"data"];
    
    return [VESTUserModel mj_objectArrayWithKeyValuesArray:listArray];
}

+ (NSArray *)allShiPinUser
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shipin.json" ofType:@""];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *listArray = dict[@"data"];
    
    return [VESTUserModel mj_objectArrayWithKeyValuesArray:listArray];
}

@end
