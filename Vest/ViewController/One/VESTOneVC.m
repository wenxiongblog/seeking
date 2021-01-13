//
//  VESTOneVC.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTOneVC.h"
#import "LSOneCell.h"
#import "VESTLiveVC.h"
#import "LSCreateAlertView.h"
#import "VESTDataTool.h"
#import "VESTVIPVC.h"

@interface VESTOneVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *addButton;


@property (nonatomic,strong) NSArray <VESTUserModel *>*dataarray;

@end

@implementation VESTOneVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //vip每天多40个币
    [VESTVIPVC getVIPCoins];
    
    [self baseUIConfig];
    [self baseConstraitsConfig];
    self.dataarray = [NSArray arrayWithArray:[VESTDataTool allYuyinUser]];
    [self.mainTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.mainTableView];
}
- (void)baseConstraitsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(30+kStatusBarHeight);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-15);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.view);
    }];
}
#pragma mark - public
#pragma mark - private
#pragma mark - event
#pragma mark - getter & setter
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSOneCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSOneCellIdentifier forIndexPath:indexPath];
    cell.userModel = self.dataarray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 166;
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
    VESTLiveVC *vc = [[VESTLiveVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userModel = self.dataarray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_mainTableView registerClass:[LSOneCell class] forCellReuseIdentifier:kLSOneCellIdentifier];
    }
    return _mainTableView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Voice chat";
    }
    return _titleLabel;
}
- (UIButton *)addButton
{
    if(!_addButton){
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:XWImageName(@"vest_addBtn") forState:UIControlStateNormal];
        [_addButton setAction:^{
            LSCreateAlertView *alertView = [[LSCreateAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
            alertView.eventVC = self;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            [alertView appearAnimation];
        }];
    }
    return _addButton;
}

@end
