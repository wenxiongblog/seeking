//
//  VESTMineHeadView.h
//  Project
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESTMineHeadView : UIView
@property (nonatomic,weak) UIViewController *eventVC;
//
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) BOOL isVIP;
@property (nonatomic,assign) NSInteger coins;
@end

NS_ASSUME_NONNULL_END
