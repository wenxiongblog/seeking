//
//  NSObject+Networking.h
//  SCZW
//
//  Created by solehe on 2018/12/19.
//  Copyright © 2018 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFile.h"
#import "Response.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetEnryptType) {
    NetEnryptTypeNone,
    NetEnryptTypeAES,
    NetEnryptTypeRSA
};

@interface NSObject (Networking)

- (void)get:(NSString *)urlString
 cache:(BOOL)cache
 success:(void(^)(Response *response))success
       fail:(void(^)(NSError *error))fail;

/**
 POST网络请求（默认RSA加密、不缓存）
 
 @param urlString 请求地址
 @param params 请求参数
 @param success 请求成功回调
 @param fail 请求失败回调
 */
- (void)post:(NSString *)urlString
      params:(NSDictionary *)params
     success:(void(^)(Response *response))success
        fail:(void(^)(NSError *error))fail;


/**
 POST网络请求（是否加密和缓存）
 
 @param urlString 请求地址
 @param params 请求参数
 @param type 加密类型
 @param cache 是否缓存
 @param success 请求成功回调
 @param fail 请求失败回调
 */
//- (void)post:(NSString *)urlString
//      params:(NSDictionary *)params
//     encrypt:(NetEnryptType)type
//       cache:(BOOL)cache
//     success:(void(^)(Response *response))success
//        fail:(void(^)(NSError *error))fail;


/**
 POST网络请求（不加密、不缓存）

 @param urlString 请求地址
 @param params 请求参数
 @param encrypt 是否加密
 @param success 请求成功回调
 @param fail 请求失败回调
 */
//- (void)post:(NSString *)urlString
//      params:(NSDictionary *)params
//     encrypt:(BOOL)encrypt
//     success:(void(^)(NSDictionary *response))success
//        fail:(void(^)(NSError *error))fail;


/**
 上传文件数据

 @param urlString 请求地址
 @param params 请求参数
 @param files 文件数据
 @param progress 上传进度
 @param success 请求成功回调
 @param fail 请求失败回调
 */
- (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
         files:(NSArray<UploadFile *> *)files
       encrypt:(NSInteger)type
      progress:(void(^)(float progress))progress
       success:(void(^)(Response *response))success
          fail:(void(^)(NSError *error))fail;


@end

NS_ASSUME_NONNULL_END
