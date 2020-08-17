//
//  LSFilterViewController.h
//  Project
//
//  Created by XuWen on 2020/3/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LSFilterBlock)(BOOL isFilter);

@interface LSFilterViewController : LSBaseViewController
@property (nonatomic,copy) LSFilterBlock filterBlock;
@end

NS_ASSUME_NONNULL_END
