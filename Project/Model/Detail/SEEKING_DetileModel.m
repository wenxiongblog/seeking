//
//  SEEKING_DetileModel.m
//  Project
//
//  Created by XuWen on 2020/3/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "SEEKING_DetileModel.h"

@implementation SEEKING_DetileModel
+ (SEEKING_DetileModel *)createWithTitle:(NSString *)title subtitle:(NSString *)subtitle tags:(NSArray *)tags
{
    SEEKING_DetileModel *model = [[SEEKING_DetileModel alloc]init];
    model.type = 0;
    model.title = title;
    model.subTitle = subtitle;
    model.subArray = tags;
    return model;
}

+ (SEEKING_DetileModel *)createWithTitle:(NSString *)title subArray:(NSArray *)subarray;
{
    SEEKING_DetileModel *model = [[SEEKING_DetileModel alloc]init];
    model.type = 1;
    model.title = title;
    model.subArray = subarray;
    return model;
}

@end
