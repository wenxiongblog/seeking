//
//  LSHttpClient.m
//  Project
//
//  Created by XuWen on 2020/3/24.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSHttpClient.h"
#import "Networking+RequestManager.h"
#import "CacheManager.h"
#import "AESCipher.h"
#import "RSAEncryptor.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Bugly/Bugly.h>


#define _ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define _ERROR [NSError errorWithDomain:@"com.sczw.Networking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;

static NetworkStatus    networkStatus;

static NSTimeInterval   requestTimeout = 10.f;

@implementation LSHttpClient


+ (AFHTTPSessionManager *)manager {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    [self checkNetworkStatus];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[CacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[CacheManager shareManager] clearLRUCache];
    
    return manager;
}

+ (AFHTTPSessionManager *)httpManager {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    [self checkNetworkStatus];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[CacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[CacheManager shareManager] clearLRUCache];
    
    return manager;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = NetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = NetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = NetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = NetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = NetworkStatusUnknown;
                break;
        }
    }];
}

/**
 * 当前网络状态
 */
+ (NSString *)netwrokingStatus {
    switch (networkStatus) {
        case NetworkStatusNotReachable:
            return @"无网络";
        case NetworkStatusReachableViaWWAN:
            return @"流量";
        case NetworkStatusReachableViaWiFi:
            return @"WiFi";
        default:
            return @"未知";
    }
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}

#pragma mark - get
+ (URLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(GetProgress)progressBlock
                    successBlock:(ResponseSuccessBlock)successBlock
                       failBlock:(ResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block URLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == NetworkStatusNotReachable) {
        if (failBlock) failBlock(_ERROR);
        return session;
    }
    
    id responseObj = [[CacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    
    session = [manager GET:url
                parameters:params
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                                       downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) successBlock(responseObject);
                      
                      if (cache) [[CacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                      
                      [[self allTasks] removeObject:session];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) failBlock(error);
                      [[self allTasks] removeObject:session];
                      
                  }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        //取消新请求
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        URLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark - post

/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          解释同上
 *  @param type             加密类型
 *  @param retry            重试次数
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+ (void)postWithUrl:(NSString *)url
     refreshRequest:(BOOL)refresh
              cache:(BOOL)cache
            encrypt:(NSInteger)type
              retry:(NSInteger)retry
             params:(NSDictionary *)params
      progressBlock:(PostProgress)progressBlock
       successBlock:(ResponseSuccessBlock)successBlock
          failBlock:(ResponseFailBlock)failBlock {
 
    Log(@"请求地址: %@ \n传入参数: %@", url, params);
    
    __block URLSessionTask *session = nil;
    
    //1.网络manager的配置
    AFHTTPSessionManager *manager = [self manager];
    
    //2.判断是否有网络
    if (networkStatus == NetworkStatusNotReachable) {
        if (failBlock) failBlock(_ERROR);
    }
    //3.尝试去取缓存数据
    id responseObj = [[CacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    
    //4.组装请求头 添加token信息和header新
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self packagRequest:request];
    
    //4.2 组装请求体
    NSString *reqtime = [NSDate getNowTimeTimestamp3];
    NSString *action = [url componentsSeparatedByString:@"/"].lastObject;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *requstDict = [NSMutableDictionary dictionary];
    NSDictionary *commonDict = @{
        @"action":action,
        @"reqtime":reqtime,
    };
    [requstDict setObject:commonDict forKey:@"common"];
    [requstDict setObject:params forKey:@"content"];
    [paramDict setObject:requstDict forKey:@"request"];
    
    NSString *string = [paramDict DataTOjsonString];
    NSLog(@"🔥🔥请求的参数🔥🔥\n%@",string);
    
    
    //5.添加参数 是否加密
    __weak typeof(self) weakSelf = self;
    [self packagBody:paramDict encrypt:type result:^(NSData *data, NSString *key, NSDictionary *dict) {
        
        // 设置请求body
        [request setHTTPBody:data];
        
        // 因为request是自定义的，因此需要在这里重新设置超时时间
        [request setTimeoutInterval:requestTimeout];
        
        // 发起请求
        session = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (error == nil) {
                
                // 解析数据
                [weakSelf analyse:responseObject encrypt:type key:key result:^(NSString *result) {
                    if (successBlock) { successBlock(result); }
                    Log(@"请求结果: %@", result);
                }];
                
                // 缓存数据
                if (cache) [[CacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                
                // 请求结束，从缓存队列中移除
                if ([[weakSelf allTasks] containsObject:session]) {
                    [[weakSelf allTasks] removeObject:session];
                }
                
            } else {
                
                // 失败重试
                if (error.code == NSURLErrorTimedOut && retry > 0) {
                    
                    [weakSelf postWithUrl:url refreshRequest:refresh cache:cache encrypt:type retry:retry-1 params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];

#ifndef DEBUG
//                    // 上报超时日志（后面可取消，截止时间2019-11-30 00:00:00）
//                    if ([[NSDate date] timeIntervalSince1970] <= 1575043200) {
//                        NSString *urlSubffix = [url stringByReplacingOccurrencesOfString:BASE_URL withString:@"/"];
//                        NSString *errMsg = [NSString stringWithFormat:@"网络超时：%@ - %@ - %@ - %@ - %@", [AppUtils networkingType], [HttpClient netwrokingStatus], [AppUtils iphoneType], urlSubffix, [AppUtils deviceId]];
//                        [Bugly reportError:[NSError errorWithDomain:errMsg code:-1001 userInfo:nil]];
//                    }
#endif
                    
                } else {
                    if (failBlock) failBlock(error);
                }
                
                [[weakSelf allTasks] removeObject:session];
            }
        }];
        
        if ([weakSelf haveSameRequestInTasksPool:session] && !refresh) {
            [session cancel];
        } else {
            URLSessionTask *oldTask = [weakSelf cancleSameRequestInTasksPool:session];
            if (oldTask) [[weakSelf allTasks] removeObject:oldTask];
            if (session) [[weakSelf allTasks] addObject:session];
            [session resume];
        }
    }];
}

/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param files            上传文件数据
 *  @param type             加密方式
 *  @param progressBlock    上传文件进度
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+ (void)uploadFileWithUrl:(NSString *)url
                             params:(id)params
                               files:(NSArray<UploadFile *> *)files
                             encrypt:(NSInteger)type
                          progressBlock:(UploadProgressBlock)progressBlock
                           successBlock:(ResponseSuccessBlock)successBlock
                              failBlock:(ResponseFailBlock)failBlock {
    __block URLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self httpManager];
    
    // 使用普通Http响应
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (networkStatus == NetworkStatusNotReachable) {
        if (failBlock) failBlock(_ERROR);
    }
    
    
    //4.2 组装请求体
    NSString *reqtime = [NSDate getNowTimeTimestamp3];
    NSString *action = [url componentsSeparatedByString:@"/"].lastObject;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *requstDict = [NSMutableDictionary dictionary];
    NSDictionary *commonDict = @{
        @"action":action,
        @"reqtime":reqtime,
    };
    [requstDict setObject:commonDict forKey:@"common"];
    [requstDict setObject:params forKey:@"content"];
    [paramDict setObject:requstDict forKey:@"request"];
    
    __weak typeof(self) weakSelf = self;
    
    [self packagBody:paramDict encrypt:type result:^(NSData *data, NSString *key, NSDictionary *dict) {
        
        // 发起请求
        session = [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 上传文件数据
            [files enumerateObjectsUsingBlock:^(UploadFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [formData appendPartWithFileData:obj.data name:obj.key fileName:obj.name mimeType:obj.mimeType];
            }];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 解析数据
            [weakSelf analyse:responseObject encrypt:type key:key result:^(NSString *result) {
                if (successBlock) { successBlock(result); }
                Log(@"请求结果: %@", result);
            }];
            
            // 请求结束，从缓存队列中移除
            if ([[weakSelf allTasks] containsObject:session]) {
                [[weakSelf allTasks] removeObject:session];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock) failBlock(error);
            [[weakSelf allTasks] removeObject:session];
        }];
            
        if (session) [[weakSelf allTasks] addObject:session];
        [session resume];
                    
    }];
}



#pragma mark - 下载
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(DownloadProgress)progressBlock
                         successBlock:(DownloadSuccessBlock)successBlock
                            failBlock:(DownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block URLSessionTask *session = nil;
    
    NSURL *fileUrl = [[CacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
    
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 添加token信息
//    if ([UserModel share].accessToken.length > 0) {
//        [manager.requestSerializer setValue:[UserModel share].accessToken forHTTPHeaderField:@"Authorization"];
//        Log(@"请求token：%@", [UserModel share].accessToken);
//    }
    
    session = [manager GET:url
                parameters:nil
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) {
                          NSData *dataObj = (NSData *)responseObject;
                          
                          [[CacheManager shareManager] storeDownloadData:dataObj requestUrl:url];
                          
                          NSURL *downFileUrl = [[CacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
                          
                          successBlock(downFileUrl);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) {
                          failBlock (error);
                      }
                  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark -

// 组装请求头
+ (void)packagRequest:(NSMutableURLRequest *)request {
    
    // 添加token信息
//    if ([UserModel share].accessToken.length > 0) {
//        Log(@"请求token：%@", [UserModel share].accessToken);
//        [request setValue:[UserModel share].accessToken forHTTPHeaderField:@"Authorization"];
//    }
    
    // 添加header信息
    for (NSString *key in headers.allKeys) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
}

// 组装请求数据
+ (void)packagBody:(NSDictionary *)params encrypt:(NetEnryptType)type result:(void(^)(NSData *data, NSString *key, NSDictionary *dict))block {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // aes
    if (type == NetEnryptTypeAES) {
//        NSLog(@"%@",[UserModel share].aesKey);
//        block([aesEncryptString(result, [UserModel share].aesKey) dataUsingEncoding:NSUTF8StringEncoding], nil, @{});
    }
    
    // rsa
    else if (type == NetEnryptTypeRSA) {
        
        NSString *key = [[self random128BitAESKey] hexString];
        NSString *encryteStr = aesEncryptString(result, key);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
        NSString *encryteKey = [RSAEncryptor encryptString:key publicKeyWithContentsOfFile:path];
        
        NSDictionary *dict = @{@"key" : encryteKey, @"data" : encryteStr};
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *result1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        
        Log(@"加密参数：%@", dict);
        
        block([result1 dataUsingEncoding:NSUTF8StringEncoding], key, dict);
    }
    // 不加密
    else {
        block([result dataUsingEncoding:NSUTF8StringEncoding], nil, @{});
    }
}

// 解析响应数据
+ (void)analyse:(id _Nullable )responseObject encrypt:(NetEnryptType)type key:(NSString *)key result:(void(^)(NSString *result))block {
    
    // aes
    if (type == NetEnryptTypeAES) {
//        NSString *string =[[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
//        if (block) block(aesDecryptString(string, [UserModel share].aesKey));
    }
    // rsa
    else if (type == NetEnryptTypeRSA) {
        NSString *string =[[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        if (block) block(aesDecryptString(string, key));
    }
    // 不加密
    else {
        if ([responseObject isKindOfClass:[NSData class]]) {
            if (block) block([[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding]);
        } else {
//            if (block) block([responseObject mj_JSONString]);
        }
    }
}


#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

+ (NSData *)random128BitAESKey {
    unsigned char buf[8];
    arc4random_buf(buf, sizeof(buf));
    return [NSData dataWithBytes:buf length:sizeof(buf)];
}

@end


@implementation LSHttpClient (cache)

+ (NSUInteger)totalCacheSize {
    return [[CacheManager shareManager] totalCacheSize];
}

+ (NSUInteger)totalDownloadDataSize {
    return [[CacheManager shareManager] totalDownloadDataSize];
}

+ (void)clearDownloadData {
    [[CacheManager shareManager] clearDownloadData];
}

+ (NSString *)getDownDirectoryPath {
    return [[CacheManager shareManager] getDownDirectoryPath];
}

+ (NSString *)getCacheDiretoryPath {
    
    return [[CacheManager shareManager] getCacheDiretoryPath];
}

+ (void)clearTotalCache {
    [[CacheManager shareManager] clearTotalCache];
}


@end
