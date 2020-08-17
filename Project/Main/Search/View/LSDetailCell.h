//
//  LSDetailCell.h
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *kLSDetailCellIdentifier = @"LSDetailCell";
@interface LSDetailCell : UITableViewCell
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic, copy) NSArray<NSString *> *tags;
@end

NS_ASSUME_NONNULL_END
