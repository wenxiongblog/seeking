//
//  VESTThreeVC.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTThreeVC.h"
#import "LSMessageCell.h"
#import "LSThreeMsgVC.h"
#import "VESTSaveMessageTool.h"

@interface VESTThreeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation VESTThreeVC

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
    self.dataArray = [NSArray arrayWithArray:[VESTSaveMessageTool getAllConversation]];
    [self.mainTableView reloadData];
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.view);
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
    LSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSMessageCellIdentifier forIndexPath:indexPath];
    cell.messageModel = self.dataArray[indexPath.row];
    return cell;
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
    LSThreeMsgVC *vc = [[LSThreeMsgVC alloc]init];
    VESTMessageModel *messageModel = self.dataArray[indexPath.row];
    VESTUserModel *userModel = [[VESTUserModel alloc]init];
    userModel.name = messageModel.name;
    userModel.headUrl = messageModel.headUrl;
    vc.userModel = userModel;
    vc.hidesBottomBarWhenPushed = YES;
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
        [_mainTableView registerClass:[LSMessageCell class] forCellReuseIdentifier:kLSMessageCellIdentifier];
        _mainTableView.estimatedRowHeight=100;
        _mainTableView.rowHeight=UITableViewAutomaticDimension;
    }
    return _mainTableView;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Message";
    }
    return _titleLabel;
}

@end
