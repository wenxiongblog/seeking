//
//  LSDetailInfoTagsCell.h
//  Project
//
//  Created by XuWen on 2020/5/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSDetailInfoTagsCellIdentifier = @"LSDetailInfoTagsCell";
@interface LSDetailInfoTagsCell : UITableViewCell
@property (nonatomic, copy) NSArray<NSString *> *tags;
@end

NS_ASSUME_NONNULL_END
