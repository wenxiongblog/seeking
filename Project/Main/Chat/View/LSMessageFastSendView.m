//
//  LSMessageFastSendView.m
//  Project
//
//  Created by XuWen on 2020/4/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMessageFastSendView.h"
@class LSFaseMessageView;

@interface LSMessageFastSendView ()
@property (nonatomic,strong) NSArray *wenanArray;
@property (nonatomic,weak) LSRYChatViewController *eventVC;
@end

@implementation LSMessageFastSendView

+ (void)show:(BOOL)isShow onVC:(LSRYChatViewController *)vc
{
    if(isShow){
        if(![vc.view.subviews containsObject:[LSMessageFastSendView share]]){
            [vc.view addSubview:[LSMessageFastSendView share]];
            [[LSMessageFastSendView share]configData];
            [LSMessageFastSendView share].eventVC = vc;
            [[LSMessageFastSendView share] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(vc.view);
                make.bottom.equalTo(vc.chatSessionInputBarControl.mas_top);
            }];
        }
    }else{
        
        if([vc.view.subviews containsObject:[LSMessageFastSendView share]]){
            [[LSMessageFastSendView share] removeFromSuperview];
        }
    }
}

static LSMessageFastSendView *__singletion;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__singletion == nil) {
            __singletion = [[self alloc] init];
        }
    });
    return __singletion;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
//        [self SEEKING_baseUIConfig];
    }
    return self;
}


#pragma mark - setter & getter1
- (void)configData
{
    self.backgroundColor = [UIColor clearColor];
    
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    //随机取3个
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    while ([randomSet count] < 3) {
        int r = arc4random() % [self.wenanArray count];
        [randomSet addObject:[self.wenanArray objectAtIndex:r]];
    }
    NSArray *randomArray = [randomSet allObjects];
    
    LSFaseMessageView *preView = nil;
    for(NSString *title in randomArray){
        LSFaseMessageView *messageView = [[LSFaseMessageView alloc]initWithTitle:kLanguage(title)];
        kXWWeakSelf(weakself);
        [messageView.sendButton setAction:^{
            //点击发送消息
            RCTextMessage *ms = [RCTextMessage messageWithContent:title];
            NSString *pushContent = [NSString stringWithFormat:@"%@:%@",ms.senderUserInfo.name,ms.content];
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:weakself.eventVC.userInfo.userId content:ms pushContent:pushContent pushData:nil success:nil error:nil];
        }];
        [self addSubview:messageView];
        if(preView){
            [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.bottom.equalTo(preView.mas_top).offset(-15);
            }];
        }else{
            [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.bottom.equalTo(self).offset(-15);
            }];
        }
        
        preView = messageView;
    }
    [preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
}

- (NSArray *)wenanArray
{
    if(!_wenanArray){
        _wenanArray = @[
        @"You're like sunshine on a rainy day",
        @"Your smile is breathtaking",
        @"You look so perfect",
        @"What's the quickest way to your heart?",
        @"What's the most important thing in your life?",
        @"What's the most fun date you've ever been on? ",
        @"What's the most badass thing you've ever done?",
        @"What would you do with $1 million?",
        @"What was your craziest life experience?",
        @"What movie always gives you chills?",
        @"What is your biggest passion?",
        @"What do you value most in people?",
        @"What do you usually do when you feel lonely?",
        @"Tell me about your ideal date",
        @"Hi! How's your day?",
        @"Hi there! You look great",
        @"Hey, what are you up to today?",
        @"Have you ever been abroad?",
        @"Do you like mountains or beaches?",
        @"Do you have a sunburn, or are you always this hot?",
        @"Do you believe in online dating :)?",
        @"Are you from Tennessee? Because you're the only ten I see!",
        @"All I want for Christmas is you!",
        ];
    }
    return _wenanArray;
}

@end


#pragma mark -- LSFaseMessageView
@interface LSFaseMessageView()
@property (nonatomic,strong) UILabel *textLabel;
@end

@implementation LSFaseMessageView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstrainsConfig];
        self.textLabel.text = title;
    }
    return self;
}

- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [UIColor projectBlueColor];
    [self xwDrawCornerWithRadiuce:18];
    [self addSubview:self.textLabel];
    [self addSubview:self.sendButton];
}

- (void)baseConstrainsConfig
{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@46);
        make.height.equalTo(@(24));
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(7);
    }];
}

- (UILabel *)textLabel
{
    if(!_textLabel){
        _textLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentLeft];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIButton *)sendButton
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:XWImageName(@"char_fastSend") forState:UIControlStateNormal];
        [_sendButton setAction:^{
            
        }];
    }
    return _sendButton;
}




@end
