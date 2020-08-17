//
//  LSMineSettingVC.m
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineSettingVC.h"
#import "LSMyEditCell.h"
#import "LSRongYunHelper.h"
#import "LSProtocolViewController.h"
#import "LSPurchaseManager.h"
#import "LSDeleteAcountAlertView.h"

@interface LSMineSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UIButton *destroyButton;
@end

@implementation LSMineSettingVC

//埋点
- (void)MDDeleteCount_open{}
- (void)MDDeleteCount_success{}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];
}

#pragma mark - data
- (void)destroyAccount
{
    NSDictionary *param = @{
        @"uid":kUser.id,
    };
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    [self post:KURL_DestroyAccount params:param success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            //埋点
            [self MDDeleteCount_success];
            //退出登录
            [self logout];
        }else{
            [AlertView toast:@"failed" inView:self.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
    }];
}

#pragma mark - privite
- (void)logout
{
    //退出登录
      [kUser clear];
      kUser.isLogin = NO;
      //融云退出登录
      [LSRongYunHelper logout];
      //回到主目录
      [self.navigationController popViewControllerAnimated:NO];
      //回到主界面
      [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Logout_TabChanged object:nil];
      //去登陆界面
      [JumpUtils jumpLoginModelComplete:^(BOOL success) {}];
}

- (void)destroy{
    if(kUser.uid.length == 0){
        return;
    }
    NSDictionary *params = @{
        @"uid":kUser.uid,
    };
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    kXWWeakSelf(weakself);
    [self post:KURL_DestroyAccount params:params success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            [weakself logout];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
    }];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self speciceNavWithTitle:kLanguage(@"Settings")];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.destroyButton];
}

- (void)baseConstriantsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.destroyButton.mas_top);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
    [self.destroyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(kUser.isVIP){
        return self.titleArray.count - 1;
    }else{
        return self.titleArray.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.titleArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMyEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSMyEditCellIdentifier forIndexPath:indexPath];
    NSArray *array = self.titleArray[indexPath.section];
    cell.type = LSMyEditCellType_Choose;
    cell.name = kLanguage(array[indexPath.row]);
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
    return 10.00;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.titleArray[indexPath.section];
    NSString  *title = array[indexPath.row];
    
    if([title isEqualToString:@"Terms of Use"]){
        LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
        vc.fileType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"Privacy Policy"]){
        LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
        vc.fileType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"Logout"]){
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kLanguage(@"Are you sure you want to Logout?") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:kLanguage(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self logout];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:kLanguage(@"NO") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //取消
        }];
        
        //把action添加到actionSheet里
        [actionSheet addAction:yesAction];
        [actionSheet addAction:noAction];
        
        [self presentViewController:actionSheet animated:YES completion:^{
        }];
    }else if([title isEqualToString:@"Delete Account"]){
        
        if([LSDeleteAcountAlertView show]){
            return;
        }
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure to Delete account" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self destroy];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //取消
        }];

        //把action添加到actionSheet里
        [actionSheet addAction:yesAction];
        [actionSheet addAction:noAction];
        
        [self presentViewController:actionSheet animated:YES completion:^{
        }];
    }else if([title isEqualToString:@"Restore"]){
        kXWWeakSelf(weakself);
        [LSPurchaseManager restore:^(BOOL isSuccess) {
            if(isSuccess){
                [weakself.mainTableView reloadData];
            }else{
                
            }
        }];
    }
}


#pragma mark - setter & getter1
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
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[LSMyEditCell class] forCellReuseIdentifier:kLSMyEditCellIdentifier];
    }
    return _mainTableView;
}

- (NSMutableArray *)titleArray
{
    if(!_titleArray){
        
        _titleArray = [NSMutableArray array];
        
        [_titleArray addObject:@[@"Terms of Use",@"Privacy Policy"]];
        [_titleArray addObject:@[@"Delete Account"]];
        [_titleArray addObject:@[@"Logout"]];
        [_titleArray addObject:@[@"Restore"]];
    }
    return _titleArray;
}

- (UIButton *)destroyButton
{
    if(!_destroyButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:@"Delete account" font:Font(18) titleColor:[UIColor xwColorWithHexString:@"#111111"] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
//        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        kXWWeakSelf(weakself);
        [button setAction:^{
            
            //埋点
           [weakself MDDeleteCount_open];
            
           UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure you want to Delete account?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
           
           UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [weakself destroyAccount];
           }];
           
           UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               //取消
           }];
           
           //把action添加到actionSheet里
           [actionSheet addAction:yesAction];
           [actionSheet addAction:noAction];
           
           [self presentViewController:actionSheet animated:YES completion:^{
           }];
            
        }];
        
        _destroyButton = button;
        _destroyButton.alpha = 0.0;
    }
    return _destroyButton;
}

@end
