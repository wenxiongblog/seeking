//
//  LSSignInEmailVC.m
//  Project
//
//  Created by XuWen on 2020/6/2.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignInEmailVC.h"
#import "LSRongYunHelper.h"
#import "LSLogChooseVC.h"
#import "LSSignUpBaseVC.h"
#import "LSSignInNavigationController.h"
#import "CountDownButton.h"

@interface LSSignInEmailVC ()
@property (nonatomic,strong) UIView *emailView;
@property (nonatomic,strong) UIView *passwordView;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UITextField *passwordTextField;

@property (nonatomic,strong) UIButton *nextButton;
@end

@implementation LSSignInEmailVC

- (void)MDLogonSuccess{}
- (void)MDLoginSuccess{}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.isSignUp){
        self.titleLabel.text = kLanguage(@"Sign up");
    }else{
        self.titleLabel.text = kLanguage(@"Log in");
        
        //默认填写上次注册或登录的密码
        NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"kuserEmail"];
        NSString *password =[[NSUserDefaults standardUserDefaults]objectForKey:@"kuserPassword"];
        if([email isEmail] && [password isPassword]){
            self.emailTextField.text = email;
            self.passwordTextField.text = password;
            self.nextButton.selected = YES;
            self.nextButton.userInteractionEnabled = YES;
        }
    }
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backButton.hidden = NO;
    [self.view addSubview:self.emailView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.nextButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@40);
        make.top.equalTo(self.navBarView.mas_bottom).offset(20);
    }];
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@50);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(70);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.emailView);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.emailView.mas_bottom).offset(13);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@50);
        make.top.equalTo(self.passwordView.mas_bottom).offset(70);
    }];
}
#pragma mark - public
#pragma mark - private
#pragma mark - event
- (void)passwordChange:(UITextField *)textField
{
    if([self.emailTextField.text isEmail] && [self.passwordTextField.text isPassword]){
        self.nextButton.selected = YES;
        self.nextButton.userInteractionEnabled = YES;
    }else{
        self.nextButton.selected = NO;
        self.nextButton.userInteractionEnabled = NO;
    }
}

- (void)emailChange:(UITextField *)textField
{
    if([self.emailTextField.text isEmail] && [self.passwordTextField.text isPassword]){
        self.nextButton.selected = YES;
        self.nextButton.userInteractionEnabled = YES;
    }else{
        self.nextButton.selected = NO;
        self.nextButton.userInteractionEnabled = NO;
    }
}

#pragma mark - getter & setter
- (UIView *)emailView
{
    if(!_emailView){
        _emailView = [[UIView alloc]init];
        _emailView.backgroundColor = [UIColor projectBlueColor];
        [_emailView xwDrawCornerWithRadiuce:5];
        [_emailView addSubview:self.emailTextField];
        [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emailView).offset(15);
            make.right.equalTo(self.emailView).offset(-15);
            make.top.bottom.equalTo(self.emailView);
        }];
    }
    return _emailView;
}

- (UIView *)passwordView
{
    if(!_passwordView){
        _passwordView = [[UIView alloc]init];
        _passwordView.backgroundColor = [UIColor projectBlueColor];
        [_passwordView xwDrawCornerWithRadiuce:5];
        [_passwordView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passwordView).offset(15);
            make.right.equalTo(self.passwordView).offset(-15);
            make.top.bottom.equalTo(self.passwordView);
        }];
    }
    return _passwordView;
}

- (UITextField *)emailTextField
{
    if(!_emailTextField){
        UITextField *textField = [[UITextField alloc]init];
        textField.textColor = [UIColor themeColor];
        textField.keyboardType = UIKeyboardTypeDefault;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:kLanguage(@"Email Address") attributes:@{NSForegroundColorAttributeName:[UIColor xwColorWithHexString:@"#666666"],NSFontAttributeName:textField.font}];
        textField.attributedPlaceholder = attrString;
        _emailTextField = textField;
        [_emailTextField addTarget:self action:@selector(emailChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailTextField;
}

- (UITextField *)passwordTextField
{
    if(!_passwordTextField){
        UITextField *textField = [[UITextField alloc]init];
        textField.textColor = [UIColor themeColor];
        textField.keyboardType = UIKeyboardTypeDefault;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:kLanguage(@"Password: 6~20 characters") attributes:@{NSForegroundColorAttributeName:[UIColor xwColorWithHexString:@"#666666"],NSFontAttributeName:textField.font}];
        textField.attributedPlaceholder = attrString;
        _passwordTextField = textField;
        [_passwordTextField addTarget:self action:@selector(passwordChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"CONTINUE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            if(weakself.isSignUp){
                //注册
                [weakself zhuceRequest];
            }else{
                //登录
                [weakself dengluRequest];
            }
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (void)setIsSignUp:(BOOL)isSignUp
{
    _isSignUp = isSignUp;
    if(isSignUp){
        self.titleLabel.text = kLanguage(@"Sign up");
    }else{
        self.titleLabel.text = kLanguage(@"Log in");
    }
}

- (void)zhuceRequest
{
    //开始去注册
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"email"] = self.emailTextField.text;
    paramDict[@"password"] = self.passwordTextField.text;
    
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    kXWWeakSelf(weakself);
    [self post:kURL_RegisterByEmail params:paramDict success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.content == nil){
            [AlertView toast:kLanguage(@"Register failed") inView:self.view];
            return;
        }
        //如果注册的是同样的号码，错误
        NSDictionary *dict = response.content;
        SEEKING_UserModel *user = [[SEEKING_UserModel alloc]init];
        [user mj_setKeyValues:dict];
        if(user.state == 1 || user.id == nil){
            [AlertView toast:@"Email has been registered" inView:self.view];
            return;
        }
        
        if(response.isSuccess){
            NSDictionary *dict = response.content;
            //先退出登录，清空缓存
            [LSRongYunHelper logout];
            [kUser clear];
            [kUser mj_setKeyValues:dict];
            [kUser synchronize];
            
            [self analysisStatus:kUser.status];
            
        }else{
            [AlertView toast:response.message inView:self.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
    }];
}


- (void)dengluRequest
{
    //开始去注册
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"email"] = self.emailTextField.text;
    paramDict[@"password"] = self.passwordTextField.text;
    
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    kXWWeakSelf(weakself);
    [self post:kURL_LoginByEmial params:paramDict success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        //用户名或密码错误
        if(response.content == nil){
            [AlertView toast:@"Username or password error" inView:self.view];
            return;
        }
        
        if(response.isSuccess){
            NSDictionary *dict = response.content;
            //先退出登录，清空缓存
            [LSRongYunHelper logout];
            [kUser clear];
            [kUser mj_setKeyValues:dict];
            [kUser synchronize];
            
            [self analysisStatus:kUser.status];
            
        }else{
            [AlertView toast:response.message inView:self.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
    }];
}


- (void)analysisStatus:(NSInteger)status
{
    if(status == 0){
        //注册成功
        [CountDownButton saveCountTime_deleteAcount];
        //埋点
        [self MDLogonSuccess];
        
        //缓存用户名和账号
        [[NSUserDefaults standardUserDefaults]setObject:self.emailTextField.text forKey:@"kuserEmail"];
        [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:@"kuserPassword"];
        
        kUser.isZhuce = YES;//标记为注册流程
        LSLogChooseVC *vc = [[LSLogChooseVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(status == 1){
        //埋点
        //登录成功
        [self MDLoginSuccess];
        
        //缓存用户名和账号
        [[NSUserDefaults standardUserDefaults]setObject:self.emailTextField.text forKey:@"kuserEmail"];
        [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:@"kuserPassword"];
        
        kUser.isZhuce = NO;//标记为非注册流程
        //是否判断了性别
        LSSignUpBaseVC *vc = [LSSignInNavigationController gofinishInfoVC];
        if(vc){
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //全部完成
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
        }
    }else if(status == 2){
        //验证失败
        kUser.isLogin = NO;
    }
}

@end
