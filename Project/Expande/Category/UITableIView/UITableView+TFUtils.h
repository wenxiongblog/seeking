//
//  UITableView+TFUtils.h
//  SCGov
//
//  Created by XuWen on 2019/11/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TFUtils)
- (void)commonTableViewConfig;
@end

@interface UIScrollView (Custom)
- (void)commonScrollViewConfig;
@end


@interface UITableViewCell (Custom)
- (void)commonTableViewCellConfig;
- (void)flexibleHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
