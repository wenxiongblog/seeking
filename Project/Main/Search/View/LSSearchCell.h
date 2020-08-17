//
//  LSSearchCell.h
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSSearchCellIdentifier = @"LSSearchCell";
@interface LSSearchCell : UICollectionViewCell
@property (nonatomic,strong) SEEKING_Customer* customer;
@property (nonatomic,assign) BOOL showDistance;
@end

NS_ASSUME_NONNULL_END
