//
//  VESTMsgSendView.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESTMsgSendView : UIView
@property (nonatomic, copy) void (^SendBlock)(NSString *msg);
@end

NS_ASSUME_NONNULL_END
