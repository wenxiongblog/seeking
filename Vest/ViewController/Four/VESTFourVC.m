//
//  VESTFourVC.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTFourVC.h"
#import "VESTMineHeadView.h"
#import "VEStFourCell.h"
#import "VESTUserTool.h"
#import "VESTSignInVC.h"
#import "LSProtocolViewController.h"
#import "VESTVIPVC.h"
#import "VESTChargeVC.h"

@interface VESTFourVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) VESTMineHeadView *headView;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation VESTFourVC

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headView.headImage = [VESTUserTool GetHeadImageFromLocal];
    self.headView.name = [VESTUserTool name];
    self.headView.age = [VESTUserTool age];
    self.headView.isVIP = [VESTVIPVC isVIP];
    self.headView.coins = [VESTChargeVC currentCoins];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.mainTableView];
}

- (void)baseConstraitsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(30+kStatusBarHeight);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
}

#pragma mark - public
#pragma mark - private
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
    VEStFourCell *cell = [tableView dequeueReusableCellWithIdentifier:kVEStFourCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc]init];
    [view xwDrawbyRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadiuce:10];
    view.backgroundColor = [UIColor whiteColor];
    [header addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(15);
        make.right.equalTo(header).offset(-15);
        make.top.bottom.equalTo(header);
    }];
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
     UIView *header = [[UIView alloc]init];
       header.backgroundColor = [UIColor clearColor];
       
       UIView *view = [[UIView alloc]init];
    [view xwDrawbyRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadiuce:10];
       view.backgroundColor = [UIColor whiteColor];
       [header addSubview:view];
       [view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(header).offset(15);
           make.right.equalTo(header).offset(-15);
           make.top.bottom.equalTo(header);
       }];
       
       return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataArray[indexPath.row];
    if([title containsString:@"User agreement"]){
        //用户协议
        LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
        vc.fileType = 0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title containsString:@"Privacy policy"]){
        //隐私协议
        LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
        vc.fileType = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title containsString:@"Version"]){
        
    }else if([title containsString:@"VIP center"]){
        VESTVIPVC *vc = [[VESTVIPVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title containsString:@"Log out"]){
        //退出登录
        
               UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kLanguage(@"Are you sure you want to Logout?") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
               [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"kVestIsLogin"];
        
               LSBaseNavigationController *nav = [[LSBaseNavigationController alloc]initWithRootViewController:[VESTSignInVC new]];
               UIAlertAction *yesAction = [UIAlertAction actionWithTitle:kLanguage(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               CATransition *transtition = [CATransition animation];
                transtition.duration = 0.3;
                transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
               }];
               
               UIAlertAction *noAction = [UIAlertAction actionWithTitle:kLanguage(@"NO") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   //取消
               }];
               
               //把action添加到actionSheet里
               [actionSheet addAction:yesAction];
               [actionSheet addAction:noAction];
               
               [self presentViewController:actionSheet animated:YES completion:^{
               }];
    }
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
        _mainTableView.tableHeaderView = self.headView;
        [_mainTableView registerClass:[VEStFourCell class] forCellReuseIdentifier:kVEStFourCellIdentifier];
    }
    return _mainTableView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Setting";
    }
    return _titleLabel;
}

- (VESTMineHeadView *)headView
{
    if(!_headView){
        _headView = [[VESTMineHeadView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 240+10)];
        _headView.eventVC = self;
    }
    return _headView;
}

- (NSArray *)dataArray
{
    if([VESTVIPVC isVIP]){
        _dataArray = @[@"User agreement",@"Privacy policy",@"Version",@"Log out"];
    }else{
        _dataArray = @[@"User agreement",@"Privacy policy",@"Version",@"VIP center",@"Log out"];
    }
    return _dataArray;
}

@end
