//
//  LSNotiLikesMeView.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotiLikesMeView.h"
#import "LSSearchCell.h"
#import "LSDetailViewController.h"
#import "LSVIPAlertView.h"

@interface LSNotiLikesMeView()

@end

@implementation LSNotiLikesMeView

- (void)loadDataWithPage:(NSInteger)page
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"page":@(page),
    };
    
    kXWWeakSelf(weakself);
    [self post:kURL_GetLikeMe params:params success:^(Response * _Nonnull response) {
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        
        if(response.isSuccess){
            NSLog(@"%@",response);
            NSArray *array = (NSArray *)response.content;
            NSArray <SEEKING_Customer *> *cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:array];
            
            //缓存融云用户数据
            if(cutomerArray.count > 0){
                [LSRongYunHelper ryCashUserArray:cutomerArray];
                
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


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        
        //加载第一页
        self.currentPage = 1;
        [self loadDataWithPage:self.currentPage];
        
        //如果有人喜欢我，刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(likedMeAdd) name:kNotification_LikesMe_add object:nil];

    }
    return self;
}




- (void)likedMeAdd
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
    LSSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSSearchCellIdentifier forIndexPath:indexPath];
    cell.customer = self.dataArray[indexPath.row];
    cell.showDistance = NO;
    return cell;
}
//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(XW(162), XW(207));
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat space = (kSCREEN_WIDTH-XW(162)*2-10)/2.0;
    return UIEdgeInsetsMake(15, space, 15, space);
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
                contentView.backgroundColor = [UIColor xwColorWithHexString:@"#60CC47"];
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
                UIImageView *imageView  = [[UIImageView alloc]initWithImage:XWImageName(@"Notification_like")];
                [contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@(XW(42)));
                    make.centerY.equalTo(contentView);
                    make.left.equalTo(contentView).offset(13);
                }];
                
                //20 users like you
                UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(20) aliment:NSTextAlignmentLeft];
                
                NSString *content = [NSString stringWithFormat:kLanguage(@"%ld users like you"),self.dataArray.count];
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
    [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_likeMe];
}


#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Noti_likesMe"];
}
// default 描述字段
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"No one liked you");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// default subtitle 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"Upload more photos and information to make\nyou attractive Or use filter to search");
    
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
