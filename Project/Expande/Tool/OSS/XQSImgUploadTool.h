//
//  XQSImgUploadTool.h
//  XiaoQingShu
//
//  Created by xuwen on 2019/7/27.
//  Copyright © 2019 xiaoqingshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResultBlock)(BOOL isOK,NSString *url);
typedef void(^Progress)(float progress);
typedef void(^ResultBlockT)(BOOL isOK,NSArray<NSString *> *imgNameArr);

@interface XQSImgUploadTool : NSObject

/**
 *  异步上传 单张图片
 *
 *  @param image         要上传的图片
 *  @param progressBlock 上传图片进度
 *  @param resultBlock   上传图片结果
 */
+(void)uploadPhotoAsync:(UIImage *)image progress:(Progress)progressBlock resultBlock:(ResultBlock)resultBlock;


/**
 *  同步上传 单张图片
 *
 *  @param image 要上传的图片
 *
 *  @return 上传成功后返回的Url
 */
+(NSString *)uploadPhotoSync:(UIImage *)image progress:(Progress)progressBlock;


/**
 *  异步上传 多张图片
 *
 *  @param imageArr      要上传的图片数组
 *  @param progressBlock 上传图片进度
 *  @param resultBlock   上传图片结果
 *  @param isAsync       是否异步
 */
+(void)uploadPhotos:(NSArray<UIImage *> *)imageArr progress:(Progress)progressBlock resultBlock:(ResultBlockT)resultBlock isAsync:(BOOL)isAsync;


@end

NS_ASSUME_NONNULL_END
