//
//  SEEKING_FilterModel.h
//  Project
//
//  Created by XuWen on 2020/3/19.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFilter [SEEKING_FilterModel share]

NS_ASSUME_NONNULL_BEGIN

@interface SEEKING_FilterModel : NSObject

+ (instancetype)share;

- (void)synchronize;
- (void)clear;

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *startage;
@property (nonatomic,strong) NSString *endage;
@property (nonatomic,strong) NSString *page;
@property (nonatomic,strong) NSString *sex;  //1 男 2 女 0 全部
@property (nonatomic,strong) NSString *redius; //半径
@property (nonatomic,strong) NSString *isFilter; //是否过滤

@end

NS_ASSUME_NONNULL_END
