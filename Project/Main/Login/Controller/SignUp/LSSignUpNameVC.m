//
//  LSSignUpNameVC.m
//  Project
//
//  Created by XuWen on 2020/2/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpNameVC.h"
#import "LSSignUpAgeVC.h"

@interface LSSignUpNameVC ()
@property (nonatomic,strong) UIButton *nextButton;

@property (nonatomic,strong) UIView *nameView;
@property (nonatomic,strong) UITextField *mainTextField;
@end

@implementation LSSignUpNameVC

#pragma mark - 埋点
- (void)MDChooseName03{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    [self.mainTextField becomeFirstResponder];
}

#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.titleLabel.text = kLanguage(@"Your name");
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.nextButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@(XW(300)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(130);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@(XW(300)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nameView.mas_bottom).offset(83);
    }];
}

#pragma mark - event
- (void)nameChange:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    self.nextButton.selected = [textField.text trim].length>0;
    self.nextButton.userInteractionEnabled = [textField.text trim].length>0;
}


#pragma mark - setter & getter1
- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"NEXT") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            //姓名更新
            NSString *name = [weakself.mainTextField.text trim];
            if([name xwIsContainEmoji]){
                [AlertView toast:@"Name format is error" inView:weakself.view];
                return;
            }
            kUser.name = [weakself.mainTextField.text trim];
            [self MDChooseName03];
            LSSignUpAgeVC *vc = [[LSSignUpAgeVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (UIView *)nameView
{
    if(!_nameView){
        _nameView = [[UIView alloc]init];
        [_nameView xwDrawBorderWithColor:[UIColor themeColor] radiuce:5 width:1.5];
        self.mainTextField = [[UITextField alloc]init];
        [_nameView addSubview:self.mainTextField];
        self.mainTextField.textColor = [UIColor themeColor];
        self.mainTextField.backgroundColor = [UIColor xwColorWithHexString:@"#18233e"];
        [self.mainTextField addTarget:self action:@selector(nameChange:) forControlEvents:UIControlEventEditingChanged];
        [self.mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameView).offset(10);
            make.right.equalTo(self.nameView).offset(-10);
            make.top.bottom.equalTo(self.nameView);
        }];
    }
    return _nameView;
}



@end
