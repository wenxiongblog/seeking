//
//  DYEditVC.m
//  DeYang
//
//  Created by XuWen on 2020/10/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "DYEditVC.h"
#import "DYEditCell.h"
#import "DYEditNameVC.h"
#import <WXApi.h>
#import <UIButton+WebCache.h>

@interface DYEditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIButton *logOutButton;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *headButton;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation DYEditVC

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
    [self uploadUserInfo];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)uploadUserInfo
{
    kXWWeakSelf(weakself);
    [kUser queryUserInfo:^(BOOL success, NSString * _Nonnull msg) {
        [weakself.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:kUser.headImg] forState:UIControlStateNormal];
        [weakself.mainTableView reloadData];
    }];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.backButton.hidden = NO;
    self.titleString = @"个人信息";
    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.logOutButton];
}

- (void)baseConstraitsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-60-20);
    }];
    [self.logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
        make.height.equalTo(@45);
    }];
}

#pragma mark - event
- (void)logOff
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"你确定要退出登录吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //退出登录
                            //1.标记为退出
                            kUser.isLogin = NO;
                            [kUser clear];
                            //pop到根目录 我的界面
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                            });

                            [JumpUtils jumpLoginModelComplete:^(BOOL success) {
                                
                            }];
                  }];
                  
                  UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                      //取消
                  }];
                  
                  //把action添加到actionSheet里
                  [actionSheet addAction:yesAction];
                  [actionSheet addAction:noAction];
                  
                  [self presentViewController:actionSheet animated:YES completion:^{
                  }];
}


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
    DYEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kDYEditCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.;
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
    DYEditModel *model = self.dataArray[indexPath.row];
    model.doneBlock();
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
        [_mainTableView registerClass:[DYEditCell class] forCellReuseIdentifier:kDYEditCellIdentifier];
    }
    return _mainTableView;
}

#pragma mark - public
#pragma mark - private
#pragma mark - event
#pragma mark - getter & setter
- (UIButton *)logOutButton
{
    if(!_logOutButton){
        _logOutButton = [UIButton creatCommonButtonConfigWithTitle:@"退出登录" font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_logOutButton xwDrawCornerWithRadiuce:5];
        _logOutButton.backgroundColor = [UIColor themeColor];
        [_logOutButton addTarget:self action:@selector(logOff) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutButton;
}

- (UIView *)headView
{
    if(!_headView){
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
        [_headView addSubview:self.headButton];
        [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@70);
            make.centerX.equalTo(self.headView);
            make.top.equalTo(self.headView).offset(30);
        }];
        
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontBold(17) aliment:NSTextAlignmentLeft];
        label.text = @"基本信息";
        [_headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset(15);
            make.top.equalTo(self.headButton.mas_bottom).offset(15);
        }];
    }
    return _headView;
}

- (UIButton *)headButton
{
    if(!_headButton){
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton xwDrawCornerWithRadiuce:5];
        _headButton.backgroundColor = [UIColor darkGrayColor];
        kXWWeakSelf(weakself);
        [_headButton setAction:^{
            ImagePicker *picker = [[ImagePicker alloc] init];
            [picker setAllowCropSwitch:YES];
             [picker showPickerView:@"请选择用户头像" vc:weakself complete:^(NSArray<UIImage *> * _Nonnull images) {
                 if (images.count > 0){
                     [AlertView showLoading:@"" inView:weakself.view];
                     [kUser uploadHeadImage:images[0] complete:^(BOOL success, NSString * _Nonnull msg) {
                         [AlertView hiddenLoadingInView:weakself.view];
                         if(success){
                             NSLog(@"%@",msg);
                             [weakself.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:kUser.headImg] forState:UIControlStateNormal];
                         }else{
                             [AlertView toast:msg inView:weakself.view];
                         }
                     }];
                 }
             }];
        }];
    }
    return _headButton;
}

- (NSArray *)dataArray
{
    kXWWeakSelf(weakself);
    DYEditModel *model1 = [[DYEditModel alloc]initWithName:@"昵称：" content:kUser.nickName placeholder:@"请编辑昵称" block:^{
        DYEditNameVC *vc = [[DYEditNameVC alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
    }];
    DYEditModel *model2 = [[DYEditModel alloc]initWithName:@"账号：" content:kUser.phoneNumberMin placeholder:@"账号" block:^{
    }];
    DYEditModel *model3 = [[DYEditModel alloc]initWithName:@"真实姓名：" content:kUser.realNameMin placeholder:@"请进行实名认证" block:^{
//        [AlertView toast:@"实名认证" inView:weakself.view];
        [JumpUtils jumpWeChatToRenZheng];
    }];
    DYEditModel *model4 = [[DYEditModel alloc]initWithName:@"身份证号：" content:kUser.idNumberMin placeholder:@"请进行实名认证" block:^{
//        [AlertView toast:@"实名认证" inView:weakself.view];
        [JumpUtils jumpWeChatToRenZheng];
    }];
    DYEditModel *model5= [[DYEditModel alloc]initWithName:@"邮箱地址：" content:kUser.email placeholder:@"未设置邮箱地址" block:^{
    }];
    _dataArray = @[model1,model2,model3,model4,model5];
    return _dataArray;
}




@end


