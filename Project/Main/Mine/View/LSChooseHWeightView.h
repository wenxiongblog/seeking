//
//  LSChooseHWeightView.h
//  Project
//
//  Created by XuWen on 2020/3/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSChooseHWeightView : XWBaseAlertView

+ (void)showHeight:(CGFloat)height select:(void(^)(NSString *title))selectedBlock;

@end

NS_ASSUME_NONNULL_END
