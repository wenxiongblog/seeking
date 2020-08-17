//
//  LSChooseWightView.h
//  Project
//
//  Created by XuWen on 2020/3/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSChooseWightView : XWBaseAlertView
+ (void)showWight:(int)preWeight select:(void(^)(NSString *title))selectedBlock;
@end

NS_ASSUME_NONNULL_END
