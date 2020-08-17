//
//  LSSignInVC.m
//  Project
//
//  Created by XuWen on 2020/2/14.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignInVC.h"
#import "LSLogChooseVC.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "MKAppleLogin.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NSData+Trim.h"
#import "LSLogChooseVC.h"
#import "LSSignUpNameVC.h"
#import "LSSignUpAgeVC.h"
#import "LSSignUpHeadVC.h"
#import "LSSignUpLocationVC.h"
#import "LSRongYunHelper.h"
#import "LSProtocolViewController.h"
#import "LSSignInNavigationController.h"
#import "LSSignInEmailVC.h"
#import "CountDownButton.h"

@interface LSSignInVC ()<MKAppleLoginDelegate>

@property (nonatomic,strong) UIImageView *bgAnimationView;
//登录回调
@property (nonatomic,strong) UIView *faceBoobView;
@property (nonatomic,strong) UIView *appleView;

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UILabel *termLabel;
@property (nonatomic,strong) UIButton *termButton;
@property (nonatomic,strong) UIButton *privateButton;

@property (nonatomic,strong) UIButton *testButton;

@property (nonatomic,strong) UIButton *eulaButton;

@property (nonatomic,strong) MKAppleLogin *appLoginManger;

@end

@implementation LSSignInVC

//开始注册或登录
- (void)MDloginBegin{}
//facebook
- (void)MDloginFaceBook_Begin{}
//apple
- (void)MDloginApple_Begin{}
//邮箱注册开始
- (void)MDlogonEmail_Begin{}
//邮箱登录开始
- (void)MDdengluEmail_Begin{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    self.titleLabel.text = @"";
    //埋点
    [self MDloginBegin];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self stopAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开始跳转
    [self popJumpAnimationView];
}

#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.backButton.hidden = YES;
    self.bgImageView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.backButton.transform = CGAffineTransformRotate(self.backButton.transform,-M_PI/2);
    }];
    [self.backButton setAction:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"0"}];
    }];
    
//    [self addPlater];
    [self.view addSubview:self.bgAnimationView];
    self.view.backgroundColor = [UIColor themeColor];
    [self.view addSubview:self.appleView];
//    [self.view addSubview:self.faceBoobView];
    [self.view addSubview:self.termLabel];
    [self.view addSubview:self.termButton];
    [self.view addSubview:self.privateButton];
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.testButton];
    [self.view addSubview:self.eulaButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(self.faceBoobView);
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.faceBoobView.mas_top).offset(-10);
         make.centerX.equalTo(self.view);
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.bottom.equalTo(self.appleView.mas_top).offset(-10);
    }];
//    [self.faceBoobView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(@(XW(300)));
//        make.height.equalTo(@(50));
//        make.bottom.equalTo(self.appleView.mas_top).offset(-10);
//    }];
    [self.appleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.bottom.equalTo(self.termLabel.mas_top).offset(-20);
    }];
    [self.termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.termButton.mas_top).offset(-2);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view);
    }];
    [self.termButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.bottom.equalTo(self.privateButton);
    }];
    [self.privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.bottom.equalTo(self.testButton.mas_top);
    }];
    [self.eulaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@80);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(kStatusBarHeight+20);
    }];
    
   /*
    UIButton *boyButton = [UIButton creatCommonButtonConfigWithTitle:@"男" font:FontBold(17) titleColor:[UIColor themeColor] aliment:0];
    UIButton *girlButton = [UIButton creatCommonButtonConfigWithTitle:@"女" font:FontBold(17) titleColor:[UIColor themeColor] aliment:0];
    kXWWeakSelf(weakself);
    [boyButton setAction:^{

        [weakself loginWithPlatform:@"facebook" uid:@"faceboook1234" identityToken:nil];
    }];
    [girlButton setAction:^{

       [weakself loginWithPlatform:@"facebook" uid:@"faceboook1235" identityToken:nil];

    }];
    [boyButton xwDrawCornerWithRadiuce:5];
    [girlButton xwDrawCornerWithRadiuce:5];
    boyButton.backgroundColor = [UIColor whiteColor];
    girlButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:boyButton];
    [self.view addSubview:girlButton];
    [boyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.bottom.equalTo(self.testButton.mas_top).offset(-10);
    }];
    [girlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@(50));
        make.bottom.equalTo(boyButton.mas_top).offset(-10);
    }];
    */
}

#pragma mark - private

#pragma mark ---<appleLoginDelegate>
-(void)authorizationdidSuccessWithUserID:(NSString *)userID andAuthorizationCode:(NSData *)Acode andIdentityToken:(NSData *)token andEmail:(NSString *)email{
    
    //网络请求验证
    NSLog(@"userID=%@---Acode=%@----token=%@----email=%@",userID,[[NSString alloc]initWithData:Acode encoding:NSUTF8StringEncoding],[[NSString alloc]initWithData:token encoding:NSUTF8StringEncoding],email);
    NSString *identityToken = [[NSString alloc]initWithData:token encoding:NSUTF8StringEncoding];
    [self loginWithPlatform:@"apple" uid:userID identityToken:identityToken];
}
-(void)authorizationdidSuccessWithErrorCode:(NSString *)errorCode{
    NSLog(@"%@",errorCode);
}


#pragma mark - event
- (void)authorizationButtonclick:(ASAuthorizationAppleIDButton *)button API_AVAILABLE(ios(13.0))
{
    if (@available(iOS 13.0, *)) {
        //埋点
        [self MDloginApple_Begin];
        
        [_appLoginManger authorizationAppleIDButtonPressWithSuperView:self.view];
    } else {
        [AlertView toast:@"iOS version must be higher than 13.0" inView:self.view];
    }
}

/**
    
 */
- (void)faceBookButtonClicked
{
    //埋点
    [self MDloginFaceBook_Begin];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];////这个一定要写，不然会出现换一个帐号就无法获取信息的错误
    [AlertView showLoading:@"Login..." inView:self.view];
    [login logInWithPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        [AlertView hiddenLoadingInView:self.view];
        if (error) {
                     NSLog(@"Process error");
            [AlertView toast:error.description inView:self.view];
                 } else if (result.isCancelled) {
                     NSLog(@"Cancelled");
                     [AlertView toast:@"Cancelled" inView:self.view];
                 } else {
                     NSLog(@"Logged in");
                     [self getUserInfoWithResult:result];
                 }
    }];
}

//获取用户信息
- (void)getUserInfoWithResult:(FBSDKLoginManagerLoginResult *)result
{
    NSDictionary*params= @{@"fields":@"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"};
    
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:result.token.userID
                                      parameters:params
                                      HTTPMethod:@"GET"];
    [AlertView showLoading:@"Login..." inView:self.view];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            [AlertView hiddenLoadingInView:self.view];
                NSLog(@"%@",result);
            if (error) {
                [AlertView toast:error.description inView:self.view];
                NSLog(@"Process error");
            }else if(result[@"id"]){
                //facebook登录
                [self loginWithPlatform:@"facebook" uid:result[@"id"] identityToken:nil];
            }else{
                [AlertView showLoading:@"Login with Facebook failed" inView:self.view];
            }
        }];
}


#pragma mark - setter & getter11
- (UIImageView *)titleImageView
{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]initWithImage:XWImageName(@"login_icon")];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *label1 = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(50) aliment:NSTextAlignmentLeft];
        label1.numberOfLines = 2;
        label1.text = kLanguage(@"Welcome to\n Deluxe");
        [_titleImageView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImageView);
            make.top.equalTo(self.titleImageView).offset(kStatusBarAndNavigationBarHeight+30);
        }];
        
        UILabel *label2 = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(20) aliment:NSTextAlignmentLeft];
        label2.text = kLanguage(@"Meet friends from all over the world");
        label2.adjustsFontSizeToFitWidth = YES;
        [_titleImageView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleImageView);
            make.top.equalTo(label1.mas_bottom).offset(20);
        }];
        
        
    }
    return _titleImageView;
}


- (UIView *)faceBoobView
{
    if(!_faceBoobView){
        _faceBoobView = [[UIView alloc]init];
        [_faceBoobView xwDrawCornerWithRadiuce:5];
        
        //添加自定义的facebook
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:@"FACEBOOK" font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"login_facebook") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(faceBookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_faceBoobView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.faceBoobView);
        }];
        _faceBoobView.hidden = YES;
    }
    return _faceBoobView;
}


- (UIView *)appleView
{
    if(!_appleView){
        _appleView = [[UIView alloc]init];
        _appLoginManger = [[MKAppleLogin alloc]init];
        _appLoginManger.delegate = self;
        if (@available(iOS 13.0, *)) {
               //苹果登录按钮
               ASAuthorizationAppleIDButton *authorizationButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
            [authorizationButton addTarget:self action:@selector(authorizationButtonclick:) forControlEvents:(UIControlEventTouchUpInside)];
               [_appleView addSubview:authorizationButton];
               [authorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.edges.equalTo(self.appleView);
               }];
            
               //自定义的苹果登录按钮，
//            UIButton *appleButton = [UIButton creatCommonButtonConfigWithTitle:@" Sign in with Apple" font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
//            appleButton.userInteractionEnabled = NO;
//            [appleButton setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateNormal];
//            [appleButton setImage:XWImageName(@"login_apple") forState:UIControlStateNormal];
//            [authorizationButton addSubview:appleButton];
//            [appleButton xwDrawCornerWithRadiuce:5];
//            [appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(authorizationButton);
//            }];
//            appleButton.hidden = YES;
                
        } else {
            _appleView.alpha = 0;
        }
    }
    return _appleView;
}

- (UILabel *)termLabel
{
    if(!_termLabel){
        _termLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor darkGrayColor] font:Font(12) aliment:NSTextAlignmentCenter];
        _termLabel.text = kLanguage(@"By continuing you agree with");
    }
    return _termLabel;
}

- (UIButton *)termButton
{
    if(!_termButton){
        _termButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Terms of service") font:Font(12) titleColor:[UIColor darkGrayColor] aliment:UIControlContentHorizontalAlignmentRight];
        kXWWeakSelf(weakself);
        [_termButton setAction:^{
            LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
            vc.fileType = 0;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _termButton;
}

- (UIButton *)privateButton
{
    if(!_privateButton){
        _privateButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Privacy agreement") font:Font(12) titleColor:[UIColor darkGrayColor] aliment:UIControlContentHorizontalAlignmentLeft];
        kXWWeakSelf(weakself);
        [_privateButton setAction:^{
            LSProtocolViewController *vc = [[LSProtocolViewController alloc]init];
            vc.fileType = 1;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _privateButton.hidden = YES;
    }
    return _privateButton;
}

- (UIButton *)testButton
{
    if(!_testButton){
        _testButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Sign up with Email") font:Font(16) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _testButton.backgroundColor = [UIColor xwColorWithHexString:@"#222D40"];
        [_testButton xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_testButton setAction:^{
            //埋点
            [weakself MDlogonEmail_Begin];

            LSSignInEmailVC *vc = [[LSSignInEmailVC alloc]init];
            vc.isSignUp = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _testButton;
}

- (UIButton *)eulaButton
{
    if(!_eulaButton){
        _eulaButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"LOG IN") font:FontBold(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentRight];
        kXWWeakSelf(weakself);
        [_eulaButton setAction:^{
            
//            LSEulaVC *vc = [[LSEulaVC alloc]init];
//            vc.modalPresentationStyle = 0;
//            [weakself presentViewController:vc animated:YES completion:nil];
            
            //埋点
            [weakself MDdengluEmail_Begin];
            LSSignInEmailVC *vc = [[LSSignInEmailVC alloc]init];
            vc.isSignUp = NO;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _eulaButton;
}

- (UIImageView *)bgAnimationView
{
    if(!_bgAnimationView){
        _bgAnimationView = [[UIImageView alloc]initWithImage:XWImageName(@"login_bg")];
        _bgAnimationView.contentMode = UIViewContentModeScaleAspectFill;
        _bgAnimationView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    return _bgAnimationView;
}

//开始动画
- (void)popJumpAnimationView{
    
//    CGFloat duration = 20.0;
//    CGFloat height = XW(1519) - kSCREEN_HEIGHT;
//    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
//    animation.duration = duration;
//    animation.values = @[@(0), @(-height),@(0)];
//    animation.keyTimes = @[@(0),@(0.5),@(1)];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.repeatCount = MAXFLOAT;
//    [self.bgAnimationView.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

//结束动画
- (void)stopAnimation
{
    CFTimeInterval pausedTime = [self.bgImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.bgAnimationView.layer.speed = 0.0;
    self.bgAnimationView.layer.timeOffset = pausedTime;
}

@end
