//
//  LSMineVC.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//  

#import "LSMineVC.h"
#import "LSMeCell.h"
#import "LSMineSettingVC.h"
#import "LSMineActivityVC.h"
#import "LSMineEditVC.h"
#import "SEEKING_CustomerLoadingView.h"
#import "LSVIPAlertView.h"
#import "LSMineFeedBackVC.h"
#import "LSVIPAlertView.h"
#import "LSUploadPhotoVC.h"
#import "LSMinePCNav.h"
#import "LSMineCPConfig.h"
#import "LSVIPAlertView.h"
#import "LSMineSectionHeader.h"
#import "LSIncognitoModeCell.h"
#import "LSMineFeatureVC.h"

@interface LSMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIImageView *addressImageview;
@property (nonatomic,strong) UIImageView *genderImageView;
@property (nonatomic,strong) UIImageView *priorImageView; //prior

//updateButton
@property (nonatomic,strong) UIButton *updateButton;
//数据
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation LSMineVC

#pragma mark - 埋点方法

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
}

- (void)extracted:(UINavigationController *)nav {
    [self presentViewController:nav animated:YES
                     completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SEEKING_Customer *customer = kUser;
    NSLog(@"%@",customer.conversationId);
    
    //判断是否需要上传相册  这里退出登录的时候会有bug
   if(kUser.imageslist.length == 0){
       [JumpUtils jumpLoginModelComplete:^(BOOL success) {
           if(success){
               LSUploadPhotoVC *vc = [[LSUploadPhotoVC alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
               nav.modalPresentationStyle = 0;
               [self extracted:nav];
           }
       }];
   }
    
    //个人信息
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:kUser.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
    self.headImageView.userInteractionEnabled = !kUser.isLogin;
    
    //编辑按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:XWImageName(@"Mine_add") forState:UIControlStateNormal];
    [self.headView addSubview:button];
    [button setAction:^{
        kXWWeakSelf(weakself);
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
           if(success){
               LSMineEditVC *vc = [[LSMineEditVC alloc]init];
               vc.hidesBottomBarWhenPushed = YES;
               [weakself.navigationController pushViewController:vc animated:YES];
           }
        }];
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImageView).offset(-6);
        make.bottom.equalTo(self.headImageView).offset(-6);
        make.width.height.equalTo(@35);
    }];
    
    //刷新值
    if(kUser.name.length > 0){
        self.nameLabel.text = [NSString stringWithFormat:@"%@,%dyrs",[kUser.name filter],kUser.age];
    }else{
        self.nameLabel.text = @"Please login";
    }
    self.addressLabel.text = kUser.address;
    self.addressImageview.hidden = (self.addressLabel.text.length == 0);
    
    //tableview
    [self.mainTableView reloadData];
    
    //VIP
    if(!kUser.isVIP && kUser.infoPersent == 0){
        self.updateButton.hidden = NO;
    }else{
        self.updateButton.hidden = YES;
    }
    
    if(kUser.isVIP){
        self.priorImageView.hidden = NO;
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headView).offset(30);
        }];
    }else{
        self.priorImageView.hidden = YES;
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headView).offset(6);
        }];
    }
}

#pragma mark - private
- (void)editClicked
{
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
               if(success){
               }
           }];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    [self.view addSubview:self.mainTableView];
    //右边 Edit
    UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Edit") font:Font(17) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentRight];
    [button setAction:^{
        kXWWeakSelf(weakself);
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
           if(success){
               LSMineEditVC *vc = [[LSMineEditVC alloc]init];
               vc.hidesBottomBarWhenPushed = YES;
               [weakself.navigationController pushViewController:vc animated:YES];
           }
        }];
    }];
    button.frame = CGRectMake(kSCREEN_WIDTH-80-5 - 10, kStatusBarHeight, 80, 44);
    [self.view addSubview:button];
    [self.view bringSubviewToFront:self.rightItemButton];
    //左边 upgrade
    [self.view addSubview:self.updateButton];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(button);
    }];
    
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
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
    NSString *title = self.dataArray[indexPath.row];
    if([title isEqualToString:@"Incognito mode"]){
        LSIncognitoModeCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSIncognitoModeCellIdentifier forIndexPath:indexPath];
        cell.name = title;
        cell.isIncognito = kUser.incognito;
        cell.ISIncognitoBlock = ^(int isIncoginito) {
            NSLog(@"%d",isIncoginito);
            kUser.incognito = isIncoginito;
//            kXWWeakSelf(weakself);
            [self updateUserInfoWithLoading:NO finish:^(BOOL finished) {
                //
//                [weakself.mainTableView reloadData];
            }];
        };
        return cell;
    }else{
        LSMeCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSMeCellIdentifier forIndexPath:indexPath];
        cell.name = self.dataArray[indexPath.row];
        if([cell.name isEqualToString:@"Profile"]){
            cell.isPersent = YES;
            cell.persent = kUser.infoPersent;
        }else{
            cell.isPersent = NO;
        }
        
        if(indexPath.row == 0){
            cell.isTop = YES;
        }
        
        if(indexPath.row == self.dataArray.count - 1){
            cell.isBottom = YES;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataArray[indexPath.row];
    if([title isEqualToString:@"Incognito mode"]){
        return 85;
    }else{
        return 65.;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(kUser.infoPersent == 0){
        return 80.0;
    }else{
        if(!kUser.isVIP){
            return 80.0;
        }else{
            return 0.01;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(kUser.infoPersent == 0){
        LSMineSectionHeader *view = [[LSMineSectionHeader alloc]init];
        view.vipSection = NO;
        view.SectionHeaderBlock = ^{
            [JumpUtils jumpLoginModelComplete:^(BOOL success) {
                if(success){
                    if(kUser.infoPersent < 60){
                        LSMineCPConfig *config = [[LSMineCPConfig alloc]init];
                        LSMinePCNav *nav = [[LSMinePCNav alloc]initWithRootViewController:config.vc];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:nav animated:YES completion:nil];
                    }else{
                        LSMineEditVC *vc = [[LSMineEditVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
            }];
        };
        return view;
    }else{
        if(!kUser.isVIP){
            
            LSMineSectionHeader *view = [[LSMineSectionHeader alloc]init];
            view.vipSection = YES;
            view.SectionHeaderBlock = ^{
                 [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_Setting];
            };
            return view;
            
        }else{
            return nil;
        }
    }
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
    //My activities
    if(indexPath.row == 1){
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
            if(success){
                LSMineActivityVC *vc = [[LSMineActivityVC alloc]init];
                           vc.hidesBottomBarWhenPushed = YES;
                           [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    // My features
    if(indexPath.row == 2){
        LSMineFeatureVC *vc = [[LSMineFeatureVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // Profile
    if(indexPath.row == 3){
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
            if(success){
                if(kUser.infoPersent < 60){
                    LSMineCPConfig *config = [[LSMineCPConfig alloc]init];
                    LSMinePCNav *nav = [[LSMinePCNav alloc]initWithRootViewController:config.vc];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:nav animated:YES completion:nil];
                }else{
                    LSMineEditVC *vc = [[LSMineEditVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
    // Feedback
    if(indexPath.row == 4){
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
            if(success){
                LSMineFeedBackVC *vc = [[LSMineFeedBackVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    //Settings
    if(indexPath.row == 5){
        [JumpUtils jumpLoginModelComplete:^(BOOL success) {
            if(success){
                LSMineSettingVC *vc = [[LSMineSettingVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 20 && scrollView.contentOffset.y>-20){
        self.headImageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1-0.005*(scrollView.contentOffset.y), 1-0.005*(scrollView.contentOffset.y), 1.0);
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
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headView;
        
        [_mainTableView registerClass:[LSMeCell class] forCellReuseIdentifier:kLSMeCellIdentifier];
        [_mainTableView registerClass:[LSIncognitoModeCell class] forCellReuseIdentifier:kLSIncognitoModeCellIdentifier];
    }
    return _mainTableView;
}

- (UIView *)headView
{
    if(!_headView){
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kStatusBarHeight+30+XW(150)+80)];
        
        //头像
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-XW(150)-40)/2.0, kStatusBarHeight+30, XW(150), XW(150))];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView.backgroundColor = [UIColor xwColorWithHexString:@"#4C5971"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editClicked)];
        self.headImageView.userInteractionEnabled = YES;
        [self.headImageView addGestureRecognizer:tap];
        
        [self.headImageView xwDrawCornerWithRadiuce:XW(75)];
        [_headView addSubview:self.headImageView];

        //名称
        self.nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentCenter];
        self.nameLabel.text = kUser.name;
        [_headView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headView);
            make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        }];
       
        //性别
        self.genderImageView = [[UIImageView alloc]init];
        self.genderImageView.image = (kUser.sex == 1)?XWImageName(@"detail_boy"):XWImageName(@"detail_girl");
        self.genderImageView.hidden = YES;
        [_headView addSubview:self.genderImageView];
        [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.right.equalTo(self.nameLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.nameLabel);
        }];
        
        //位置
        self.addressLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#CDCED2"] font:Font(12) aliment:NSTextAlignmentCenter];
        self.addressLabel.text = @"New York";
        [_headView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headView).offset(6);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        UIImageView *addressImageview = [[UIImageView alloc]initWithImage:XWImageName(@"Mine_location")];
        self.addressImageview = addressImageview;
        [_headView addSubview:addressImageview];
        addressImageview.contentMode = UIViewContentModeScaleAspectFit;
        [addressImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(12));
            make.centerY.equalTo(self.addressLabel);
            make.right.equalTo(self.addressLabel.mas_left).offset(-5);
        }];
        
        //prior
        [_headView addSubview:self.priorImageView];
        [self.priorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@48);
            make.height.equalTo(@16.5);
            make.centerY.equalTo(self.addressLabel);
            make.right.equalTo(self.addressImageview.mas_left).offset(-5);
        }];
        
    }
    return _headView;
}

- (UIButton *)updateButton
{
    if(!_updateButton){
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setBackgroundImage:XWImageName(kLanguage(@"Mine_UPGRADE")) forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_updateButton setAction:^{
            [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_Setting];
        }];
    }
    return _updateButton;
}

- (NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"Incognito mode",@"My activities",@"My features", @"Profile",@"Feedback",@"Settings"];
    }
    return _dataArray;
}

- (UIImageView *)priorImageView
{
    if(!_priorImageView){
        _priorImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"prior"))];
    }
    return _priorImageView;
}
@end
