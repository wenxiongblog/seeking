//
//  VESTEmailInputView.m
//  Project
//
//  Created by XuWen on 2020/8/24.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTEmailInputView.h"

@interface VESTEmailInputView()
@property (nonatomic,strong) UITextField *textField;
@end

@implementation VESTEmailInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
        
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(28);
            make.right.equalTo(self).offset(-28);
            make.top.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - setter & getter
- (UITextField *)textField
{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"Email";
        _textField.textColor = [UIColor whiteColor];
        _textField.font = Font(15);
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textFieldChanged:(UITextField *)textField
{
    self.value = textField.text;
}

@end
