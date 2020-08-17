//
//  SEEKING_DetileModel.h
//  Project
//
//  Created by XuWen on 2020/3/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEEKING_DetileModel : NSObject
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,strong) NSArray *subArray;

+ (SEEKING_DetileModel *)createWithTitle:(NSString *)title subtitle:(NSString *)subtitle tags:(NSArray *)tags;
+ (SEEKING_DetileModel *)createWithTitle:(NSString *)title subArray:(NSArray *)subarray;
@end

NS_ASSUME_NONNULL_END
