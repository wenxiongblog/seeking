//
//  LSNotiBaseView.h
//  Project
//
//  Created by XuWen on 2020/3/15.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRongYunHelper.h"
#import "LSVIPAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSNotiBaseView : UIView
@property (nonatomic,assign) UIViewController *eventVC;
@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) NSMutableArray <SEEKING_Customer *>*dataArray;
@property (nonatomic,assign) NSInteger currentPage;

- (void)loadDataWithPage:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
