//
//  Response.h
//  SCZW
//
//  Created by solehe on 2018/10/13.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseInfo;
NS_ASSUME_NONNULL_BEGIN

/**
 网络请求响应公用模型
 */
@interface Response : NSObject

@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,strong) id content;

@property (nonatomic,strong) ResponseInfo *responseInfo;
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSString * message;
@end

@interface ResponseInfo : NSObject
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSString * msg;
@end

NS_ASSUME_NONNULL_END
