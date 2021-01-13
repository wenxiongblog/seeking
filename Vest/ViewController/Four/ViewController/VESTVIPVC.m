//
//  VESTVIPVC.m
//  Project
//
//  Created by XuWen on 2020/9/12.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTVIPVC.h"
#import <RMStore/RMStore.h>
#import "LSPurchaseManager.h"
#import <SAMKeychain/SAMKeychain.h>
#import "VESTChargeVC.h"

@interface VESTVIPVC ()
@property (nonatomic,strong) UIButton *restoreButton;


@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;

@end

@implementation VESTVIPVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraitsConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{

    
    
   self.bgImageView.image = XWImageName(@"vest_signInBG");
   self.backButton.hidden = NO;
   [self.backButton setImage:XWImageName(@"vest_back") forState:UIControlStateNormal];
   self.titleString = @"VIP";
   self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
   self.navTitleLabel.font = FontBold(24);
   self.navTitleLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44);
    
    //
       UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_VIPImg")];
       imageView.frame = CGRectMake((kSCREEN_WIDTH-XW(301))/2.0, kStatusBarAndNavigationBarHeight, XW(302), XW(190));
       [self.view addSubview:imageView];
    
    
    [self.view addSubview:self.restoreButton];
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@30);
        make.width.equalTo(@60);
    }];
    
    
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(340)));
        make.height.equalTo(@(XW(57)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).offset(50);
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.button1);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button1.mas_bottom).offset(20);
    }];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.button1);
        make.centerX.equalTo(self.view);
         make.top.equalTo(self.button2.mas_bottom).offset(20);
    }];
}

- (void)baseConstraitsConfig
{
    
}

#pragma mark - public


#pragma mark - private
+ (NSString *)getTimeFromTimesTamp:(long)time
{
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //将时间转换为字符串
    NSString *timeS = [formatter stringFromDate:myDate];
    return timeS;
}

+ (void)getVIPCoins
{
    if([self isVIP]){
        //判断是否是当天
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSString* todayStr = [dateFormat stringFromDate:[NSDate date]];
        
        NSString *saveStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"VIPCOINADD"];
        if(![todayStr isEqualToString:saveStr]){
            [VESTChargeVC addCoins:40];
        }
        [[NSUserDefaults standardUserDefaults]setObject:todayStr forKey:@"VIPCOINADD"];
    }
}

- (void)setVIPWithDay:(NSInteger)day
{
    //如果是续订型要注明，为取消续订逻辑准备
//    [[NSUserDefaults standardUserDefaults]setBool:day == 366 forKey:kIS_XuDignPurchase];
    //VIP的截止日期
    NSDate *senddate = [NSDate date];
    long currentDate = (long)[senddate timeIntervalSince1970];
    currentDate = currentDate + day * 60*60*24;
    NSString *sst = [NSString stringWithFormat:@"%ld",currentDate];
    [SAMKeychain setPassword:sst forService:@"service1" account:@"VIP1"];
}

#pragma mark - event
+ (BOOL)isVIP
{
    NSString *str = [SAMKeychain passwordForService:@"service1" account:@"VIP1"];
    long vipDate = (long)[str longLongValue];
    NSDate *senddate = [NSDate date];
    long currentDate = (long)[senddate timeIntervalSince1970];
    NSLog(@"%ld,%ld",vipDate,currentDate);
    NSLog(@"%@,%@",[VESTVIPVC getTimeFromTimesTamp:vipDate],[VESTVIPVC getTimeFromTimesTamp:currentDate]);
    
    if(vipDate > currentDate){
        return YES;
    }else{
        return NO;
    }
}

- (void)purchaseButtonClicked:(UIButton *)sender
{
    [VESTVIPVC isVIP];
    
    NSArray *productIDArray = @[kVIP_7_DAY,kVIP_30_DAY,kVIP_90_DAY];
    NSString *payID = productIDArray[sender.tag];
    NSInteger day = 0;
    if(sender.tag == 0){
        day = 7;
    }else if(sender.tag == 1){
        day = 30;
    }else if(sender.tag == 2){
        day = 90;
    }
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:@[payID]] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
    
        [[RMStore defaultStore]addPayment:payID success:^(SKPaymentTransaction *transaction) {
            //购买成功
            //keychart保存
            [weakself setVIPWithDay:day];
            [VESTVIPVC isVIP];
            
            [AlertView hiddenLoadingInView:weakself.view];
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            //购买失败
            [AlertView hiddenLoadingInView:weakself.view];
        }];
        
    } failure:^(NSError *error) {
        [AlertView hiddenLoadingInView:weakself.view];
    }];
}

#pragma mark - getter & setter
- (UIButton *)button1
{
    if(!_button1){
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setImage:XWImageName(@"vest_vip3") forState:UIControlStateNormal];
        _button1.tag = 0;
        [_button1 addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2
{
    if(!_button2){
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button2 setImage:XWImageName(@"vest_vip2") forState:UIControlStateNormal];
        _button2.tag = 1;
        [_button2 addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}
- (UIButton *)button3
{
    if(!_button3){
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button3 setImage:XWImageName(@"vest_vip1") forState:UIControlStateNormal];
        _button3.tag = 2;
        [_button3 addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIButton *)restoreButton
{
    if(!_restoreButton){
        _restoreButton = [UIButton creatCommonButtonConfigWithTitle:@"Restore" font:FontBold(16) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        kXWWeakSelf(weakself);
        [_restoreButton setAction:^{
            [AlertView toast:@"Restore failed" inView:weakself.view];
        }];
    }
    return _restoreButton;
}

@end
