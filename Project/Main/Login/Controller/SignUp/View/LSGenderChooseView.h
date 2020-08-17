//
//  LSGenderChooseView.h
//  Project
//
//  Created by XuWen on 2020/5/12.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^GenderChooseBlock)(int gender);
@interface LSGenderChooseView : UIView
@property (nonatomic,assign,readonly) int gender;
@property (nonatomic,copy)GenderChooseBlock genderChooseBlock;
@end

NS_ASSUME_NONNULL_END
