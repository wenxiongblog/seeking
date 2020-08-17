//
//  LSDetailTagsCell.h
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSDetailTagsCellIdentifier = @"LSDetailTagsCell";

@interface LSDetailTagsCell : UITableViewCell
@property (nonatomic,strong) NSString *name;
@property (nonatomic, copy) NSArray<NSString *> *tags;
@end

NS_ASSUME_NONNULL_END
