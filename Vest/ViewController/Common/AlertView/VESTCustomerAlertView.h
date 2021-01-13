//
//  VESTCustomerAlertView.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"
#import "VESTUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VESTCustomerAlertView : XWBaseAlertView
@property (nonatomic,weak) UIViewController *eventVC;
@property (nonatomic,strong) VESTUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
