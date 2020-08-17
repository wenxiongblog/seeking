//
//  LSDetailViewController.h
//  Project
//
//  Created by XuWen on 2020/2/9.
//  Copyright © 2020 xuwen. All rights reserved.
//  

#import "LSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSDetailViewController : LSBaseViewController

//@property (nonatomic, copy) void(^detailHandleResultBlock)(BOOL isDeleteLike, BOOL isDeleteCollection);

@property (nonatomic,strong) SEEKING_Customer* customer;

@end



NS_ASSUME_NONNULL_END
