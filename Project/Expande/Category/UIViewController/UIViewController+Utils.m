//
//  ViewController+Utils.m
//  SCGov
//
//  Created by solehe on 2019/7/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

// 自定义返回按钮
- (void)customNaviBackItem:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithColor:[UIColor blackColor]];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setFrame:CGRectMake(0.0, 4.0, 40.0, 36.0)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:image forState:UIControlStateHighlighted];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [backBtn addTarget:self action:@selector(customBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)customBackAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
