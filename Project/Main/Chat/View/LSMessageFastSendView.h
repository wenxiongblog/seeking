//
//  LSMessageFastSendView.h
//  Project
//
//  Created by XuWen on 2020/4/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRYChatViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface LSMessageFastSendView : UIView
+ (void)show:(BOOL)isShow onVC:(LSRYChatViewController *)vc;
@end

@interface LSFaseMessageView:UIView
@property (nonatomic,strong) UIButton *sendButton;
- (instancetype)initWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
