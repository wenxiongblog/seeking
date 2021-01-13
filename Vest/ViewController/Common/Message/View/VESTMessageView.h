//
//  VESTMessageView.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESTMessageModel.h"
#import "VESTUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VESTMessageView : UIView
@property (nonatomic,strong) NSMutableArray <VESTMessageModel *>*messageArray;

@end

NS_ASSUME_NONNULL_END