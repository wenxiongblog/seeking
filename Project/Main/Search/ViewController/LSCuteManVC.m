//
//  LSCuteManVC.m
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSCuteManVC.h"
#import "LSCuteManCell.h"
#import "LSRongYunHelper.h"
#import "XXRefreshHeader.h"
#import "LSDetailViewController.h"
#import "LSVIPAlertView.h"

@interface LSCuteManVC ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray <SEEKING_Customer *>*dataArray;

@end

@implementation LSCuteManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData:(BOOL)isBottom
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    int sex = kUser.sex==1?2:1;
    [params setNullObject:@(sex) forKey:@"sex"];
    [params setNullObject:kUser.id forKey:@"id" replaceObject:@"1"];
    
    NSString * urlString = KURL_ElileMan;
    
    kXWWeakSelf(weakself);
    [self post:urlString params:params success:^(Response * _Nonnull response) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        if (response.isSuccess) {
            
            //如果成功的话
            NSArray *dataArray = [response.content objectForKey:@"list"] ;
            NSArray <SEEKING_Customer *>*cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:dataArray];
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
            }
            
            if(!isBottom){
                //顶部重置数组
                [weakself.dataArray setArray:cutomerArray];
            }else{
                //底部 添加数据
                [weakself.dataArray addObjectsFromArray:cutomerArray];
            }
            //刷新数据
            [weakself.collectionView reloadData];
        } else {
            //如果失败的话
            [AlertView toast:response.message inView:weakself.view];
        }
        
    } fail:^(NSError * _Nonnull error) {
//        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentCenter];
    if(kUser.sex == 1){
        label.text = @"Cute girls";
    }else{
        label.text = @"Elite men";
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:XWImageName(@"Elite_Close") forState:UIControlStateNormal];
    self.backButton.hidden = YES;
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backButton);
    }];
    kXWWeakSelf(weakself);
    [backButton setAction:^{
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.collectionView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!kUser.isVIP){
        //不是VIP，最多显示10个
        if(self.dataArray.count > 10){
            return 10;
        }else{
            return self.dataArray.count;
        }
    }else{
       return self.dataArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSCuteManCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSCuteManCellIdentifier forIndexPath:indexPath];
    cell.customer = self.dataArray[indexPath.row];
    return cell;
}
//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(XW(337), XW(430));
}
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSDetailViewController *vc = [[LSDetailViewController alloc]init];
    vc.customer = self.dataArray[indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(self.dataArray.count > 0 && !kUser.isVIP){
        CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10);
        return CGSizeMake(kSCREEN_WIDTH, (kSCREEN_WIDTH-space)/1008*650);
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && !kUser.isVIP){
        if(self.dataArray.count > 0){
            UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
            UIImageView *imageView  = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"home_foot_vip"))];
            [view addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClicked)];
            [imageView addGestureRecognizer:tap];
            
            return view;
        }
    }
    return nil;
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

- (void)vipClicked
{
    [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_cute];
}

#pragma mark - setter & getter1
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSCuteManCell class] forCellWithReuseIdentifier:kLSCuteManCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        kXWWeakSelf(weakself);
        //下拉刷新
        [_collectionView setMj_header:[XXRefreshHeader headerWithRefreshingBlock:^{
            [weakself loadData:NO];
        }]];
        //上拉加载YES
        [_collectionView setMj_footer:[XXRefreshFooter footerWithRefreshingBlock:^{
            [weakself loadData:YES];
        }]];
        
    }
    return _collectionView;
}

- (NSMutableArray<SEEKING_Customer *> *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
