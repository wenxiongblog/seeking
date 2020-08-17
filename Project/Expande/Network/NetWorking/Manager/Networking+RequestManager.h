//
//  Networking+RequestManager.h
//  Networking
//
//  Created by yingqiu huang on 2017/2/10.
//  Copyright © 2017年 yingqiu huang. All rights reserved.
//

#import "LSHttpClient.h"

@interface LSHttpClient (RequestManager)
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
+ (BOOL)haveSameRequestInTasksPool:(URLSessionTask *)task;

/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
+ (URLSessionTask *)cancleSameRequestInTasksPool:(URLSessionTask *)task;

@end
