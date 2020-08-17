//
//  LSMeCell.h
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSMeCellIdentifier = @"LSMeCell";

@interface LSMeCell : UITableViewCell
@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) CGFloat persent; //百分比的内容
@property (nonatomic,assign) BOOL isPersent; //是否是百分比标签
@property (nonatomic,assign) BOOL isJump; //百分比标签是否抖动

@property (nonatomic,assign) BOOL isTop;
@property (nonatomic,assign) BOOL isBottom;

@end

NS_ASSUME_NONNULL_END
