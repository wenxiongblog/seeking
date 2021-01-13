//
//  LSPurchaseManager.m
//  Project
//
//  Created by XuWen on 2020/4/14.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPurchaseManager.h"
#import <RMStore/RMStore.h>
#import <MJExtension/MJExtension.h>
#import <SAMKeychain/SAMKeychain.h>



@interface LSPurchaseManager()
@property (nonatomic,strong) NSArray <LSPurchaseModel *>*purchaseArray;
@property (nonatomic,strong) NSSet * productIdentifiesSet;
@end

@implementation LSPurchaseManager

static LSPurchaseManager *__singletion;

- (void)MDVIP7{}
- (void)MDVIP30{}
- (void)MDVIP90{}

- (void)MDpurchase_failed{}
- (void)MDpurchase_failed_connect{}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__singletion == nil) {
            __singletion = [[self alloc] init];
        }
    });
    return __singletion;
}

#pragma mark - public
- (void)preGetPurchaseInfo:(void(^)(NSArray <LSPurchaseModel*>*array))completeBlock
{
    if(self.purchaseArray.count > 0){
        completeBlock(self.purchaseArray);
    }else{
        kXWWeakSelf(weakself);
        [[RMStore defaultStore] requestProducts:self.productIdentifiesSet success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            NSLog(@"%@",products);
            NSMutableArray *mutableArray = [NSMutableArray array];
            for(SKProduct *product in products){
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [formatter setLocale:product.priceLocale];
                NSString * currencyString = [formatter stringFromNumber:product.price];
                NSLog(@"本地价格%@",currencyString);
                NSString *priductId = product.productIdentifier;
                NSLog(@"productId%@",priductId);
                //数据添加
                LSPurchaseModel* model = [[LSPurchaseModel alloc]init];
                model.productIdentifier = priductId;
                model.priceStr = currencyString;
                model.dayCount = [product.localizedTitle componentsSeparatedByString:@" "].firstObject;
                [mutableArray addObject:model];
            }
            weakself.purchaseArray = [NSArray arrayWithArray:mutableArray];
            if(weakself.purchaseArray.count == 3){
                completeBlock(weakself.purchaseArray);
            }else{
                //加载本地
                NSDictionary *dict = [weakself readLocalPurchase];
                NSArray *data = dict[@"data"];
                NSArray *array = [LSPurchaseModel mj_objectArrayWithKeyValuesArray:data];
                weakself.purchaseArray = [NSArray arrayWithArray:array];
                completeBlock(weakself.purchaseArray);
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
            //加载本地
               NSDictionary *dict = [weakself readLocalPurchase];
               NSArray *data = dict[@"data"];
               NSArray *array = [LSPurchaseModel mj_objectArrayWithKeyValuesArray:data];
               weakself.purchaseArray = [NSArray arrayWithArray:array];
               completeBlock(weakself.purchaseArray);
            
        }];
    }
}

- (NSDictionary *)readLocalPurchase {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"purchase.json" ofType:@""];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@",dict);
    return dict;
}

+ (void)purchseWithModel:(LSPurchaseModel *)perchaseModel completeBlock:(void(^)(BOOL isSuccess))completeBlock
{
    [[LSPurchaseManager share]innerPurchseWithId:perchaseModel completeBlock:completeBlock];
}

//恢复内购
+ (void)restore:(void(^)(BOOL isSuccess))completeBlock
{
    //查看自己的信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setNullObject:kUser.id forKey:@"id"];
    
    [AlertView showLoading:@"" inView:[UIApplication sharedApplication].keyWindow];
    
    [self post:KURL_DetailInfo params:params success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
        if(response.isSuccess){
            SEEKING_Customer *customer = [SEEKING_Customer mj_objectWithKeyValues:response.content[@"outuser"]];
            //判断会员是否过期
            if(customer.isVIPCustomer){
                //存储内购信息到本地
                [SAMKeychain setPassword:customer.effectiveTime forService:@"service1" account:@"HoneyVIP"];
                //恢复内购成功
                [AlertView toast:@"Restore Success" inView:[UIApplication sharedApplication].keyWindow];
                completeBlock(YES);
            }else{
                //会员已经过期
                [AlertView toast:@"VIP has expired" inView:[UIApplication sharedApplication].keyWindow];
                completeBlock(NO);
            }
        }else{
            [AlertView toast:@"Restore Failed" inView:[UIApplication sharedApplication].keyWindow];
            completeBlock(NO);
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
        completeBlock(NO);
    }];
}

+ (BOOL)isVIP
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    long currentTime = [datenow timeIntervalSince1970];
    NSLog(@"当前时间戳：%ld,时间:%@",currentTime,[formatter stringFromDate:datenow]);
    NSString *expireTimeStr = [SAMKeychain passwordForService:@"service1" account:@"HoneyVIP"];
    long expireTime = [expireTimeStr integerValue];
    NSDate *expireData = [NSDate dateWithTimeIntervalSince1970:expireTime];
    NSLog(@"VIP时间戳：%ld,时间%@:",expireTime,[formatter stringFromDate:expireData]);
    
    return currentTime < expireTime;
}

#pragma mark - private
- (void)innerPurchseWithId:(LSPurchaseModel *)perchaseModel completeBlock:(void(^)(BOOL isSuccess))completeBlock
{
    if (![RMStore canMakePayments]) {
        return;
    }
    NSString *ProductId = perchaseModel.productIdentifier;
    kXWWeakSelf(weakself);
    [AlertView showLoading:kLanguage(@"loading...") inView:[UIApplication sharedApplication].keyWindow];
    [[RMStore defaultStore] requestProducts:self.productIdentifiesSet success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
           NSLog(@"success");
           NSArray *array = [LSPurchaseModel mj_objectArrayWithKeyValuesArray:products];
           weakself.purchaseArray = [NSArray arrayWithArray:array];
           dispatch_async(dispatch_get_main_queue(), ^{
               if (products.count > 0) {
                   [[RMStore defaultStore] addPayment:ProductId success:^(SKPaymentTransaction *transaction) {
                    
                       //购买成功
                       NSLog(@"%@",transaction);
                       [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
                       
                       //开始存储购买数据
                       [weakself storePurchaseWithModel:perchaseModel complete:^(BOOL isSuccess) {
                           if(isSuccess){
                               [AlertView toast:kLanguage(@"Purchase Success") inView:[UIApplication sharedApplication].keyWindow];
                           }else{
                               [AlertView toast:kLanguage(@"Purchase Failed") inView:[UIApplication sharedApplication].keyWindow];
                           }
                           if(completeBlock){
                               completeBlock(isSuccess);
                           }
                       }];
                       
                   } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                       [self MDpurchase_failed_connect];
                       //无法连接到itunes connect
                       [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
                       [AlertView toast:error.localizedDescription inView:[UIApplication sharedApplication].keyWindow];
                       if(completeBlock){
                           completeBlock(NO);
                       }
                   }];
               } else {
                   //没有产品
                   [self MDpurchase_failed];
                   
                   [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
                   [AlertView toast:@"No Product"inView:[UIApplication sharedApplication].keyWindow];
                   if(completeBlock){
                       completeBlock(NO);
                   }
               }
           });
       } failure:^(NSError *error) {
           //购买失败
           [self MDpurchase_failed];
           NSLog(@"failed");
           dispatch_async(dispatch_get_main_queue(), ^{
               [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
               [AlertView toast:error.localizedDescription inView:[UIApplication sharedApplication].keyWindow];
               if(completeBlock){
                   completeBlock(NO);
               }
           });
       }];
}


- (void)storePurchaseWithModel:(LSPurchaseModel *)perchaseModel complete:(void(^)(BOOL isSuccess))complete
{
    int days = [perchaseModel.dayCount intValue];
    CGFloat money = 100;
    
    NSDate *datenow = [NSDate date];
    long currentTime = [datenow timeIntervalSince1970];
    NSLog(@"当前时间戳：%ld",currentTime);
    NSString *expireTimeStr = [SAMKeychain passwordForService:@"service1" account:@"HoneyVIP"];
    NSLog(@"之前的VIP时间戳：%@",expireTimeStr);
    
    //时间增加7天验证
    long addTime = days*24*60*60 + currentTime;
    
    //打印信息
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:addTime];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    NSLog(@"购买后的时间是%@",timeStr);
    
    //本地保存购买信息
    NSString *sst = [NSString stringWithFormat:@"%ld",addTime];
    [SAMKeychain setPassword:sst forService:@"service1" account:@"HoneyVIP"];
    
    //后台保存用户购买信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setNullObject:kUser.id forKey:@"id"];
    [dict setNullObject:sst forKey:@"effectiveTime"];
    [dict setNullObject:[NSDate getNowTimeTimestamp3] forKey:@"paytime"];
    [dict setNullObject:@(100) forKey:@"paymoney"];
    
    [AlertView showLoading:@"" inView:[UIApplication sharedApplication].keyWindow];
    [kUser updateUserInfo:dict complete:^(BOOL Success, NSString * _Nonnull msg) {
        [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
        if(Success){
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_PurchaseSuccess object:nil];
            complete(YES);
        }else{
            complete(NO);
        }
    }];
}

- (NSSet *)productIdentifiesSet
{
    if(!_productIdentifiesSet){
        _productIdentifiesSet = [NSSet setWithArray:@[kVIP_30_DAY,kVIP_7_DAY,kVIP_90_DAY]];
    }
    return _productIdentifiesSet;
}

@end


@implementation LSPurchaseModel

- (void)setPrice:(NSString *)price
{
    _price = price;
    self.priceStr = [NSString stringWithFormat:@"¥%@",price];
}

- (void)setLocalizedTitle:(NSString *)localizedTitle
{
    _localizedTitle = localizedTitle;
    self.dayCount = [localizedTitle componentsSeparatedByString:@" "].firstObject;
}

@end
