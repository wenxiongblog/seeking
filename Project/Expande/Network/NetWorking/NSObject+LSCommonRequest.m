//
//  NSObject+LSCommonRequest.m
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "NSObject+LSCommonRequest.h"
#import "SEEKING_Customer.h"

@implementation NSObject (LSCommonRequest)
#pragma mark - 公共请求
- (void)postUserWithID:(NSString *)userID complete:(void(^)(SEEKING_Customer *customer))complete
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setNullObject:kUser.id forKey:@"userid" replaceObject:@"1"];
    [params setNullObject:userID forKey:@"id"];
    [self post:KURL_DetailInfo params:params success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            SEEKING_Customer *customer = [SEEKING_Customer mj_objectWithKeyValues:response.content[@"outuser"]];
            complete(customer);
        }
    } fail:^(NSError * _Nonnull error) {
        complete(nil);
    }];
}

@end
