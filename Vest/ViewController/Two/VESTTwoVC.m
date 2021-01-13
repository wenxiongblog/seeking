//
//  VESTTwoVC.m
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTTwoVC.h"
#import "LSTwoCell.h"
#import "VESTTwoLiveVC.h"
#import "LSCreateAlertView.h"
#import "VESTDataTool.h"

@interface VESTTwoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *addButton;

@property (nonatomic,strong) NSArray <VESTUserModel *>*dataarray;
@end

@implementation VESTTwoVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraitsConfig];
    
    self.dataarray = [NSArray arrayWithArray:[VESTDataTool allShiPinUser]];
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.collectionView];
}
- (void)baseConstraitsConfig
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(30+kStatusBarHeight);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-15);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
}

#pragma mark - public
#pragma mark - private
#pragma mark - event


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataarray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   LSTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSTwoCellIdentifier forIndexPath:indexPath];
    cell.userModel = self.dataarray[indexPath.row];
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(XW(166), XW(193));
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 10, 15, 10);
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
    VESTTwoLiveVC *vc = [[VESTTwoLiveVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - setter & getter
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
        [_collectionView registerClass:[LSTwoCell class] forCellWithReuseIdentifier:kLSTwoCellIdentifier];
    }
    return _collectionView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(42) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Live";
    }
    return _titleLabel;
}
- (UIButton *)addButton{
    if(!_addButton){
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:XWImageName(@"vest_addBtn") forState:UIControlStateNormal];
        [_addButton setAction:^{
            LSCreateAlertView *alertView = [[LSCreateAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
            alertView.eventVC = self;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            [alertView appearAnimation];
        }];
    }
    return _addButton;
}
@end
