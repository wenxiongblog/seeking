//
//  PhoneTextField.m
//  SCGOV
//
//  Created by solehe on 2019/6/3.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import "PhoneTextField.h"

@implementation PhoneTextField

- (void)dealloc {
    [self removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (NSString *)text {
    return [[super text] trimAll];
}

- (void)textFieldDidChange:(UITextField *)text {
    
    NSMutableString *str = [[self text] mutableCopy];
    
    // 限制长度
    if (str.length > 11) {
        [str deleteCharactersInRange:NSMakeRange(11, str.length-11)];
    }
    
    // 将电话号码变为344格式
    if (str.length > 3 && str.length <= 7) {
        [str insertString:@" " atIndex:3];
    } else if (str.length > 7) {
        [str insertString:@" " atIndex:3];
        [str insertString:@" " atIndex:8];
    }
    return [self setText:str];
}

@end
