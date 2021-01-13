//
//  LSGirlZhaoHuHealper.m
//  Project
//
//  Created by XuWen on 2020/3/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSGirlZhaoHuHealper.h"
#import "LSRongYunHelper.h"
#import "LSSayHiAlertView.h"
#import "LSMessageSendView.h"

@interface LSGirlZhaoHuHealper()
@property (nonatomic,assign) BOOL isZhaoHu;
@property (nonatomic,strong) NSArray <SEEKING_Customer *>*customerArray;
@end

@implementation LSGirlZhaoHuHealper


static LSGirlZhaoHuHealper *__singletion;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__singletion == nil) {
            __singletion = [[self alloc] init];
        }
    });
    return __singletion;
}

+ (void)zhaohu
{
    if(![LSGirlZhaoHuHealper share].isZhaoHu){
        //没有打过招呼才开始去打招呼
        //1. 请求打招呼的人群
        //2. 从人群中找人
        //3. 挨着发信息 (有弹窗)
        //4. 标记打招呼完毕
        [LSGirlZhaoHuHealper share].isZhaoHu = YES;
        //第一步
        [[LSGirlZhaoHuHealper share]loadCustomers:YES];
    }
}

+ (void)zhaohuWithoutAlert
{
    [LSGirlZhaoHuHealper share].isZhaoHu = YES;
    [[LSGirlZhaoHuHealper share]loadCustomers:NO];
}

//第一步请求打招呼的人
- (void)loadCustomers:(BOOL)showAlert
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(!showAlert){
//        [params setNullObject:@(0) forKey:@"num"];
    }else{
        [params setNullObject:@(25) forKey:@"num"];
    }
    [params setNullObject:kUser.id forKey:@"id" replaceObject:@"1"];

    [self post:KURL_RandowZhaoHu params:params success:^(Response * _Nonnull response) {
        if (response.isSuccess) {
            //如果成功的话
            NSArray *dataArray = [response.content objectForKey:@"list"] ;
            NSArray <SEEKING_Customer *>*cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:dataArray];
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
            }
            
            //数据准备
            self.customerArray = [NSArray arrayWithArray:cutomerArray];
            //开始第二步骤
            [self selectCustomer:showAlert];
        } else {
            NSLog(@"失败");
            //如果失败的话
//            [AlertView toast:response.message inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


//第二部 选择打招呼的人 （弹窗）
- (void)selectCustomer:(BOOL)showAlert
{
    NSArray <SEEKING_Customer *>*customerList = self.customerArray;
    NSMutableArray *array = [NSMutableArray arrayWithArray:customerList];
    //打乱数组
    [array shuffle];
    //第三步去打招呼 弹框
    if(showAlert){
        LSSayHiAlertView *alertView = [[LSSayHiAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        alertView.dazhaohuBlock = ^(BOOL isDaZhaoHu, int count){
            if(isDaZhaoHu){
                //筛选人数
                NSMutableArray *countArray = [NSMutableArray array];
                if(array.count > count){
                    for(int i = 0;i<count;i++){
                        [countArray addObject:array[i]];
                    }
                }else{
                    [countArray addObjectsFromArray:array];
                }
                //开始去打招呼 循环发送  群发消息
                [self dazhahu:countArray index:0];
            }
        };
        [alertView appearAnimation];
    }else{
        //不弹出来
        //筛选人数
        int count = 5; //打招呼的人数
        NSMutableArray *countArray = [NSMutableArray array];
        if(array.count > count){
            for(int i = 0;i<count;i++){
                [countArray addObject:array[i]];
            }
        }else{
            [countArray addObjectsFromArray:array];
        }
        //开始去打招呼 循环发送  群发消息
        [self dazhahu:countArray index:0];
    }
}

//第三步 打招呼
- (void)dazhahu:(NSArray *)customerList index:(NSInteger)index
{
    SEEKING_Customer *customer = customerList[index];
    kXWWeakSelf(weakself);
    NSLog(@"%@",[[NSDate date]dateString]);
    
    [LSRongYunHelper dazhaohu:customer finish:^(BOOL isFinish) {
        if(index+1 < customerList.count){
            [weakself dazhahu:customerList index:index+1];
        }else{
            //手动刷新列表，打招呼的内容不要显示
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotifidation_DazhaHuReloead object:nil];
            //打招呼完毕，一个弹出框
            [LSMessageSendView showWithCustomer:customer];
        }
    }];
}


@end
