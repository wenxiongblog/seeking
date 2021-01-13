//
//  LSOneCell.h
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESTUserModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSOneCellIdentifier = @"LSOneCell";
@interface LSOneCell : UITableViewCell
@property (nonatomic,strong) VESTUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
