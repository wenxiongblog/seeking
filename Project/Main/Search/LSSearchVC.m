//
//  LSSearchVC.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSearchVC.h"
#import "LSSearchCell.h"
#import "LSDetailViewController.h"
#import "LSFilterViewController.h"
#import "XXRefreshHeader.h"
#import "XXRefreshFooter.h"
#import "LSRongYunHelper.h"
#import "SEEKING_FilterModel.h"
//#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LSLocationManager.h"
#import "LSVIPAlertView.h"
#import "LSMatchLikeView.h"
#import "LSHomeHeaderView.h"
#import "LSSearchPrivilegeVC.h"
#import "LSCuteManVC.h"
#import "LSGirlZhaoHuHealper.h"
#import "LSSearchSayHiCell.h"
#import "FBShimmeringView.h"
#import "CountDownButton.h"

#define kSectionYonghu @"yonghu"

@interface LSSearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
//数据
@property (nonatomic,strong) NSMutableArray <SEEKING_Customer *>*dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) LSHomeHeaderView *headerView;

//临时数据
@property (nonatomic,strong) NSArray *sectionConfigArray;
@end

@implementation LSSearchVC

//埋点
- (void)MDCute_Man_Clicked{};
- (void)MDCute_Woman_Clicked{};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];
    
    //默默去定位一次
    [self locationReload];
    
    //加载一下
    self.currentPage = 1;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.headerView popJumpAnimationView];
}

- (void)locationReload
{
   kXWWeakSelf(weakself);
   [[LSLocationManager share]startLocation:^(BOOL isSuccess, double lan, double lon, NSString * _Nonnull cityName) {
       NSLog(@"%lf  %lf  %@",lan,lon,cityName);
       kUser.lng = lon;
       kUser.lat = lan;
       kUser.address = cityName;
       [weakself homeUploadLocation];
   }];
}

- (void)homeUploadLocation
{
    kXWWeakSelf(weakself);
    [self updateUserInfoWithLoading:NO finish:^(BOOL finished) {
        // 经纬度
        if(finished){
            [weakself UpdateLocation:^(BOOL finished) {
            }];
        }
    }];
}

- (void)loadData:(NSInteger)page
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setNullObject:@(page) forKey:@"page"];
    [params setNullObject:kUser.id forKey:@"id" replaceObject:@"1"];
    
    //金纬度
    if(kUser.lat > 0 || kUser.lng > 0){
        [params setNullObject:@(kUser.lat) forKey:@"lat"];
        [params setNullObject:@(kUser.lng) forKey:@"lng"];
    }
    [params setNullObject:kUser.sex==1?@(2):@(1) forKey:@"sex"];
    
    // 开始筛选
    SEEKING_FilterModel *filterModel = [SEEKING_FilterModel share];
    if([filterModel.isFilter intValue]){
        [params setNullObject:filterModel.sex forKey:@"sex"];
        if([filterModel.startage intValue] >= 18 && [filterModel.endage intValue] >=18 ){
            [params setNullObject:filterModel.startage forKey:@"startage"];
            [params setNullObject:filterModel.endage forKey:@"endage"];
            if(![filterModel.redius isEqualToString:@"0"]){
                [params setNullObject:filterModel.redius forKey:@"distance"];
            }
        }
    }
    
    kXWWeakSelf(weakself);
    [self post:kURL_Filter params:params success:^(Response * _Nonnull response) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        if (response.isSuccess) {
            //如果成功的话
            
            NSArray *dataArray = [response.content objectForKey:@"list"] ;
            NSArray <SEEKING_Customer *>*cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:dataArray];
            //做一次没有信息的用户去除
            NSMutableArray *mutableArray = [NSMutableArray array];
            for(SEEKING_Customer *customer in cutomerArray)
            {
                if(customer.name.length == 0 || customer.age == 0){
                    continue;
                }
                [mutableArray addObject:customer];
            }
            cutomerArray = [NSArray arrayWithArray:mutableArray];
            
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
            }
            
            if(self.currentPage == 1){
                [weakself.dataArray setArray:cutomerArray];
            }else{
                //没有数据当前页面及不要增加
                if(cutomerArray.count == 0){
                    self.currentPage --;
                }else{
                    //有数据就添加到页面中
                    [weakself.dataArray addObjectsFromArray:cutomerArray];
                }
            }
            //刷新数据
            [weakself.collectionView reloadData];
        } else {
            //如果失败的话
            [AlertView toast:response.message inView:weakself.view];
        }
        
    } fail:^(NSError * _Nonnull error) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    self.titleString = kLanguage(@"Search");
    [self.view addSubview:self.collectionView];
    kXWWeakSelf(weakself);
    [self addRightItemWithImage:XWImageName(@"home_search") clickBlock:^{
        LSFilterViewController *vc = [[LSFilterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.filterBlock = ^(BOOL isFilter) {
            if(isFilter){
                weakself.currentPage = 1;
                [weakself loadData:weakself.currentPage];
            }
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)baseConstriantsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionConfigArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *secString = self.sectionConfigArray[section];
    
    if([secString isEqualToString:kSectionYonghu]){
        if(!kUser.isVIP){
            //不是VIP，最多显示10个
            if(self.dataArray.count > 20){
                return 20;
            }else{
                return self.dataArray.count;
            }
        }else{
           return self.dataArray.count;
        }
    }else{
        if(self.dataArray.count >0){
            return 1;
        }else{
            return 0;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *secString = self.sectionConfigArray[indexPath.section];
    if([secString isEqualToString:kSectionYonghu]){
        LSSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSSearchCellIdentifier forIndexPath:indexPath];
        cell.customer = self.dataArray[indexPath.row];
        cell.showDistance = YES;
        return cell;
    }else{
        LSSearchSayHiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSSearchSayHiCellIdentifier forIndexPath:indexPath];
       return cell;
    }
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *secString = self.sectionConfigArray[indexPath.section];
    if([secString isEqualToString:kSectionYonghu]){
        return CGSizeMake(XW(162), XW(207));
    }else{
        return CGSizeMake(XW(336), XW(185));
    }
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10)/2.0;
    NSString *secString = self.sectionConfigArray[section];
    if([secString isEqualToString:kSectionYonghu]){
        return UIEdgeInsetsMake(15, space, 15, space);
    }else{
        return UIEdgeInsetsMake(0, space, 0, space);
    }
}
//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *secString = self.sectionConfigArray[indexPath.section];
    if([secString isEqualToString:kSectionYonghu]){
        LSDetailViewController *vc = [[LSDetailViewController alloc]init];
        vc.customer = self.dataArray[indexPath.row];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
    cell.alpha = 0.8;
    [UIView animateWithDuration:0.35 animations:^{
        cell.alpha = 1;
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

//执行的 footerView高度 代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSString *secString = self.sectionConfigArray[section];
    if([secString isEqualToString:kSectionYonghu]){
        if(self.dataArray.count > 0 && !kUser.isVIP){
            CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10);
            return CGSizeMake(kSCREEN_WIDTH, (kSCREEN_WIDTH-space)/1008*650);
        }
    }
    return CGSizeMake(0, 0);
}

//返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if(self.dataArray.count > 0){
            return CGSizeMake(kSCREEN_WIDTH, XW(165)+10);
        }
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !kUser.isVIP){
        //尾部
        NSString *secString = self.sectionConfigArray[indexPath.section];
        if([secString isEqualToString:kSectionYonghu]){
            if(self.dataArray.count > 0){
                UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
                CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10);
                //图片
                UIImageView *imageView  = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"home_foot_vip"))];
                imageView.frame = CGRectMake(0,0,kSCREEN_WIDTH, (kSCREEN_WIDTH-space)/1008*650);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClicked)];
                [imageView addGestureRecognizer:tap];
                
                //辉光动画
                FBShimmeringView *shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH, (kSCREEN_WIDTH-space)/1008*650)];
                shimmeringView.shimmering = YES;
                shimmeringView.contentView = imageView;
                shimmeringView.shimmeringAnimationOpacity = 0.5;
                [view addSubview:shimmeringView];
                [shimmeringView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
                
                return view;
            }
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            if(self.dataArray.count > 0){
                UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                [view xwDrawCornerWithRadiuce:10];
                [view addSubview:self.headerView];
                self.headerView.isMan = (kUser.sex != 1);
                [self.headerView popJumpAnimationView];
                [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view);
                    make.top.equalTo(view);
                    make.width.equalTo(@(XW(336)));
                    make.height.equalTo(@(XW(165)));
                }];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(priviligeClicked)];
                [self.headerView addGestureRecognizer:tap];
                
                return view;
            }
        }
    }
    return nil;
}

- (void)vipClicked
{
    [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_searchMore];
}

- (void)priviligeClicked
{
    //埋点
    if(kUser.sex == 1){
        [self MDCute_Man_Clicked];
    }else if(kUser.sex == 2){
        [self MDCute_Woman_Clicked];
    }
    
    NSArray *imageArray = nil;
    if(kUser.imageslist.length > 10)
    {
        imageArray = [kUser.imageslist componentsSeparatedByString:@","];
    }
    if(imageArray.count >=2 && kUser.infoPersent > 99){
        LSCuteManVC *vc = [[LSCuteManVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LSSearchPrivilegeVC *vc = [[LSSearchPrivilegeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - setter & getter1
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, XW(165)+10);
        flowLayout.footerReferenceSize = CGSizeMake(kSCREEN_WIDTH, XW(165)+10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSSearchCell class] forCellWithReuseIdentifier:kLSSearchCellIdentifier];
        [_collectionView registerClass:[LSSearchSayHiCell class] forCellWithReuseIdentifier:kLSSearchSayHiCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        // 下拉刷新
        kXWWeakSelf(weakself);
        [_collectionView setMj_header:[XXRefreshHeader headerWithRefreshingBlock:^{
            weakself.currentPage = 1;
            [weakself loadData:weakself.currentPage];
        }]];
        if(kUser.isVIP){
            [_collectionView setMj_footer:[XXRefreshFooter footerWithRefreshingBlock:^{
                self.currentPage = self.currentPage + 1;
                [weakself loadData:self.currentPage];
            }]];
        }else{
            //这里没法自己刷新.购买成功通知 关闭alertView
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puchaseSuccess) name:KNotification_PurchaseSuccess object:nil];
        }
    }
    return _collectionView;
}

- (void)puchaseSuccess
{
    [_collectionView setMj_footer:[XXRefreshFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage + 1;
        [self loadData:self.currentPage];
    }]];
    [self.collectionView reloadData];
}

- (NSMutableArray<SEEKING_Customer *> *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (LSHomeHeaderView *)headerView
{
    if(!_headerView){
        _headerView = [[LSHomeHeaderView alloc]init];
        [_headerView xwDrawCornerWithRadiuce:5];
    }
    return _headerView;
}

- (NSArray *)sectionConfigArray
{
//    if(!_sectionConfigArray){
        if(kUser.sex == 2){
            _sectionConfigArray = @[@"zhaohu",kSectionYonghu];
        }else{
            _sectionConfigArray = @[kSectionYonghu];
        }
//    }
    return _sectionConfigArray;
}
@end
