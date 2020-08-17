//
//  LSNotiViewedMeView.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotiViewedMeView.h"
#import "LSNotiLikeCell.h"
#import "LSDetailViewController.h"

@interface LSNotiViewedMeView()
    
@end

@implementation LSNotiViewedMeView

- (void)loadDataWithPage:(NSInteger)page
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"page":@(page),
    };
    kXWWeakSelf(weakself);
    [self post:kURL_ViewedMe params:params success:^(Response * _Nonnull response) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        
        if(response.isSuccess){
            NSLog(@"%@",response);
            NSArray *array = (NSArray *)response.content;
            NSArray <SEEKING_Customer *> *cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:array];
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
//
//                if(![self.subviews containsObject:self.vipShadowButton] && !kUser.isVIP){
//                    [self addSubview:self.vipShadowButton];
//                }
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

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        
        self.currentPage = 1;
        [self loadDataWithPage:self.currentPage];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewdMeAdd) name:kNotification_ViewedMe_changed object:nil];
    }
    return self;
}

- (void)viewdMeAdd
{
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
}


#pragma mark - baseConfig1
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
     if(kUser.isVIP){
           return self.dataArray.count;
       }else{
           return self.dataArray.count >2 ? 2:self.dataArray.count;
       }
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(!kUser.isVIP){
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
            if(self.dataArray.count > 2){
                UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
                
                
                UIView *contentView = [[UIView alloc]init];
                contentView.backgroundColor = [UIColor xwColorWithHexString:@"#47B5CC"];
                [contentView xwDrawCornerWithRadiuce:15];
                
                //背景颜色
                CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10)/2.0;
                [view addSubview:contentView];
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(view);
                    make.left.equalTo(view).offset(space);
                    make.right.equalTo(view).offset(-(space));
                }];
                //切图
                UIImageView *imageView  = [[UIImageView alloc]initWithImage:XWImageName(@"Notification_viewed")];
                [contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@(XW(42)));
                    make.centerY.equalTo(contentView);
                    make.left.equalTo(contentView).offset(13);
                }];
                
                //20 users like you
                UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(20) aliment:NSTextAlignmentLeft];
                
                NSString *content = [NSString stringWithFormat:kLanguage(@"%ld users viewed you"),self.dataArray.count];
                NSMutableAttributedString* attributedStr=[[NSMutableAttributedString alloc]initWithString:content];
                NSString *number = [NSString stringWithFormat:@"%ld",self.dataArray.count];
                [attributedStr addAttribute:NSFontAttributeName value:FontBold(30) range:NSMakeRange(0, number.length)];
    
                label.attributedText = attributedStr;
                
                UILabel *subLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(20) aliment:NSTextAlignmentLeft];
                subLabel.text = kLanguage(@"View now");
                [contentView addSubview:label];
                [contentView addSubview:subLabel];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageView.mas_right).offset(20);
                    make.bottom.equalTo(imageView.mas_centerY);
                }];
                [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label);
                    make.top.equalTo(label.mas_bottom);
                }];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClicked)];
                [contentView addGestureRecognizer:tap];
                
                return view;
            }
        }
    }
    return nil;
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(!kUser.isVIP){
        if(self.dataArray.count > 2){
            return CGSizeMake(kSCREEN_WIDTH, XW(77));
        }
    }
    return CGSizeMake(0, 0);
}

- (void)vipClicked
{
    [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_viewMe];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Noti_viewedMe"];
}
// default 描述字段
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}
// default subtitle 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"Upload more profile photos and complete personal\ninformation to make you more attractive");
    
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


#pragma mark - setter & getter1


@end
