//
//  LSMineActivityVC.m
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineActivityVC.h"
#import "LSNotiLikeCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LSDetailViewController.h"
#import "XXRefreshHeader.h"
#import "XXRefreshFooter.h"
#import "LSRongYunHelper.h"

@interface LSMineActivityVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;

//shuju
@property (nonatomic,strong) NSMutableArray <SEEKING_Customer *>*dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation LSMineActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    
    //加载第一页
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityChange) name:kNotification_MyActivity_changed object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)activityChange
{
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
}

#pragma mark - data
- (void)loadDataWithPage:(NSInteger)page
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"page":@(page),
    };
    
    kXWWeakSelf(weakself);
    [self post:kURL_GetCollection params:params success:^(Response * _Nonnull response) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        if(response.isSuccess){
            NSLog(@"%@",response);
            NSArray *array = (NSArray *)response.content;
            NSArray <SEEKING_Customer *> *cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:array];
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
            }
            
            //如果是第一页重置数据
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
            
            [self.collectionView reloadData];
        }else{
            
        }
    } fail:^(NSError * _Nonnull error) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - baseConfig1

- (void)SEEKING_baseUIConfig
{
    [self speciceNavWithTitle:kLanguage(@"My activities")];

    [self.view addSubview:self.collectionView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}


#pragma mark - SEEKING_baseUIConfig

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSNotiLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSNotiLikeCellIdentifier forIndexPath:indexPath];
    cell.customer = self.dataArray[indexPath.row];
    return cell;
}
//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(XW(335), XW(90));
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, (kSCREEN_WIDTH-XW(335))/2.0, 15, (kSCREEN_WIDTH-XW(335))/2.0);
}
//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.5;
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
    [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
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

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Mine_empty"];
}
// default 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"No data");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//距离顶部的距离 的偏移
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return YH(-80);
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
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        [_collectionView registerClass:[LSNotiLikeCell class] forCellWithReuseIdentifier:kLSNotiLikeCellIdentifier];
        
        // 下拉刷新
       kXWWeakSelf(weakself);
       [_collectionView setMj_header:[XXRefreshHeader headerWithRefreshingBlock:^{
           self.currentPage = 1;
           [weakself loadDataWithPage:self.currentPage];
       }]];
       [_collectionView setMj_footer:[XXRefreshFooter footerWithRefreshingBlock:^{
           self.currentPage = self.currentPage + 1;
           [weakself loadDataWithPage:self.currentPage];
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
