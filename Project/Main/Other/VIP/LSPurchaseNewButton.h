//
//  LSPurchaseNewButton.h
//  Project
//
//  Created by XuWen on 2020/7/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPurchaseManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSPurchaseNewButton : UIView
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,strong) LSPurchaseModel *model;
@end

NS_ASSUME_NONNULL_END
