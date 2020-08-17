//
//  LSMatchVC.m
//  Project
//
//  Created by XuWen on 2020/1/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMatchVC.h"
#import <UMAnalytics/MobClick.h>
#import "CCDraggableContainer.h"
#import "LSDraggableCardView.h"
#import "LSDetailViewController.h"

#import "SEEKING_CustomerLoadingView.h"
#import "LSGirlZhaoHuHealper.h"
#import "SEEKING_CustomerEmptyView.h"
#import "LSRongYunHelper.h"
#import "LSNotificationAlertView.h"
#import "LSGuideOneAlertView.h" //引导第一页
#import "LSGuideTwoAlertView.h" //引导第二页
#import "LSMatchAlertView.h"  //匹配成功
#import "LSAddPhotoAlert.h"   //添加照片

#import "LSMessageSendView.h"
#import "LSUploadPhotoVC.h"

#import "CountDownButton.h"  //倒计时
#import "LSMatchVIPAlertView.h" //80个VIP限制
#import "LSABTest.h"

@interface LSMatchVC ()<CCDraggableContainerDelegate,CCDraggableContainerDataSource>
@property (nonatomic, strong) CCDraggableContainer *container;
//
//数据
@property (nonatomic,strong) NSArray <SEEKING_Customer *>*dataArray;
@property (nonatomic,assign) NSInteger draggbleIndex;  //用户统计的滑块数量
@property (nonatomic,assign) NSInteger countDownIndex; //用户倒数计时VIP的数量
//@property (nonatomic,assign) BOOL loadFailed;  //加载失败的锁，加载失败不是卡片没有，不要从新刷新
//是否正在加载
@property (nonatomic,assign)BOOL isloading;
@end

@implementation LSMatchVC

//用户总滑牌次数
- (void)MDMatch{};
//用户总match成功次数

- (void)MDMatchSuccess{};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH,kSCREEN_HEIGHT) style:CCDraggableStyleDownOverlay];
    self.container.backgroundColor = [UIColor clearColor];
    self.container.delegate = self;
    self.container.dataSource = self;
    [self.view addSubview:self.container];
    
    //判断是否需要倒计时
    self.countDownIndex = 0;
    if([CountDownButton isNeedCountDown]){
        LSMatchVIPAlertView *alert = [[LSMatchVIPAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
        [self.view addSubview:alert];
        [alert appearAnimation];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(conntDownFinished) name:@"CountDownFinished" object:nil];
    
    
    // 打招呼
    [self zijilaigegaohu:^(BOOL finished) {
        
    }];
   
}


- (void)zijilaigegaohu:(void(^)(BOOL finished))finished
{
    //设置融云头像和昵称
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:kUser.conversationId name:kUser.name portrait:kUser.images];
    [RCIM sharedRCIM].currentUserInfo.extra = kUser.rongYunExtra;
    
    //附加信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setNullObject:kUser.uid forKey:@"uid"];
    [dict setNullObject:kUser.id forKey:@"id"];
    
    [dict setNullObject:@"1" forKey:@"isactive"];
    
    [self post:kURL_UpdateUserInfo params:dict success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            NSLog(@"成功");
        }else{
            
        }
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"asdf");
    }];
}

//倒计时结束
- (void)conntDownFinished
{
    self.countDownIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.draggbleIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.dataArray.count == 0){
        //调用 finishedDraggableLastCard 刷新数据
        [self.container reloadData];
    }
}

#pragma mark - private
- (void)vipAlert
{
    LSMatchVIPAlertView *alert = [[LSMatchVIPAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
    [self.view addSubview:alert];
    [alert appearAnimation];
}

- (void)addPhoto
{
//    NSArray *array = [kUser.imageslist componentsSeparatedByString:@","];
    NSArray *array = nil;
    if(kUser.imageslist.length > 10){
        [kUser.imageslist componentsSeparatedByString:@","];
    }
    //小于3张要弹窗
    if(array.count < 2){
        LSAddPhotoAlert *alerView = [[LSAddPhotoAlert alloc]initWithStyle:XWBaseAlertViewStyleCenter];
        [self.view addSubview:alerView];
        kXWWeakSelf(weakself);
        alerView.ChoosePhotoBlock = ^(BOOL choose) {
            LSUploadPhotoVC *vc = [[LSUploadPhotoVC alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [weakself presentViewController:nav animated:YES
                                completion:nil];
        };
        [alerView appearAnimation];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOtification_ImageGreateThan3 object:nil];
    }
}

- (void)guideTwo
{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"guideTwo"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"guideTwo"];
        LSGuideTwoAlertView *guideTwo = [[LSGuideTwoAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
        [self.view addSubview:guideTwo];
        [guideTwo appearAnimation];
    }
}

#pragma mark - data
- (void)loadData
{
    self.isloading = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setNullObject:@(kUser.seeking) forKey:@"seeking"];
    [params setNullObject:kUser.id forKey:@"id" replaceObject:@"1"];

    kXWWeakSelf(weakself);
    [SEEKING_CustomerLoadingView showLoadingInView:self.container];
    
    [self post:kURL_DiscoverCards params:params success:^(Response * _Nonnull response) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isloading = NO;
            [SEEKING_CustomerLoadingView hideLoadinginView:self.container];
            if (response.isSuccess) {
                        //如果成功的话
                        NSArray *dataArray = [response.content objectForKey:@"list"];
                        if(dataArray.count == 0){
                            [SEEKING_CustomerEmptyView showEmptyInView:weakself.container];
                        }else{
                            [SEEKING_CustomerEmptyView hideEmptyinView:weakself.container];
                            NSArray <SEEKING_Customer *>*cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:dataArray];
                            //做一次没有用户信息的筛选。
                            NSMutableArray *mutableArray = [NSMutableArray array];
                            for(SEEKING_Customer *customer in cutomerArray)
                            {
                                if(customer.name.length == 0 || customer.age == 0){
                                    continue;
                                }
                                [mutableArray addObject:customer];
                            }
                            cutomerArray = [NSArray arrayWithArray:mutableArray];
                            
                            weakself.dataArray = [NSArray arrayWithArray:cutomerArray];
                            [weakself.container reloadData];
                            //缓存融云用户数据
                            [LSRongYunHelper ryCashUserArray:cutomerArray];
                            
                            //指导页面
                            if(![[NSUserDefaults standardUserDefaults]boolForKey:@"guideOne"])
                            {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"guideOne"];
                                LSGuideOneAlertView *guideOne = [[LSGuideOneAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
                                [weakself.view addSubview:guideOne];
                                [guideOne appearAnimation];
                            }
                        }
                    } else {
                        //如果失败的话
                        [AlertView toast:response.message inView:weakself.view];
                        [SEEKING_CustomerLoadingView hideLoadinginView:weakself.container];
                        
                        //加载失败，点击重试
                    }
        });
        
    } fail:^(NSError * _Nonnull error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isloading = NO;
            [SEEKING_CustomerLoadingView hideLoadinginView:self.container];
            [weakself.container reloadData];
        });
    }];
}

- (void)likeCustomer:(SEEKING_Customer *)customer
{
//    LSMatchAlertView *alertView = [[LSMatchAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
//    alertView.customer = customer;
//    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
//    [alertView appearAnimation];
//    return;

    kXWWeakSelf(weakself);
    //喜欢的的前提 是要先登录
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
        if(success){
            //打招呼
            if(kUser.sex == 2){
                [LSGirlZhaoHuHealper zhaohu];
            }
            NSDictionary *parame = @{
                @"userid":kUser.id,
                @"likeid":customer.id,
            };
            if(success){
                [weakself post:KURL_Like params:parame success:^(Response * _Nonnull response) {
                    if(response.isSuccess){
                        NSDictionary *content = response.content;
                        if([content[@"relation"] intValue] == 1){
                            //互相喜欢 匹配成功
                            [weakself MDMatchSuccess];
                            LSMatchAlertView *alertView = [[LSMatchAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
                            alertView.customer = customer;
                            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
                            [alertView appearAnimation];
                        }
                    }else{
                        [AlertView toast:@"Like failed" inView:weakself.view];
                    }
                } fail:^(NSError * _Nonnull error) {
                    [AlertView toast:error.description inView:weakself.view];
                }];
            }
        }
    }];
}

- (void)dislikeCustomer:(SEEKING_Customer *)customer
{
    kXWWeakSelf(weakself);
    //不喜欢的的前提 是要先登录
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
        if(success){
            //打招呼
            if(kUser.sex == 2){
                [LSGirlZhaoHuHealper zhaohu];
            }
            
            NSDictionary *parame = @{
                @"userid":kUser.id,
                @"dislike":customer.id,
            };
            if(success){
                [weakself post:KURL_DISLike params:parame success:^(Response * _Nonnull response) {
                    if(response.isSuccess){
                        
                    }else{
                        [AlertView toast:@"Dislike failed" inView:weakself.view];
                    }
                } fail:^(NSError * _Nonnull error) {
                    [AlertView toast:error.description inView:weakself.view];
                }];
            }
        }
    }];
}

#pragma mark - <CCDraggableContainerDelegate,CCDraggableContainerDataSource>
- (NSInteger)numberOfIndexs
{
    return self.dataArray.count;
}

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index
{
    LSDraggableCardView *cardView = [[LSDraggableCardView alloc] initWithFrame:CGRectMake(0, 0, draggableContainer.frame.size.width, draggableContainer.frame.size.height)];
    cardView.customer = self.dataArray[index];
    cardView.eventVC = self;
    cardView.tag = index;
    kXWWeakSelf(weakself);
    cardView.detailBlock = ^(SEEKING_Customer * _Nonnull customer) {
        //点击底部信息栏弹出
        LSDetailViewController *vc = [[LSDetailViewController alloc]init];
        vc.customer = customer;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    return cardView;
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer swipeCardView:(LSDraggableCardView *)cardView swipeIndex:(NSInteger)didSelectIndex
{
    //向上滑动，弹出详情信息
    LSDetailViewController *vc = [[LSDetailViewController alloc]init];
    vc.customer = cardView.customer;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

// 拖动中 喜欢和不喜欢
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    LSDraggableCardView *cardView = (LSDraggableCardView*)draggableContainer.dragCardView;
    [cardView likeButtonAlpha:widthRatio];
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(LSDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex
{
    //点击卡片
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard
{
    if(!self.isloading){
        [self loadData];
    }
}

-(void)draggableContainne:(CCDraggableContainer*)draggableContainner
    finishedDraggableCard:(LSDraggableCardView *)finishCard
{
    //统计
    if(finishCard.tag == 19){
        [self addPhoto];
    }
    if(finishCard.tag == 4){
        [self guideTwo];
    }
    if(self.countDownIndex == 80){
        if(!kUser.isVIP){
            [CountDownButton saveCountTime];
            [self vipAlert];
        }
    }
}

//做拖动删除
-(void)draggableContainner:(CCDraggableContainer*)draggableContainner removedView:(LSDraggableCardView *)removedView removeFromLeft:(BOOL)removeFromLeft
{
    //统计
    [self MDMatch];
    
    self.countDownIndex = self.countDownIndex + 1;
    self.draggbleIndex = self.draggbleIndex + 1;
    
    NSString *str = [NSString stringWithFormat:@"DraggableCard_%ld",self.draggbleIndex];
    
    //这个已经完了才会显示
    if(removeFromLeft){
        NSLog(@"左边不喜欢");
        SEEKING_Customer *customer = removedView.customer;
        [self dislikeCustomer:customer];
    }else{
        NSLog(@"右边喜欢");
        SEEKING_Customer *customer = removedView.customer;
        [self likeCustomer:customer];
    }
}

#pragma mark - private
- (void)animation:(UIView *)button
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - event

@end
