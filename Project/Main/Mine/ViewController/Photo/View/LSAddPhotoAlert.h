//
//  LSAddPhotoAlert.h
//  Project
//
//  Created by XuWen on 2020/5/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSAddPhotoAlert : XWBaseAlertView
@property (nonatomic,copy) void(^ChoosePhotoBlock)(BOOL choose);
@end

NS_ASSUME_NONNULL_END
