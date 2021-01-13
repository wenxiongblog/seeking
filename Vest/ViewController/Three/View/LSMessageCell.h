//
//  LSMessageCell.h
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESTMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSMessageCellIdentifier = @"LSMessageCell";
@interface LSMessageCell : UITableViewCell
@property (nonatomic,strong) VESTMessageModel *messageModel;

@end

NS_ASSUME_NONNULL_END
