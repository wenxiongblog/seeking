//
//  LSMineFeedBackVC.m
//  Project
//
//  Created by XuWen on 2020/3/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineFeedBackVC.h"

@interface LSMineFeedBackVC ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIButton *nextButton;
@end

@implementation LSMineFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];

}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self speciceNavWithTitle:kLanguage(@"Feedback")];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.nextButton];
}

- (void)baseConstriantsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.equalTo(@300);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contentView.mas_bottom).offset(30);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}


#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [_contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return _contentView;
}

- (UITextView *)textView
{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.textColor = [UIColor themeColor];
        _textView.backgroundColor = [UIColor clearColor];
        [_textView xwDrawBorderWithColor:[UIColor themeColor] radiuce:5 width:1];
        _textView.font = FontMediun(17);
    }
    return _textView;
}


- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Send") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = YES;
        button.selected = YES;
        kXWWeakSelf(weakself);
        [button setAction:^{
            [AlertView showLoading:kLanguage(@"Loading...") inView:[UIApplication sharedApplication].keyWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [AlertView hiddenLoadingInView:[UIApplication sharedApplication].keyWindow];
                [weakself.navigationController popViewControllerAnimated:YES];
                [AlertView toast:@"Thanks for your feedback!" inView:[UIApplication sharedApplication].keyWindow];
            });
            
        }];
        _nextButton = button;
    }
    return _nextButton;
}


@end
