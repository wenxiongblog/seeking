//
//  LSNotiiLikeView.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotiiLikeView.h"
#import "LSNotiLikeCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJExtension/MJExtension.h>
#import "LSDetailViewController.h"

@interface LSNotiiLikeView()

@end

@implementation LSNotiiLikeView

#pragma mark - publice

- (void)loadDataWithPage:(NSInteger)page
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"page":@(page),
    };
    
    kXWWeakSelf(weakself);
    [self post:kURL_GetILike params:params success:^(Response * _Nonnull response) {
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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        
        self.currentPage = 1;
        [self loadDataWithPage:self.currentPage];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ilikeChange) name:kNotification_Iliked_changed object:nil];
    }
    return self;
}

- (void)ilikeChange
{
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
}


- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [UIColor projectBackGroudColor];
    [self addSubview:self.collectionView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
    return 1;
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

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Noti_Ilike"];
}
// default 描述字段
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"You didn’t like anyone");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// default subtitle 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"Go to users page and like someone");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor xwColorWithHexString:@"#bfbfbf"],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//距离顶部的距离 的偏移
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return YH(-80);
}


@end
