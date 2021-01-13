//
//  XQSImgUploadTool.m
//  XiaoQingShu
//
//  Created by xuwen on 2019/7/27.
//  Copyright © 2019 xiaoqingshu. All rights reserved.
//

#import "XQSImgUploadTool.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AliyunOSSiOS/OSSService.h"

// AccessKey
NSString * const AccessKey = @"LTAI4FkVkJLiTw2vAY5CkW1j";
// SecretKey
NSString * const SecretKey = @"kCEzN7hAYXBEkmPObApQKcmDBfqR9W";
// 与OSS文件夹名对应
NSString * const PUBLIC_BUCKET = @"my-dating";
//
NSString * const ENDPOINTIMAGE = @"https://oss-us-west-1.aliyuncs.com";
// 子文件夹
NSString * const OBJECT_KEY = @"image";
//
NSString * const MultipartUploadObjectKey = @"MultipartUploadObjectKey";
//
CGFloat const kPix = 750;


// 修饰全局，作用域仅限于本类
static OSSClient * client;


@implementation XQSImgUploadTool

// 初始化OSS客户端
+ (void)initOSSClient{

    // 1. credential
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];

    // 2. OSSClient配置参数
    OSSClientConfiguration *config = [OSSClientConfiguration new];
    // 设置 是否开启后台传输
    config.enableBackgroundTransmitService = NO;
    // 设置 最大重试次数
    config.maxRetryCount = 3;
    // 设置 请求超时时间
    config.timeoutIntervalForRequest = 20;
    // 设置 单个object下载最长持续时间
    config.timeoutIntervalForResource = 24 * 60 * 60;

    // 3. 初始OSS化客户端
    client = [[OSSClient alloc]initWithEndpoint:ENDPOINTIMAGE credentialProvider:credential clientConfiguration:config];
}

// 异步上传 单张图片
+ (void)uploadPhotoAsync:(UIImage *)image progress:(Progress)progressBlock resultBlock:(ResultBlock)resultBlock{

    OSSPutObjectRequest *put=[self getPutWithImage:image progress:progressBlock];

    // 2.上传
    OSSTask *putTast = [client putObject:put];
    [putTast continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error){       // 上传成功
            NSLog(@"上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{

                // 上传成功后的图片UrlStr
                NSString *str=[[ENDPOINTIMAGE componentsSeparatedByString:@"//"] lastObject];
                NSString *urlString=[NSString stringWithFormat:@"https://%@.%@/%@",PUBLIC_BUCKET,str,put.objectKey];
                resultBlock(YES,urlString);
            });
        }else{                  // 上传失败
            NSLog(@"上传失败:%@",task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(NO,nil);
            });
        }
        return nil;
    }];
}

// 同步上传 单张图片
+ (NSString *)uploadPhotoSync:(UIImage *)image progress:(Progress)progressBlock{

    OSSPutObjectRequest *put=[self getPutWithImage:image progress:progressBlock];

    // 2.上传
    OSSTask *putTast = [client putObject:put];
    [[putTast continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error){
            NSLog(@"上传成功");
        }else{
            NSLog(@"上传失败:%@",task.error);
        }
        return nil;
    }] waitUntilFinished];


    // 上传成功后的图片UrlStr
    NSString *str=[[ENDPOINTIMAGE componentsSeparatedByString:@"//"] lastObject];
    NSString *urlString=[NSString stringWithFormat:@"https://%@.%@/%@",PUBLIC_BUCKET,str,put.objectKey];
    return urlString;
}

// 创建请求 OSSPutObjectRequest
+(OSSPutObjectRequest *)getPutWithImage:(UIImage *)image progress:(Progress)progressBlock{

    // 0.初始化客户端
    [self initOSSClient];

    // 1.上传请求
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    // 1.1.设置bucketName (文件夹名，与OSS对应)
    put.bucketName = PUBLIC_BUCKET;
    // 1.2.文件名路径
    NSTimeInterval timeInterval =[[NSDate date] timeIntervalSince1970];
    NSString *objectName = [NSString stringWithFormat:@"%@/%@_img_%d.png",[self dirPath],[self timeStringWithDataTimeToDate:timeInterval],((arc4random()% 100000000) + 10000)];
    put.objectKey = objectName;
    // 1.3.上传对象（图片data）
    put.uploadingData = [self imageCompressForSize:image targetPx:kPix];
    // 1.4.上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float progress = (float)totalByteSent/totalBytesExpectedToSend;
        progressBlock(progress);
    };

    return put;
}

// 上传多张图片
+(void)uploadPhotos:(NSArray<UIImage *> *)imageArr progress:(Progress)progressBlock resultBlock:(ResultBlockT)resultBlock isAsync:(BOOL)isAsync{

    // 0.初始化客户端
    [self initOSSClient];

    // 1.线程队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 1.1最大线程数
    queue.maxConcurrentOperationCount = imageArr.count;

    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in imageArr){
        if (image){

            // 线程
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{

                // 1.上传请求
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                // 1.1.设置bucketName (文件夹名，与OSS对应)
                put.bucketName = PUBLIC_BUCKET;
                // 1.2.文件名+路径
                NSTimeInterval timeInterval =[[NSDate date] timeIntervalSince1970];
                NSString *objectName = [NSString stringWithFormat:@"%@/%@_img_%d.png",[self dirPath],[self timeStringWithDataTimeToDate:timeInterval],((arc4random()% 100000000) + 10000)];
                put.objectKey = objectName;

                // iconName
                NSString *str=[[ENDPOINTIMAGE componentsSeparatedByString:@"//"] lastObject];
                NSString *urlString=[NSString stringWithFormat:@"https://%@.%@/%@",PUBLIC_BUCKET,str,put.objectKey];
                NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                NSString *encodingString = [[NSString stringWithFormat:@"http://kachamao.oss-cn-shanghai.aliyuncs.com/%@",objectName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [callBackNames addObject: encodingString];

                // 1.3.上传对象(内存中)
                put.uploadingData = [self imageCompressForSize:image targetPx:kPix];

                //
                OSSTask * putTask = [client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task){

                    if (task.error){
                        OSSLogError(@"%@", task.error);
                    }

                    OSSPutObjectResult * result = task.result;
                    NSLog(@"Result - requestId: %@, headerFields: %@",
                          result.requestId,
                          result.httpResponseHeaderFields);
                    return nil;
                }]; // 阻塞直到上传完成

                if (isAsync) {
                    if (image == imageArr.lastObject) {
                        NSLog(@"upload object finished!");
                        if (resultBlock) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                resultBlock(true,callBackNames);
                            });
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }

    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (resultBlock) {
            if (resultBlock) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    resultBlock(true,[NSArray arrayWithArray:callBackNames]);
                });
            }
        }
    }
}



// 文件路径（会在oss官网上生成文件夹路径）
+ (NSString *)dirPath{
    NSDateFormatter *formater = [NSDateFormatter new];
    [formater setDateFormat:@"/yyyy/MM/yyyMMdd"];
    NSString *str = [formater stringFromDate:[NSDate date]];

    return [[OBJECT_KEY mutableCopy] stringByAppendingString:str];
}


/**
 图片压缩的处理逻辑:

 一 尺寸压缩(一般参照像素为1280)
 a. 宽高均<=1280px时    图片尺寸保持不变
 b. 宽高均>1280px时     图片宽高比<=2，则将图片宽或者高取大的等比压缩至1280px; 图片宽高比＞2时，则宽或者高取小的等比压缩至1280px;
 c. 宽或高某一个>1280px，另一个<1280px时  图片宽高比＞2时，则宽高尺寸不变;图片宽高比≤2时,则将图片宽或者高取大的等比压缩至1280px.

 二 质量压缩
 一般压缩在90%
 */

#pragma mark -- 图片压缩方法
+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx{

    //
    BOOL drawImge = NO;              // 是否需要重绘图片 默认是NO
    CGFloat scaleFactor = 0.0;       // 压缩比例
    CGFloat scaledWidth = targetPx;  // 压缩后的宽度 默认是参照像素1280px
    CGFloat scaledHeight = targetPx; // 压缩后的高度 默认是参照像素1280px


    // 压缩尺寸
    // 新图片(尺寸压缩后的)
    UIImage *newImage = nil;
    // 原size
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 判断尺寸
    if (width < targetPx && height < targetPx) {            // a.宽高均<=参照像素时:尺寸不变
        newImage = sourceImage;
    }else if (width > targetPx && height > targetPx) {      // b.宽或高均＞1280px时
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {  // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            if (width > height) {
                scaleFactor  = targetPx / width;
            } else {
                scaleFactor = targetPx / height;
            }
        } else {            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            if (width > height) {
                scaleFactor  = targetPx / height;
            } else {
                scaleFactor = targetPx / width;
            }
        }
    }else if (width > targetPx &&  height < targetPx ) {    // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
        if (width / height > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / width;
        }
    }else if (width < targetPx &&  height > targetPx) {     // c.宽高一个＞1280px，另一个＜1280px 高大于1280
        if (height / width > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / height;
        }
    }
    if (drawImge == YES) {      // 图片需要重绘 按新宽高压缩重绘图片
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (newImage == nil) {
        newImage = sourceImage;
    }



    // 质量压缩(图片>200kb 时)
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil) {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        if (scaledImageData.length >= 1024 * 200) {
            scaledImageData = UIImageJPEGRepresentation(newImage, 0.5);
        }
    }

    return scaledImageData;
}

// yyyy-MM-dd 时间戳
+ (NSString *)timeStringWithDataTimeToDate:(NSTimeInterval)time{

    //
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss"];
    }
    NSString *string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}

@end
