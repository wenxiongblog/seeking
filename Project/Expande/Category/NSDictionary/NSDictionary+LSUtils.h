//
//  NSDictionary+LSUtils.h
//  Project
//
//  Created by XuWen on 2020/3/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LSUtils)
//转为jsonString
-(NSString*)DataTOjsonString;

//+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
