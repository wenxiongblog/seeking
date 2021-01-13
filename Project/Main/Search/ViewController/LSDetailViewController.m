//
//  LSDetailViewController.m
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDetailViewController.h"
#import "LSDetailCell.h"
#import "LSDetailTagsCell.h"
#import "SDCycleScrollView.h"
#import "LSRYChatViewController.h"
#import "LSChooseAlertView.h"
#import "SEEKING_DetileModel.h"
#import "LSDetailDefaultCell.h"
#import "LSPictureScrollView.h"
#import "LSRongYunHelper.h"

@interface LSDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIView *headView;

@property (nonatomic,assign) BOOL isDeleteLike;
@property (nonatomic,assign) BOOL isDeleteCollection;

//滚动图片
@property (nonatomic,strong) LSPictureScrollView *pictureView;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *genderImageView;

//三个button
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIButton *collectBotton;
@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIButton *chatButton;

//滑动页面
@property (nonatomic,strong) UIView *pageView;
@property (nonatomic,strong) NSMutableArray *pageIndexArray;

//数据
@property (nonatomic,assign) BOOL finishLoad;
@property (nonatomic,strong) NSMutableArray <SEEKING_DetileModel *>*sectionArray;

@end

@implementation LSDetailViewController

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //回调是否取消了喜欢 和 收藏
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(kUser.isLogin){
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *bottomWhiteView = [[UIView alloc]init];
    bottomWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomWhiteView];
    [bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.menuView];
}


#pragma mark - private
- (void)blockUser
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure you want to block the user" message:@"After that, this user's profile will not be shown in your Search result page, and he/she can't view or message you any more." preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self postBlockUser];
       }];
       
       UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           //取消
       }];
       
       //把action添加到actionSheet里
       [actionSheet addAction:yesAction];
       [actionSheet addAction:noAction];
       
       [self presentViewController:actionSheet animated:YES completion:^{
       }];
}

- (void)reportUser
{
    [LSChooseAlertView showWithTileArray:@[@"Makes me unconfortable",@"Inappropriate content",@"Pron or stolen photo",@"Spam or scarm",] select:^(NSString * _Nonnull title) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AlertView toast:@"Report success" inView:self.view];
        });
    }];
}

#pragma mark - event
- (void)likeButtonClicked:(UIButton *)sender
{
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
        if(success){
            if(!sender.selected){
                [self likeCustomer];
            }else{
                [self dislikeCustomer];
            }
        }
    }];
}

- (void)collectButtonClicked:(UIButton *)sender
{
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
        if(success){
            if(!sender.selected){
                [self collectCustomer];
            }else{
                [self disCollectCustomer];
            }
        }
    }];
}

#pragma mark - data
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setNullObject:kUser.id forKey:@"userid" replaceObject:@"1"];
    [params setNullObject:self.customer.id forKey:@"id"];
    
    if(kUser.lat > 0 || kUser.lng > 0){
        [params setNullObject:@(kUser.lat) forKey:@"lat"];
        [params setNullObject:@(kUser.lng) forKey:@"lng"];
    }
    
    kXWWeakSelf(weakself);
    
    [self post:KURL_DetailInfo params:params success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            SEEKING_Customer *customer = [SEEKING_Customer mj_objectWithKeyValues:response.content[@"outuser"]];
            weakself.finishLoad = YES;
            //删除照片
           
            weakself.customer = customer;
            
            [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.menuView.frame = CGRectMake(0, kSCREEN_HEIGHT-XW(64)-30, kSCREEN_WIDTH, XW(64));
            } completion:^(BOOL finished) {
                
            }];
        }
    } fail:^(NSError * _Nonnull error) {
        weakself.finishLoad = YES;
        [weakself customer];
    }];
}

- (void)postBlockUser
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"blacklistid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [self post:kURL_BlockUser params:params success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            [AlertView toast:@"You bloked this user!" inView:weakself.view];
        }else{
            [AlertView toast:@"failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView toast:error.description inView:weakself.view];
    }];
}

- (void)likeCustomer
{
    NSDictionary *parame = @{
        @"userid":kUser.id,
        @"likeid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [self post:KURL_Like params:parame success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            weakself.likeButton.selected = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Iliked_changed object:nil];
        }else{
            [AlertView toast:@"Like failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
        [AlertView toast:error.description inView:weakself.view];
    }];
}

- (void)dislikeCustomer
{
    NSDictionary *parame = @{
        @"userid":kUser.id,
        @"likeid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [self post:kURL_CancelMatch params:parame success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            weakself.likeButton.selected = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Iliked_changed object:nil];
        }else{
            [AlertView toast:@"Cancel like failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
        [AlertView toast:error.description inView:weakself.view];
    }];
}

// 收藏
- (void)collectCustomer
{
    NSDictionary *parame = @{
        @"userid":kUser.id,
        @"collectionid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [self post:KURL_CollectCustomer params:parame success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            weakself.collectBotton.selected = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_MyActivity_changed object:nil];
        }else{
            [AlertView toast:@"Collect failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
        [AlertView toast:error.description inView:weakself.view];
    }];
}


// 取消收藏
- (void)disCollectCustomer
{
    
    NSDictionary *parame = @{
        @"userid":kUser.id,
        @"collectionid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [AlertView showLoading:@"" inView:self.view];
    [self post:KURL_DIS_CollectCustomer params:parame success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            weakself.collectBotton.selected = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_MyActivity_changed object:nil];
        }else{
            [AlertView toast:@"Remove collection failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
        [AlertView toast:error.description inView:weakself.view];
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    for(UIView *view in self.pageIndexArray){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    UIView *view = self.pageIndexArray[index];
    view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.finishLoad == NO){
        return 1;
    }else{
        return self.sectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.finishLoad == NO){
        LSDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSDetailDefaultCellIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        SEEKING_DetileModel *model = self.sectionArray[indexPath.row];
        if(model.type == 0){
            LSDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSDetailCellIdentifier forIndexPath:indexPath];
            cell.name = model.title;
            cell.detail = [model.subTitle filter];
            cell.tags = model.subArray;
            return cell;
        }else{
            LSDetailTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSDetailTagsCellIdentifier forIndexPath:indexPath];
            cell.name = model.title;
            cell.tags = model.subArray;
            return cell;
        }
    }
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
    return 160.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Block or Report User") font:FontBold(15) titleColor:[UIColor xwColorWithHexString:@"#C4C4C4"] aliment:UIControlContentHorizontalAlignmentCenter];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(@60);
    }];
    kXWWeakSelf(weakself);
    [button setAction:^{
        [LSChooseAlertView showWithTileArray:@[@"Report",@"Block User",] select:^(NSString * _Nonnull title) {
            if([title isEqualToString:@"Report"]){
                [weakself reportUser];
            } if([title isEqualToString:@"Block User"]){
                [weakself blockUser];
            }else{
                
            }
        }];
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [view addSubview:lineView];
    lineView.backgroundColor = [UIColor xwColorWithHexString:@"#D7D7D7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(50);
        make.right.equalTo(view).offset(-50);
        make.top.equalTo(view);
        make.height.equalTo(@1);
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"asdf");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //偏移到100的时候就dismiss.
    if(scrollView == self.mainTableView){
        CGFloat y = scrollView.contentOffset.y;
        if(y < -100){
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - setter & getter1
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        _mainTableView.backgroundColor = [UIColor projectBackGroudColor];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.estimatedRowHeight=70;
        _mainTableView.rowHeight=UITableViewAutomaticDimension;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headView;
        [_mainTableView registerClass:[LSDetailCell class] forCellReuseIdentifier:kLSDetailCellIdentifier];
        [_mainTableView registerClass:[LSDetailTagsCell class] forCellReuseIdentifier:kLSDetailTagsCellIdentifier];
        [_mainTableView registerClass:[LSDetailDefaultCell class] forCellReuseIdentifier:kLSDetailDefaultCellIdentifier];
    }
    return _mainTableView;
}

- (UIView *)headView
{
    if(!_headView){
//        kXWWeakSelf(weakself);
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, XW(667))];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:self.pictureView];
        [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.headView);
        }];
        
        //向下按钮
        UIImageView *backImageView = [[UIImageView alloc]initWithImage:XWImageName(@"detail_back")];
        [_headView addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView).offset(kStatusBarHeight);
            make.centerX.equalTo(self.headView);
            make.height.equalTo(@10.5);
            make.width.equalTo(@(27.5));
        }];
        
        //阴影
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"jianbian_big")];
        [_headView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.headView);
            make.height.equalTo(@(XW(432)));
        }];
        
        //地址
        [_headView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headView).offset(-45);
            make.centerX.equalTo(self.headView);
        }];
        
        //姓名
        [_headView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headView);
            make.bottom.equalTo(self.addressLabel.mas_top).offset(-10);
        }];
        
        //性别
        [_headView addSubview:self.genderImageView];
        [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addressLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.addressLabel);
            make.width.height.equalTo(@12);
        }];
    
        //滑块
        [_headView addSubview:self.pageView];
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headView).offset(-10);
            make.left.right.equalTo(self.headView);
            make.height.equalTo(@4);
        }];
        
    }
    return _headView;
}

- (UIView *)menuView
{
    if(!_menuView){
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT+20, kSCREEN_WIDTH, XW(64))];
        [_menuView addSubview:self.collectBotton];
        [_menuView addSubview:self.likeButton];
        [_menuView addSubview:self.chatButton];
        
        [self.collectBotton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(XW(52.5)));
            make.left.equalTo(self.likeButton.mas_right).offset(XW(12));;
            make.centerY.equalTo(self.menuView);
        }];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(XW(52.5)));
            make.left.equalTo(self.chatButton.mas_right).offset(XW(12));
            make.centerY.equalTo(self.menuView);
        }];
        [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(XW(52.5)));
            make.width.equalTo(@(XW(217)));
            make.left.equalTo(self.menuView).offset(15);
            make.centerY.equalTo(self.menuView);
        }];
    }
    return _menuView;
}

- (UIButton *)likeButton
{
    if(!_likeButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor xwColorWithHexString:@"#4775CC"];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"detail_taoxin") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"detail_taoxin_ok") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton = button;
    }
    return _likeButton;
}

- (UIButton *)collectBotton
{
    if(!_collectBotton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor xwColorWithHexString:@"#4775CC"];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"detail_collect") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"detail_collect_ok") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _collectBotton = button;
    }
    return _collectBotton;
}

- (UIButton *)chatButton
{
    if(!_chatButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:XWImageName(kLanguage(@"detail_xiaoxi")) forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        [button xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [button setAction:^{
            [JumpUtils jumpLoginModelComplete:^(BOOL success) {
                if(success){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[LSRYChatViewController class]]) {
                                [self.navigationController popToViewController:controller animated:YES];
                            return ;
                        }
                    }
                    
                    LSRYChatViewController *chatVC = [[LSRYChatViewController alloc]initWithSystemInfo:NO];
                    chatVC.conversationType = ConversationType_PRIVATE;
                    chatVC.targetId = weakself.customer.conversationId;
                    chatVC.title = [weakself.customer.name filter];
                    chatVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:chatVC animated:YES];
                }
            }];
        }];
        _chatButton = button;
    }
    return _chatButton;
}

- (UIImageView *)genderImageView
{
    if(!_genderImageView){
        _genderImageView = [[UIImageView alloc]init];
    }
    return _genderImageView;
    
}

- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentCenter];
        _nameLabel.text = @"Name, age";
    }
    return _nameLabel;
}

- (UILabel *)addressLabel
{
    if(!_addressLabel){
        _addressLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor lightGrayColor] font:Font(12) aliment:NSTextAlignmentCenter];
    }
    return _addressLabel;
}

- (LSPictureScrollView *)pictureView
{
    if(!_pictureView){
        _pictureView = [[LSPictureScrollView alloc]init];
        _pictureView.scrollEnable = YES;
        kXWWeakSelf(weakself);
        _pictureView.ScrollToPageBlock = ^(NSInteger page) {
            
            for(UIView *view in weakself.pageIndexArray){
                view.backgroundColor = [UIColor lightGrayColor];
            }
            UIView *view = weakself.pageIndexArray[page];
            view.backgroundColor = [UIColor whiteColor];
            
        };
    }
    return _pictureView;
}

- (UIView *)pageView
{
    if(!_pageView){
        _pageView = [[UIView alloc]init];
    }
    return _pageView;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    //图片
    
    NSMutableArray *imageArray = [NSMutableArray array];
    if(customer.images != nil){
        [imageArray addObject:customer.images];
    }
    NSArray * imagesList = nil;
    if(customer.imageslist.length > 10){
        [customer.imageslist componentsSeparatedByString:@","];
    }
    if(imagesList > 0 && customer.imageslist.length>10){
        [imageArray addObjectsFromArray:imagesList];
    }
    if(imageArray>0){
        self.pictureView.imageArray = imageArray;
    }
    
    //pages
    
    if(imageArray.count <= 1){
        self.pageView.hidden = YES;
    }else{
        self.pageView.hidden = NO;
    }
    CGFloat edge = 15;
    CGFloat space = 10;
    CGFloat width = (kSCREEN_WIDTH-edge*2-(imageArray.count-1)*space)/imageArray.count;
    self.pageIndexArray = [NSMutableArray array];
    //先删除再添加
    for(UIView *view in self.pageView.subviews){
        [view removeFromSuperview];
    }
    for(int i = 0; i<imageArray.count; i++){
        UIView *indexView = [[UIView alloc]initWithFrame:CGRectMake(edge+i*(space + width), 0, width, 3)];
        if(i == 0){
            indexView.backgroundColor = [UIColor whiteColor];
        }else{
            indexView.backgroundColor = [UIColor lightGrayColor];
        }
        [self.pageView addSubview:indexView];
        [indexView xwDrawCornerWithRadiuce:1.5];
        [self.pageIndexArray addObject:indexView];
    }
    
    self.genderImageView.image = (customer.sex == 1)?XWImageName(@"detail_boy"):XWImageName(@"detail_girl");
    
    //姓名 和年龄
    self.nameLabel.text = [NSString stringWithFormat:@"%@,%dyrs",[customer.name filter ],customer.age];
    //城市 和 距离
    self.addressLabel.text = customer.address;
    //喜欢
    self.likeButton.selected = customer.islike;
    //收藏
    self.collectBotton.selected = customer.iscollection;
    
    [self.sectionArray removeAllObjects];
    
    //about
    if(customer.about.length > 0){
        [self.sectionArray addObject:[SEEKING_DetileModel createWithTitle:kLanguage(@"About me") subtitle:[customer.about filter] tags:customer.tags]];
    }
    
    //basic profile
    NSString *height = [NSString stringWithFormat:@"Height:%@in",self.customer.height];
    NSString *weight = [NSString stringWithFormat:@"Weight:%@lb",self.customer.weight];
    if(self.customer.weight.length == 0){
        weight = @"Weight:Secret";
    }
    if(self.customer.height.length == 0){
        height = @"Height:Secret";
    }
    NSString *relationShip = [NSString stringWithFormat:@"Relationship:%@",self.customer.relationship];
    NSString *baseProfile = [NSString stringWithFormat:@"%@\n%@\n%@",height,weight,relationShip];
    [self.sectionArray addObject:[SEEKING_DetileModel createWithTitle:@"Basic information" subtitle:baseProfile tags:@[]]];
    
    //looking for
    if(customer.needfor.length > 0){
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:customer.needfor];
        if(![customer.lookingforage isEqualToString:@"Secrete"]||![customer.lookingforage isEqualToString:@"保密"]){
            [array addObject:customer.lookingforage];
        }
        if(![customer.interested isEqualToString:@"Secrete"]||![customer.interested isEqualToString:@"保密"]){
            [array addObject:customer.interested];
        }
        [self.sectionArray addObject:[SEEKING_DetileModel createWithTitle:@"Looking for" subArray:array]];
    }
    
    [self.mainTableView reloadData];
}

- (NSMutableArray<SEEKING_DetileModel *> *)sectionArray
{
    if(!_sectionArray){
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

@end
