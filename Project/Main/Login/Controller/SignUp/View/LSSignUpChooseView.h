//
//  LSSignUpChooseView.h
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LSSignUpChooseBlock)(NSInteger index,NSString *chooseStr);
@interface LSSignUpChooseView : UIView
@property (nonatomic,copy)LSSignUpChooseBlock chooseBlock;
@end

NS_ASSUME_NONNULL_END
