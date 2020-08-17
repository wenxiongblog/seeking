//
//  LSChatNotificationView.h
//  Project
//
//  Created by XuWen on 2020/6/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSChatNotificationView : UIView
@property (nonatomic,copy) void(^CloseBlockClicked)(void);
@property (nonatomic,copy) void(^TapClicked)(void);
@end

NS_ASSUME_NONNULL_END
