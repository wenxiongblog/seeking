//
//  NSObject+LSCommonRequest.h
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LSCommonRequest)
//请求用户信息
- (void)postUserWithID:(NSString *)userID complete:(void(^)(SEEKING_Customer *customer))complete;
@end

NS_ASSUME_NONNULL_END
