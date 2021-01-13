//
//  VESTSendCell.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESTMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kVESTSendCellIdentifier = @"VESTSendCell";
@interface VESTSendCell : UITableViewCell
@property (nonatomic,strong) VESTMessageModel *message;
@end

NS_ASSUME_NONNULL_END
