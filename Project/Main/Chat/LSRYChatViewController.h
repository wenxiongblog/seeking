//
//  LSRYChatViewController.h
//  Project
//
//  Created by XuWen on 2020/3/8.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSRYChatViewController : RCConversationViewController

- (instancetype)init NS_UNAVAILABLE;

/// 初始化 是否是系统消息
/// @param systemInfo 是否是系统消息
- (instancetype)initWithSystemInfo:(BOOL)systemInfo;

@property (nonatomic,strong) RCUserInfo *userInfo;
//@property (nonatomic,strong) SEEKING_Customer *customer;

@end

NS_ASSUME_NONNULL_END
