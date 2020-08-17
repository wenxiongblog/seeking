//
//  LSUserInfoExtra.h
//  Project
//
//  Created by XuWen on 2020/3/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSMessageUserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LSUserInfoExtra : NSObject

@property (nonatomic,strong) LSMessageUserInfo *sendUserInfo;
@property (nonatomic,strong) LSMessageUserInfo *receiveUserInfo;

//将string转为对象
+ (instancetype)formedWithStr:(NSString *)extraStr;
//将对象转为string
- (NSString *)extraStr;
@end


@interface LSMessageUserInfo : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *headUrlStr;
@property (nonatomic,assign) int age;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *distancee;
@end

NS_ASSUME_NONNULL_END
