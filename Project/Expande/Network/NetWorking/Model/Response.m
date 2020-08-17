//
//  Response.m
//  SCZW
//
//  Created by solehe on 2018/10/13.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import "Response.h"

@implementation Response

- (BOOL)isSuccess {
    return [self.responseInfo.code isEqualToString:@"100000"];
}

- (NSString *)code
{
    return self.responseInfo.code;
}

- (NSString *)message
{
    return self.responseInfo.msg;
}

- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    ResponseInfo *mjinfo = [[ResponseInfo alloc]init];
    [mjinfo mj_setKeyValues:info];
    self.responseInfo = mjinfo;
}

@end


@implementation ResponseInfo

- (NSString *)msg
{
    if(!_msg){
        _msg = @"";
    }
    return _msg;
}


@end
