//
//  LSSignUpBaseVC.m
//  Project
//
//  Created by XuWen on 2020/2/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpBaseVC.h"
#import "LSRongYunHelper.h"
#import "LSSignInNavigationController.h"
#import "LSLogChooseVC.h"
#import "CountDownButton.h"

@interface LSSignUpBaseVC ()

@end

@implementation LSSignUpBaseVC

#pragma mark - 埋点
//facebook
- (void)MDloginFaceBook{}
//apple
- (void)MDloginApple{}

// 埋点登录失败
- (void)MDloginFailed{}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.view.backgroundColor = [UIColor xwColorWithHexString:@"#253045"];
    //标题
    self.titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(36) aliment:NSTextAlignmentLeft];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.navBarView.mas_bottom).offset(40);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - 登录请求
- (void)loginWithPlatform:(NSString *)platform uid:(NSString *)uid identityToken:(NSString *)identityToken
{
    //开始去登录
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"platform"] = platform;
    paramDict[@"uid"] = uid;
    if([platform isEqual:@"apple"]){
        paramDict[@"identityToken"] = identityToken;
    }
    
    [AlertView showLoading:kLanguage(@"Loading...") inView:self.view];
    
    [self post:kURL_RegisterByPwd params:paramDict success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:self.view];
        if(response.isSuccess){
            NSDictionary *dict = [response.content objectForKey:@"outuser"];
            //先退出登录，清空缓存
            [LSRongYunHelper logout];
            [kUser clear];
            [kUser mj_setKeyValues:dict];
            [kUser synchronize];
            [self analysisStatus:[SEEKING_UserModel share].status];
            
            //埋点 注册流程
            if([SEEKING_UserModel share].status == 0){
                if([platform isEqualToString:@"facebook"]){
                    [self MDloginFaceBook];
                }else{
                    [self MDloginApple];
                }
            }
        }else{
            [AlertView toast:response.message inView:self.view];
            [self MDloginFailed];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:self.view];
        [self MDloginFailed];
    }];
}

#pragma mark - private
/// 注册流程
/// @param status 分析注册结果
- (void)analysisStatus:(NSInteger)status
{
//    kXWWeakSelf(weakself);
    if(status == 0){
        //注册成功
        
        //删除账号这里
        [CountDownButton saveCountTime_deleteAcount];
        
        //注册成功，从头开始进入完善流程
        kUser.isZhuce = YES;//标记为注册流程
        LSLogChooseVC *vc = [[LSLogChooseVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(status == 1){
        //埋点
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
        [self MDloginFailed];
    }
}


@end
