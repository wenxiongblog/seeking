//
//  XXLogCircleView.m
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXLogCircleView.h"

@interface XXLogCircleView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation XXLogCircleView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.label = [[UILabel alloc] init];
    [self.label setTextColor:[UIColor clearColor]];
    [self.label setTextColor:[UIColor whiteColor]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.label setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightBold]];
    [self.label setText:@"日志"];
    [self addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(tapAction:)];
    [tapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(logCircleViewDidClose:)]) {
        [self.delegate logCircleViewDidClose:self];
    }
}


@end
