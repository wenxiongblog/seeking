//
//  LSChooseFriendsView.m
//  Project
//
//  Created by XuWen on 2020/2/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSChooseFriendsView.h"
#import "LSSignUpChooseCell.h"

@interface LSChooseFriendsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *titleView;

//数据
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation LSChooseFriendsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstaintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [UIColor projectBackGroudColor];
    [self addSubview:self.titleView];
    [self addSubview:self.collectionView];
}

- (void)baseConstaintsConfig
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(XW(60)));
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
}


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
    LSSignUpChooseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSSignUpChooseCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}
//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(XW(300), XW(130));
}
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, (kSCREEN_WIDTH-XW(300))/2.0, 15, (kSCREEN_WIDTH-XW(300))/2.0);
}
//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.chooseBlock){
        self.chooseBlock(indexPath.row, self.dataArray[indexPath.row]);
    }
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - setter & getter1
- (UIView *)titleView
{
    if(!_titleView){
        _titleView = [[UIView alloc]init];
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(24) aliment:NSTextAlignmentCenter];
        label.text = @"Looking for：";
        label.numberOfLines = 0;
        [_titleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleView);
            make.centerY.equalTo(self.titleView);
        }];
    }
    return _titleView;
}

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
        [_collectionView registerClass:[LSSignUpChooseCell class] forCellWithReuseIdentifier:kLSSignUpChooseCellIdentifier];
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"Short-term",@"Long-term",@"Friends"];
    }
    return _dataArray;
}


@end
