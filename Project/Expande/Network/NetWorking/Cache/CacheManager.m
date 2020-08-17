//
//  CacheManager.m
//  Networking
//
//  Created by yingqiu huang on 2017/2/10.
//  Copyright © 2017年 yingqiu huang. All rights reserved.
//

#import "CacheManager.h"
#import "MemoryCache.h"
#import "DiskCache.h"
#import "LRUManager.h"
#import <YYCache/YYCache.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *const cacheDirKey = @"cacheDirKey";

static NSString *const downloadDirKey = @"downloadDirKey";

static NSUInteger diskCapacity = 40 * 1024 * 1024;

static NSTimeInterval cacheTime = 7 * 24 * 60 * 60;

@interface CacheManager ()

@property (nonatomic, strong) YYDiskCache *diskCache;

@end


@implementation CacheManager

+ (CacheManager *)shareManager {
    static CacheManager *_CacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _CacheManager = [[CacheManager alloc] init];
    });
    return _CacheManager;
}

- (YYDiskCache *)diskCache {
    if (!_diskCache) {
        _diskCache = [[YYDiskCache alloc] initWithPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Networking"] stringByAppendingPathComponent:@"networkCache"]];
    }
    return _diskCache;
}

- (void)setCacheTime:(NSTimeInterval)time diskCapacity:(NSUInteger)capacity {
    diskCapacity = capacity;
    cacheTime = time;
}

- (void)cacheResponseObject:(id)responseObject
                 requestUrl:(NSString *)requestUrl
                     params:(NSDictionary *)params {
    assert(responseObject);
    
    assert(requestUrl);
    
    if (!params) params = @{};
    NSString *originString = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (error == nil) {
        //缓存到内存中
        [MemoryCache writeData:responseObject forKey:hash];
        
        //缓存到磁盘中
        [self.diskCache setObject:data forKey:hash];
//        //磁盘路径
//        NSString *directoryPath = nil;
//        directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDirKey];
//        if (!directoryPath) {
//            directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Networking"] stringByAppendingPathComponent:@"networkCache"];
//            [[NSUserDefaults standardUserDefaults] setObject:directoryPath forKey:cacheDirKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        [DiskCache writeData:data toDir:directoryPath filename:hash];
        
        [[LRUManager shareManager] addFileNode:hash];
    }
    
}

- (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl
                                    params:(NSDictionary *)params {
    assert(requestUrl);
    
    id cacheData = nil;
    
    if (!params) params = @{};
    NSString *originString = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    //先从内存中查找
    cacheData = [MemoryCache readDataWithKey:hash];
    
    if (!cacheData) {
        
        cacheData = [self.diskCache objectForKey:hash];
        if (cacheData) [[LRUManager shareManager] refreshIndexOfFileNode:hash];
        
//        NSString *directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDirKey];
//
//        if (directoryPath) {
//            cacheData = [DiskCache readDataFromDir:directoryPath filename:hash];
//
//            if (cacheData) [[LRUManager shareManager] refreshIndexOfFileNode:hash];
//        }
    }
    
    return cacheData;
}

- (void)storeDownloadData:(NSData *)data
               requestUrl:(NSString *)requestUrl {
    assert(data);
    
    assert(requestUrl);
    
    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    
    strArray = [requestUrl componentsSeparatedByString:@"."];
    if (strArray.count > 0) {
        type = strArray[strArray.count - 1];
    }
    
    if (type) {
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    }else {
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
    }
    
    NSString *directoryPath = nil;
    directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:downloadDirKey];
    if (!directoryPath) {
        directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Networking"] stringByAppendingPathComponent:@"download"];
        
        [[NSUserDefaults standardUserDefaults] setObject:directoryPath forKey:downloadDirKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [DiskCache writeData:data toDir:directoryPath filename:fileName];
    
}

- (NSURL *)getDownloadDataFromCacheWithRequestUrl:(NSString *)requestUrl {
    assert(requestUrl);
    
    NSData *data = nil;
    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    NSURL *fileUrl = nil;
    
    
    strArray = [requestUrl componentsSeparatedByString:@"."];
    if (strArray.count > 0) {
        type = strArray[strArray.count - 1];
    }
    
    if (type) {
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    }else {
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
    }
    
    
    NSString *directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:downloadDirKey];
    
    if (directoryPath) data = [DiskCache readDataFromDir:directoryPath filename:fileName];
    
    if (data) {
        NSString *path = [directoryPath stringByAppendingPathComponent:fileName];
        fileUrl = [NSURL fileURLWithPath:path];
    }
    
    return fileUrl;
}

- (NSUInteger)totalCacheSize {
    
    return [self.diskCache totalCost];
    
//    NSString *diretoryPath = [[NSUserDefaults standardUserDefaults] objectForKey: cacheDirKey];
//
//    return [DiskCache dataSizeInDir:diretoryPath];
}

- (NSUInteger)totalDownloadDataSize {
    NSString *diretoryPath = [[NSUserDefaults standardUserDefaults] objectForKey: downloadDirKey];
    
    return [DiskCache dataSizeInDir:diretoryPath];
}

- (void)clearDownloadData {
    NSString *diretoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:downloadDirKey];
    
    [DiskCache clearDataIinDir:diretoryPath];
}

- (NSString *)getDownDirectoryPath {
    NSString *diretoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:downloadDirKey];
    return diretoryPath;
}

- (NSString *)getCacheDiretoryPath {
    NSString *diretoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDirKey];
    return diretoryPath;
}

- (void)clearTotalCache {
    
    [self.diskCache removeAllObjects];
    
//    NSString *directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDirKey];
//
//    [DiskCache clearDataIinDir:directoryPath];
}

- (void)clearLRUCache {
    if ([self totalCacheSize] > diskCapacity) {
        NSArray *deleteFiles = [[LRUManager shareManager] removeLRUFileNodeWithCacheTime:cacheTime];
        if (deleteFiles.count > 0) {
            __weak typeof(self) weakSelf = self;
            [deleteFiles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.diskCache removeObjectForKey:obj];
//                NSString *filePath = [directoryPath stringByAppendingPathComponent:obj];
//                [DiskCache deleteCache:filePath];
            }];
        }
//        NSString *directoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDirKey];
//        if (directoryPath && deleteFiles.count > 0) {
//            [deleteFiles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSString *filePath = [directoryPath stringByAppendingPathComponent:obj];
//                [DiskCache deleteCache:filePath];
//            }];
//
//        }
    }
}

#pragma mark - 散列值
- (NSString *)md5:(NSString *)string {
    if (string == nil || string.length == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    
    CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    
    return [ms copy];
}


@end
