//
//  LSBaseViewController.m
//  Project
//
//  Created by XuWen on 2020/1/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"
#import "LSBaseNavigationController.h"
#import "LSRongYunHelper.h"

#define kItem_Space 5

@interface LSBaseViewController ()

@property (nonatomic,copy) NavItemClickedBlock rightItemclickedBlock;

@end

@implementation LSBaseViewController

- (void)speciceNavWithTitle:(NSString *)title
{
    self.navTitleLabel.text = title;
    self.backButton.hidden = NO;
    [self.navTitleLabel setFont:Font(17)];
    self.navTitleLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44);
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navBarView.backgroundColor = [UIColor projectBackGroudColor];
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    self.bgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"commonBg")];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.bgImageView.hidden = NO;
    
    self.navBarView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.navBarView];
    [self.navBarView addSubview:self.backButton];
    [self.navBarView addSubview:self.navTitleLabel];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


// 页面跳转（不带参数）
- (void)pushViewController:(NSString *)className  {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentViewController:(NSString *)className {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    LSBaseNavigationController *navi = [[LSBaseNavigationController alloc] initWithRootViewController:vc];
    [self xx_presentViewController:navi makeAnimatedTransitioning:^(XXAnimatedTransitioning * _Nonnull transitioning) {
        transitioning.duration = 0.5;
        transitioning.animationKey = presentTransitionAnimationModalSink;
    } completion:^{
    }];
}

// 页面跳转（不带参数、带返回结果）
- (void)pushViewController:(NSString *)className result:(void(^)(NSDictionary *dict))block {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setResultBlock:block];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentViewController:(NSString *)className result:(void(^)(NSDictionary *dict))block {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setResultBlock:block];
    LSBaseNavigationController *navi = [[LSBaseNavigationController alloc] initWithRootViewController:vc];
    [self xx_presentViewController:navi makeAnimatedTransitioning:^(XXAnimatedTransitioning * _Nonnull transitioning) {
        transitioning.duration = 0.5;
        transitioning.animationKey = presentTransitionAnimationModalSink;
    } completion:^{
    }];
}

// 页面跳转（带参数）
- (void)pushViewController:(NSString *)className params:(NSDictionary *)params {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setParams:params]; //传入参数
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentViewController:(NSString *)className params:(NSDictionary *)params {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setParams:params]; //传入参数
    LSBaseNavigationController *navi = [[LSBaseNavigationController alloc] initWithRootViewController:vc];
    [self xx_presentViewController:navi makeAnimatedTransitioning:^(XXAnimatedTransitioning * _Nonnull transitioning) {
        transitioning.duration = 0.5;
        transitioning.animationKey = presentTransitionAnimationModalSink;
    } completion:^{
    }];
}

// 页面跳转（带参数、带返回结果）
- (void)pushViewController:(NSString *)className params:(NSDictionary *)params result:(void(^)(NSDictionary *dict))block {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setParams:params]; //传入参数
    [vc setResultBlock:block];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentViewController:(NSString *)className params:(NSDictionary *)params result:(void(^)(NSDictionary *dict))block {
    LSBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    [vc setParams:params]; //传入参数
    [vc setResultBlock:block];
    LSBaseNavigationController *navi = [[LSBaseNavigationController alloc] initWithRootViewController:vc];
    [self xx_presentViewController:navi makeAnimatedTransitioning:^(XXAnimatedTransitioning * _Nonnull transitioning) {
        transitioning.duration = 0.5;
        transitioning.animationKey = presentTransitionAnimationModalSink;
    } completion:^{
    }];
}

// 重些该方法，在页面结束后主动触发更新状态栏颜色
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:^{
        // 触发回调
        if (completion) { completion(); }
        // 主动触发刷新状态栏颜色
        [[self getCurrentVC] setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma Mark - public
- (void)hideNav
{
    self.navBarView.hidden = YES;
}

- (void)hideBackButton
{
    self.backButton.hidden = YES;
}

- (void)addRightItemWithImage:(UIImage *)image clickBlock:(NavItemClickedBlock)clickBlock
{
    [self.navBarView addSubview:self.rightItemButton];
    self.rightItemclickedBlock = clickBlock;
    [self.rightItemButton setImage:image forState:UIControlStateNormal];
    [self.rightItemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
}

- (void)addRightItemWithString:(NSString *)string clickBlock:(NavItemClickedBlock)clickBlock
{
    [self.navBarView addSubview:self.rightItemButton];
    self.rightItemclickedBlock = clickBlock;
    [self.rightItemButton commonButtonConfigWithTitle:string font:Font(17) titleColor:[UIColor xwColorWithHexString:@"#ED4A47"] aliment:UIControlContentHorizontalAlignmentRight];
}
        
#pragma mark - event
- (void)rightButtonItemClicked
{
    if(self.rightItemclickedBlock){
        self.rightItemclickedBlock();
    }
}
        
- (void)backButtonClicked
{
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
        

#pragma mark - setter & getter1
- (UIView *)navBarView
{
    if(!_navBarView){
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kStatusBarAndNavigationBarHeight)];
//        [_navBarView showBottomLineWithXSpace:0];
//        [_navBarView addSubview:self.shandowColorView];
        _navBarView.backgroundColor = [UIColor projectBackGroudColor];
    }
    return _navBarView;
}
        
- (UIButton *)backButton
{
    if(!_backButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(kItem_Space, kStatusBarHeight, 44, 44);
        [button setImage:XWImageName(@"ReturnButton") forState:UIControlStateNormal];
        _backButton = button;
        _backButton.hidden = YES;
    }
    return _backButton;
}
        
- (UIButton *)rightItemButton
{
    if(!_rightItemButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kSCREEN_WIDTH-80-kItem_Space - 10, kStatusBarHeight, 80, 44);
        [button addTarget:self action:@selector(rightButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _rightItemButton = button;
    }
    return _rightItemButton;
}
    
- (UILabel *)navTitleLabel
{
    if(!_navTitleLabel){
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kStatusBarHeight, 200, 44)];
        [_navTitleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(30) aliment:NSTextAlignmentLeft];
    }
    return _navTitleLabel;
}

//- (UIImageView *)shandowColorView
//{
//    if (!_shandowColorView) {
//        _shandowColorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationContentTopConstant - 5, SCREEN_WIDTH, 5)];
//        _shandowColorView.image = [UIImage imageNamed:@"geduan"];
//        _shandowColorView.hidden = YES;
//    }
//    return _shandowColorView;
//}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.navTitleLabel.text = titleString;
}

#pragma mark - request

/// 更新用户信息
/// @param loading 是否显示等待加载
/// @param finished 完成回调
- (void)updateUserInfoWithLoading:(BOOL)loading finish :(void(^)(BOOL finished))finished
{
    //设置融云头像和昵称
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:kUser.conversationId name:kUser.name portrait:kUser.images];
    [RCIM sharedRCIM].currentUserInfo.extra = kUser.rongYunExtra;
    
    //附加信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setNullObject:kUser.uid forKey:@"uid"];
    [dict setNullObject:kUser.id forKey:@"id"];
    [dict setNullObject:kUser.creattime forKey:@"creattime"];
    //
    [dict setNullObject:@(kUser.sex) forKey:@"sex"];
    [dict setNullObject:@(kUser.seeking) forKey:@"seeking"];
    [dict setNullObject:kUser.name forKey:@"name"];
    if(kUser.age>=18){
        [dict setNullObject:@(kUser.age) forKey:@"age"];
    }
    //头像
    [dict setNullObject:kUser.images forKey:@"images"];
    //照片
    [dict setNullObject:kUser.imageslist forKey:@"imageslist"];
    //关于我的描述
    [dict setNullObject:kUser.about forKey:@"about"];
    //身高
    [dict setNullObject:kUser.height forKey:@"height"];
    //体重
    [dict setNullObject:kUser.weight forKey:@"weight"];
    //情感状态
    [dict setNullObject:kUser.relationship forKey:@"relationship"];
    //交友目的
    [dict setNullObject:kUser.needfor forKey:@"needfor"];
    //交友年龄区间
    [dict setNullObject:kUser.lookingforage forKey:@"lookingforage"];
    //兴趣爱好
    [dict setNullObject:kUser.interested forKey:@"interested"];
    //是否是隐身状态
    [dict setNullObject:@(kUser.incognito) forKey:@"incognito"];
    
    //城市
    [dict setNullObject:kUser.address forKey:@"address"];
    
    if(loading){
        [AlertView showLoading:kLanguage(@"loading...") inView:self.view];
    }
    kXWWeakSelf(weakself);
    [kUser updateUserInfo:dict complete:^(BOOL Success, NSString * _Nonnull msg) {
        [AlertView hiddenLoadingInView:weakself.view];
        if(Success){
            //更像融云头像和名字
            [LSRongYunHelper uploadMyRongYunUserInfo];
            finished(YES);
        }else{
//            [AlertView toast:msg inView:self.view];
            finished(NO);
        }
    }];
}

- (void)updateUserInfo:(void(^)(BOOL finished))finished
{
    [self updateUserInfoWithLoading:YES finish:finished];
}


/**
    更新用户位置
 */
- (void)UpdateLocation:(void(^)(BOOL finished))finished
{
    if(kUser.id == nil || kUser.lng == 0 || kUser.lat == 0){
        return;
    }
    
    NSDictionary *params = @{
        @"userid":kUser.id,
        @"lng":@(kUser.lng),
        @"lat":@(kUser.lat),
    };
    
    [self post:kURL_LocationRefresh params:params success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            finished(YES);
        }else{
            [AlertView toast:response.message inView:self.view];
            finished(NO);
        }
        
    } fail:^(NSError * _Nonnull error) {
    }];
}
@end
