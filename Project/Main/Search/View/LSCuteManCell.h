//
//  LSCuteManCell.h
//  Project
//
//  Created by XuWen on 2020/6/16.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSCuteManCellIdentifier = @"LSCuteManCell";

@interface LSCuteManCell : UICollectionViewCell
@property (nonatomic,strong) SEEKING_Customer* customer;
@end

NS_ASSUME_NONNULL_END
