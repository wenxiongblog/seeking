//
//  LSNotiBaseView.m
//  Project
//
//  Created by XuWen on 2020/3/15.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotiBaseView.h"
#import "LSSearchCell.h"
#import "LSNotiLikeCell.h"
#import "XXRefreshHeader.h"
#import "XXRefreshFooter.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LSVIPAlertView.h"

@interface LSNotiBaseView ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation LSNotiBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        if(!kUser.isVIP){
            //这里没法自己刷新.购买成功通知 关闭alertView
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puchaseSuccess) name:KNotification_PurchaseSuccess object:nil];
        }
    }
    return self;
}

- (void)puchaseSuccess
{
    [self.collectionView reloadData];
}

- (void)loadDataWithPage:(NSInteger)page
{
    
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Notification_empty"];
}
// default 描述字段
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"No notifications, yet.");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// default subtitle 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You don’t have any notifications right now.\nLet’s change that.";
    
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
    cell.alpha = 0.8;
    [UIView animateWithDuration:0.35 animations:^{
        cell.alpha = 1;
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
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
        [_collectionView registerClass:[LSSearchCell class] forCellWithReuseIdentifier:kLSSearchCellIdentifier];
        [_collectionView registerClass:[LSNotiLikeCell class] forCellWithReuseIdentifier:kLSNotiLikeCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

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
