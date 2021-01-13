//
//  VESTMsgSendView.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTMsgSendView.h"

@interface VESTMsgSendView ()
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UITextField *textFiled;
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation VESTMsgSendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.whiteView];
//        [self addSubview:self.textFiled];
        [self addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(XW(40)));
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self).offset(10);
        }];
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.right.equalTo(self.sendButton.mas_left).offset(-13);
            make.top.equalTo(self.sendButton);
            make.height.equalTo(@(XW(40)));
        }];
    }
    return self;
}

#pragma mark - setter & getter
- (UIView *)whiteView
{
    if(!_whiteView){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_whiteView xwDrawBorderWithColor:[UIColor xwColorWithHexString:@""] radiuce:10 width:1];
        [_whiteView addSubview:self.textFiled];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.whiteView);
            make.left.equalTo(self.whiteView).offset(15);
            make.right.equalTo(self.whiteView).offset(-15);
        }];
    }
    return _whiteView;
}

- (UITextField *)textFiled
{
    if(!_textFiled){
        _textFiled = [[UITextField alloc]init];
        _textFiled.backgroundColor = [UIColor whiteColor];
        _textFiled.textColor = [UIColor projectMainTextColor];
        _textFiled.placeholder = @"Say someting";
    }
    return _textFiled;
}

- (UIButton *)sendButton
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:XWImageName(@"vest_send") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_sendButton setAction:^{
            if(weakself.SendBlock){
                weakself.SendBlock(weakself.textFiled.text);
                weakself.textFiled.text = nil;
            }
        }];
    }
    return _sendButton;
}
@end
