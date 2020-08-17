//
//  LSPurchaseManager.h
//  Project
//
//  Created by XuWen on 2020/4/14.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSPurchaseModel;
NS_ASSUME_NONNULL_BEGIN

@interface LSPurchaseManager : NSObject

+ (instancetype)share;
//预先获取到内购信息
- (void)preGetPurchaseInfo:(void(^)(NSArray <LSPurchaseModel*>*array))completeBlock;
//购买
//+ (void)purchseWithType:(LSPurchaseType)type completeBlock:(void(^)(BOOL isSuccess))completeBlock;
+ (void)purchseWithModel:(LSPurchaseModel *)perchaseModel completeBlock:(void(^)(BOOL isSuccess))completeBlock;
//恢复购买
+ (void)restore:(void(^)(BOOL isSuccess))completeBlock;

//判断用户是否是会员
+ (BOOL)isVIP;
@end

@interface LSPurchaseModel : NSObject
//系统内购字段
//@property (nonatomic,strong) NSString *localizedTitle;
//@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *productIdentifier;

//+ (LSPurchaseModel *)createWithType:(LSPurchaseType)type;

// 自定义字段
//@property (nonatomic,assign) LSPurchaseType type;
@property (nonatomic,strong) NSString *localizedTitle;
@property (nonatomic,strong) NSString *priceStr;
@property (nonatomic,strong) NSString *dayCount;

@property (nonatomic,strong) NSString *productIdentifier;
@property (nonatomic,strong) NSString *imageStr;

@property (nonatomic,strong) NSString *price;

@end

NS_ASSUME_NONNULL_END
