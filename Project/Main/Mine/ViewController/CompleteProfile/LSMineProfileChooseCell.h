//
//  LSMineProfileChooseCell.h
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSMineProfileChooseCellIdentifier = @"LSMineProfileChooseCell";
@interface LSMineProfileChooseCell : UICollectionViewCell
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) BOOL isChoosed;
@end

NS_ASSUME_NONNULL_END
