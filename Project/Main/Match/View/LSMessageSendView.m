//
//  LSMessageSendView.m
//  Project
//
//  Created by XuWen on 2020/5/12.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMessageSendView.h"
#import "LSRYChatViewController.h"

@interface LSMessageSendView ()
@property (nonatomic,strong)SEEKING_Customer * customer;
@end

@implementation LSMessageSendView

+ (void)showWithCustomer:(SEEKING_Customer *)customer
{
    LSMessageSendView *view = [[LSMessageSendView alloc]init];
    view.customer = customer;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    //弹出动画
    [UIView animateWithDuration:0.3 delay:0.5 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = CGRectMake(XW(15), kStatusBarHeight+30, XW(345), XW(65));
    } completion:^(BOOL finished) {
        //停留2.0秒
        //消失动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                view.frame = CGRectMake(XW(15), XW(-65), XW(345), XW(65));
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.frame = CGRectMake(XW(15), XW(-65), XW(345), XW(65));
    [self xwDrawCornerWithRadiuce:5];
    self.backgroundColor = [UIColor xwColorWithHexString:@"#492CD1"];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"Matchs_msg")];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentLeft];
    label.text = kLanguage(@"Message sent");
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(imageView.mas_right).offset(15);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:XWImageName(@"matchs_right")];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.backgroundColor = [UIColor clearColor];
    [self addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加上滑动手势
    UISwipeGestureRecognizer *top = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(topSwipe)];
    top.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:top];
}

- (void)topSwipe
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(XW(15), XW(-65), XW(345), XW(65));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clearButtonClicked:(UIButton *)sender
{
//    LSRYChatViewController *chatVC = [[LSRYChatViewController alloc]initWithSystemInfo:NO];
//    chatVC.conversationType = ConversationType_PRIVATE;
//    chatVC.targetId = self.customer.conversationId;
//    chatVC.title = [self.customer.name filter];
//    chatVC.hidesBottomBarWhenPushed = YES;
//    [[self getCurrentVC].navigationController pushViewController:chatVC animated:YES];
}


#pragma mark - setter & getter1

@end
