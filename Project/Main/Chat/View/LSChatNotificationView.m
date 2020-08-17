//
//  LSChatNotificationView.m
//  Project
//
//  Created by XuWen on 2020/6/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSChatNotificationView.h"

@interface LSChatNotificationView()

@end

@implementation LSChatNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self uiconfig];
    }
    return self;
}


#pragma mark - setter & getter1
- (void)uiconfig
{
    self.backgroundColor = [UIColor xwColorWithHexString:@"#0B727B"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"铃铛")];
    [self addSubview:imageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:XWImageName(@"叉") forState:UIControlStateNormal];
    [self addSubview:closeButton];
    kXWWeakSelf(weakself);
    [closeButton setAction:^{
        if(weakself.CloseBlockClicked){
            weakself.CloseBlockClicked();
        }
    }];
    
    UILabel* label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentLeft];
    label.text = kLanguage(@"Allow the push notification and check messages in time.");
    label.numberOfLines = 2;
    [self addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@37);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(imageView.mas_right).offset(15);
        make.right.equalTo(closeButton.mas_left).offset(-15);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];
}

- (void)tapClicked
{
    if(self.TapClicked){
        self.TapClicked();
    }
}

@end
