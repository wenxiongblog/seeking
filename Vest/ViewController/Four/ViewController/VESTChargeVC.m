//
//  VESTChargeVC.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTChargeVC.h"
#import "VESTChargeCell.h"
#import <RMStore.h>
#import <SAMKeychain/SAMKeychain.h>

@interface VESTChargeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UIView *moneyView;
@property (nonatomic,strong) UIImageView *coinImageView;
@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation VESTChargeVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraitsConfig];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - baseConfig
- (void)baseUIConfig
{
    //nav 配置
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    self.backButton.hidden = NO;
    [self.backButton setImage:XWImageName(@"vest_back") forState:UIControlStateNormal];
    self.titleString = @"Recharge";
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.font = FontBold(24);
    self.navTitleLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44);
    
    [self.view addSubview:self.mainTableView];
}
- (void)baseConstraitsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom).offset(10);
    }];
}
#pragma mark - public
#pragma mark - private

- (void)purchaseWithIndex:(NSInteger)index
{
    NSArray *productIDArray = @[@"coins_60",@"coins_300",@"coins_600",@"coins_1500",@"coins_3000",@"coins_7000"];
    NSString *payID = productIDArray[index];
    NSInteger coins = 0;
    switch (index) {
            case 0:{coins = 60;}
            break;
            case 1:{coins = 300;}
            break;
            case 2:{coins = 600;}
            break;
            case 3:{coins = 1500;}
            break;
            case 4:{coins = 3000;}
            break;
            case 5:{coins = 7000;}
            break;
        default:
            break;
    }
    
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:@[payID]] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
    
        [[RMStore defaultStore]addPayment:payID success:^(SKPaymentTransaction *transaction) {
            //购买成功
            //keychart保存
            [VESTChargeVC addCoins:coins];
            weakself.countLabel.text = [NSString stringWithFormat:@"%ld",[VESTChargeVC currentCoins]];
            [AlertView hiddenLoadingInView:weakself.view];
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            //购买失败
            [AlertView hiddenLoadingInView:weakself.view];
        }];
        
    } failure:^(NSError *error) {
        [AlertView hiddenLoadingInView:weakself.view];
    }];
}


+ (void)addCoins:(NSInteger)coins
{
    NSInteger currentCoin = [VESTChargeVC currentCoins];
    currentCoin = currentCoin + coins;
    NSString *string = [NSString stringWithFormat:@"%ld",currentCoin];
    [SAMKeychain setPassword:string forService:@"service2" account:@"coins"];
}
+ (BOOL)costCoins:(NSInteger)coins
{
    NSInteger currentCoin = [VESTChargeVC currentCoins];
    if(currentCoin >= coins){
        currentCoin = currentCoin - coins;
        NSString *string = [NSString stringWithFormat:@"%ld",currentCoin];
        [SAMKeychain setPassword:string forService:@"service2" account:@"coins"];
        return YES;
    }else{
        return NO;
    }
}

+ (NSInteger)currentCoins
{
    NSString *str = [SAMKeychain passwordForService:@"service2" account:@"coins"];
    NSInteger coins = [str integerValue];
    return coins;
}


#pragma mark - event

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VESTChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:kVESTChargeCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self purchaseWithIndex:indexPath.row];
}
#pragma mark - setter & getter
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[VESTChargeCell class] forCellReuseIdentifier:kVESTChargeCellIdentifier];
        
        //头部
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 130)];
        [headview addSubview:self.moneyView];
        [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headview).offset(18);
            make.right.equalTo(headview).offset(-18);
            make.top.bottom.equalTo(headview);
        }];
        _mainTableView.tableHeaderView = headview;
    }
    return _mainTableView;
}

- (UIView *)moneyView
{
    if(!_moneyView){
        _moneyView = [[UIView alloc]init];
        _moneyView.backgroundColor = [UIColor whiteColor];
        [_moneyView xwDrawCornerWithRadiuce:10];
        
        [_moneyView addSubview:self.coinImageView];
        [_moneyView addSubview:self.countLabel];
        [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
            make.height.equalTo(@40);
            make.centerY.equalTo(self.moneyView);
            make.left.equalTo(self.moneyView).offset(40);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moneyView).offset(-43);
            make.centerY.equalTo(self.coinImageView);
        }];
    }
    return _moneyView;
}

- (UIImageView *)coinImageView
{
    if(!_coinImageView){
        _coinImageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_coins")];
    }
    return _coinImageView;
}

- (UILabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#171351"] font:FontBold(24) aliment:NSTextAlignmentLeft];
        _countLabel.text = [NSString stringWithFormat:@"%ld",[VESTChargeVC currentCoins]];
    }
    return _countLabel;
}

- (NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"60",@"300",@"600",@"1500",@"3000",@"7000"];
    }
    return _dataArray;
}

@end
