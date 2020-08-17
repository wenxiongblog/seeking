//
//  NSObject+Networking.m
//  SCZW
//
//  Created by solehe on 2018/12/19.
//  Copyright © 2018 solehe. All rights reserved.
//

#import <Bugly/Bugly.h>
#import "NSObject+Networking.h"
#import "LSHttpClient.h"


// 授权码失效代码
#define kInvalidCode    @"4002"
// 超时重试次数
#define kTimeOutRetry   5

@implementation NSObject (Networking)
    
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
        fail:(void(^)(NSError *error))fail {
    
    @weak(self)
    [LSHttpClient postWithUrl:urlString refreshRequest:NO cache:NO encrypt:NetEnryptTypeNone retry:kTimeOutRetry params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id _Nonnull response) {
        
        NSString *str = (NSString *)response;
        NSDictionary *responseDict = [str josnToDictionary];
        NSDictionary *dict = [responseDict objectForKey:@"response"];
        Response *res = [Response mj_objectWithKeyValues:dict];
        
        success(res);
        
    } failBlock:^(NSError * _Nonnull error) {
        // 解析并展示错误信息
//        [weakself showError:error url:urlString];
        // 回调返回
        fail(error);
    }];
}

/**
 get 网络请求
 */

- (void)get:(NSString *)urlString
        cache:(BOOL)cache
        success:(void(^)(Response *response))success
       fail:(void(^)(NSError *error))fail {
  
    [LSHttpClient get:urlString cache:cache success:^(Response *response) {
        Response *res = [Response mj_objectWithKeyValues:response];
        success(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

/**
 POST网络请求（是否加密和缓存）
 
 @param urlString 请求地址
 @param params 请求参数
 @param type 加密类型
 @param cache 是否缓存
 @param success 请求成功回调
 @param fail 请求失败回调
 */
- (void)post:(NSString *)urlString
      params:(NSDictionary *)params
     encrypt:(NetEnryptType)type
       cache:(BOOL)cache
     success:(void(^)(Response *response))success
        fail:(void(^)(NSError *error))fail {
    
    @weak(self)
    [LSHttpClient postWithUrl:urlString refreshRequest:YES cache:cache encrypt:type retry:kTimeOutRetry params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id _Nonnull response) {
        Response *res = [Response mj_objectWithKeyValues:response];
        success(res);
        
    } failBlock:^(NSError * _Nonnull error) {
        
        // 解析并展示错误信息
        [weakself showError:error url:urlString];
        // 回调返回
        fail(error);
    }];
}


/**
 POST网络请求（不加密、不缓存）
 
 @param urlString 请求地址
 @param params 请求参数
 @param encrypt 是否加密
 @param success 请求成功回调
 @param fail 请求失败回调
 */
- (void)post:(NSString *)urlString
      params:(NSDictionary *)params
     encrypt:(BOOL)encrypt
     success:(void(^)(NSDictionary *response))success
        fail:(void(^)(NSError *error))fail {
    
    @weak(self)
    [LSHttpClient postWithUrl:urlString refreshRequest:YES cache:NO encrypt:NetEnryptTypeNone retry:kTimeOutRetry params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id _Nonnull response) {
        
        success([[response stringByReplacingOccurrencesOfString:@",\"\"" withString:@""] josnToDictionary]);
        
    } failBlock:^(NSError * _Nonnull error) {
        
        // 解析并展示错误信息
        [weakself showError:error url:urlString];
        
        // 回调返回
        fail(error);
    }];
}

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
          fail:(void(^)(NSError *error))fail {
    
    @weak(self)
    [LSHttpClient uploadFileWithUrl:urlString params:params files:files encrypt:type progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(1.0 * bytesWritten / totalBytes);
            }
        });
        
    } successBlock:^(id  _Nonnull response) {
        
        Response *res = [Response mj_objectWithKeyValues:response[@"response"]];
        
        // Token过期处理
        if ([res.code isEqualToString:kInvalidCode]){
            
            // 先更新token再重新请求
//            [weakself refreshToken:^(BOOL valid) {
//                if (valid) {
//                    [weakself upload:urlString params:params files:files encrypt:type progress:progress success:success fail:fail];
//                } else {
//                    // 返回结果
//                    success(res);
//                }
//            }];
        } else {
            // 返回结果
            success(res);
        }
        
    } failBlock:^(NSError * _Nonnull error) {
        
        // 解析并展示错误信息
        [weakself showError:error url:urlString];
        
        // 回调返回
        fail(error);
    }];
}

#pragma mark -

// 错误处理
- (void)showError:(NSError *)error url:(NSString *)urlString {

    if (error.code == NSURLErrorCancelled) {  // 取消重复请求
        return;
    }
#ifndef DEBUG
//    else if (error.code == NSURLErrorTimedOut) {  // 网络超时处理
//        NSString *urlSubffix = [urlString stringByReplacingOccurrencesOfString:BASE_URL withString:@"/"];
//        NSString *errMsg = [NSString stringWithFormat:@"网络超时：%@ - %@ - %@ - %@ - %@", [AppUtils networkingType], [HttpClient netwrokingStatus], [AppUtils iphoneType], urlSubffix, [AppUtils deviceId]];
//        [Bugly reportError:[NSError errorWithDomain:errMsg code:-1001 userInfo:nil]];
//        Log(@"%@", errMsg);
//    } else {
//        [Bugly reportError:error];
//    }
#endif
    
    // 错误详情
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if (data != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"status"] integerValue] != 404) {
            if ([dict[@"message"] length] > 0) {
                [AlertView toast:dict[@"message"] inView:theAppDelegate.window];
            } else if ([dict[@"msg"] length] > 0) {
                [AlertView toast:dict[@"msg"] inView:theAppDelegate.window];
            } else {
                [AlertView toast:@"Request error" inView:theAppDelegate.window];
            }
        }
        Log(@"请求出错：%@", dict);
    } else {
        [AlertView toast:@"Request error" inView:theAppDelegate.window];
    }
}


// Token过期处理
/*
- (void)refreshToken:(void(^)(BOOL valid))block {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"authClient"] = [KAuthClient base64String];
    params[@"refreshToken"] = [UserModel share].refreshToken;

    [HttpClient postWithUrl:Refresh refreshRequest:YES cache:NO encrypt:NetEnryptTypeRSA retry:kTimeOutRetry params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
    } successBlock:^(id  _Nonnull response) {
        
        Response *res = [Response mj_objectWithKeyValues:response];
        
        if (res.isSuccess) {
            
            [[UserModel share] mj_setKeyValues:res.data];
            [[UserModel share] synchronize];
            
            block(YES);
            
        } else {
            
            [[UserModel share] setIsLogin:@NO];
            [JumpUtils loginModel:(LoginType)[UserModel share].userType complete:^(BOOL success) {
                block(success);
            }];
        }
        
    } failBlock:^(NSError * _Nonnull error) {
        block(NO);
    }];
}
*/


@end
