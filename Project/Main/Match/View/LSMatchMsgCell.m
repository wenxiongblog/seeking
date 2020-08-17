//
//  LSMatchMsgCell.m
//  Project
//
//  Created by XuWen on 2020/4/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMatchMsgCell.h"

@interface LSMatchMsgCell()
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation LSMatchMsgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
    }
    return self;
}

#pragma mark - baseConstraints
- (void)SEEKING_baseUIConfig
{
    self.contentView.backgroundColor =  [UIColor themeColor];
    [self.contentView xwDrawCornerWithRadiuce:25];
    [self.contentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@34);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-9.5);
    }];
}


#pragma mark - setter & getter1
- (UILabel *)textLabel
{
    if(!_textLabel){
        _textLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(18) aliment:NSTextAlignmentLeft];
    }
    return _textLabel;;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.textLabel.text = title;
}

- (UIButton *)sendButton
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:XWImageName(@"match_send") forState:UIControlStateNormal];
        [_sendButton xwDrawCornerWithRadiuce:17];
        _sendButton.backgroundColor = [UIColor xwColorWithHexString:@"#FF0098"];
        kXWWeakSelf(weakself);
        [_sendButton setAction:^{
            if(weakself.sendBlock){
                weakself.sendBlock(weakself.title);
            }
        }];
    }
    return _sendButton;;
}


@end
