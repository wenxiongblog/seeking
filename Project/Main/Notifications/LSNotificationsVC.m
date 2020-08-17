//
//  LSNotificationsVC.m
//  Project
//
//  Created by XuWen on 2020/2/27.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSNotificationsVC.h"
#import "LSNotiLikesMeView.h"
#import "LSNotiViewedMeView.h"
#import "LSNotiiLikeView.h"

@interface LSNotificationsVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *likeMeButton;
@property (nonatomic,strong) UIButton *viewMeButton;
@property (nonatomic,strong) UIButton *iLikeButton;
@property (nonatomic,strong) UIView *indexView;

@property (nonatomic,strong) UIView *likesMePot;
@property (nonatomic,strong) UIView *viewMePot;
//底部
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) LSNotiLikesMeView *view0;
@property (nonatomic,strong) LSNotiViewedMeView *view1;
@property (nonatomic,strong) LSNotiiLikeView *view2;

@end

@implementation LSNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    [self notificationConfig];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.likeMeButton.selected){
        //见过了喜欢我的，将未读消息刷新
        [LSRongYunHelper readNotificationLikeMe];
    }
    if(self.viewMeButton.selected){
        //见过了喜欢我的，将未读消息刷新
        [LSRongYunHelper readNotificationViewedMe];
    }
}


- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(likeMeNotify:) name:kNotification_LikeMe object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewMeNotify:) name:kNotification_ViewMe object:nil];
}

- (void)likeMeNotify:(NSNotification *)notification
{
    int count = [notification.userInfo[@"unreadcount"]intValue];
    self.likesMePot.hidden = (count == 0);
}

- (void)viewMeNotify:(NSNotification *)notification
{
    int count = [notification.userInfo[@"unreadcount"]intValue];
    self.viewMePot.hidden = (count == 0);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = x/kSCREEN_WIDTH;
    [self chooseButtonWithIndex:page];
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    self.view0 = [[LSNotiLikesMeView alloc]init];
    self.view1 = [[LSNotiViewedMeView alloc]init];
    self.view2 = [[LSNotiiLikeView alloc]init];
    self.view0.eventVC = self;
    self.view1.eventVC = self;
    self.view2.eventVC = self;
    
    self.titleString = kLanguage(@"Notifications");
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.view0];
    [self.contentView addSubview:self.view1];
    [self.contentView addSubview:self.view2];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.navBarView.mas_bottom).offset(10);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.chooseView.mas_bottom).offset(10);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [self.view0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(0);
    }];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.view0.mas_right);
    }];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.view1.mas_right);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view2.mas_right);
    }];
}



#pragma mark - setter & getter1
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UIView *)chooseView
{
    if(!_chooseView){
        _chooseView = [[UIView alloc]init];
        
        self.likeMeButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Likes Me") font:Font(17) titleColor:[UIColor xwColorWithHexString:@"#C2C4CA"] aliment:UIControlContentHorizontalAlignmentCenter];
        self.viewMeButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Viewed Me") font:Font(17) titleColor:[UIColor xwColorWithHexString:@"#C2C4CA"] aliment:UIControlContentHorizontalAlignmentCenter];
        self.iLikeButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"I Liked") font:Font(17) titleColor:[UIColor xwColorWithHexString:@"#C2C4CA"] aliment:UIControlContentHorizontalAlignmentCenter];
        [self.likeMeButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        [self.viewMeButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        [self.iLikeButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        self.likeMeButton.frame = CGRectMake(0, 0, 100, 30);
        self.viewMeButton.frame = CGRectMake(100, 0, 100, 30);
        self.iLikeButton.frame = CGRectMake(200, 0, 100, 30);
        self.likeMeButton.selected = YES;
        //3个按钮点击事件
        kXWWeakSelf(weakself);
        [self.likeMeButton setAction:^{
            //select状态
            [weakself chooseButtonWithIndex:0];
            //ScrollView滚动
            [weakself.scrollView scrollRectToVisible:CGRectMake(kSCREEN_WIDTH*0, 0, kSCREEN_WIDTH, 60) animated:YES];
        }];
        [self.viewMeButton setAction:^{
            [weakself chooseButtonWithIndex:1];
            //ScrollView滚动
            [weakself.scrollView scrollRectToVisible:CGRectMake(kSCREEN_WIDTH*1, 0, kSCREEN_WIDTH, 60) animated:YES];
        }];
        [self.iLikeButton setAction:^{
            [weakself chooseButtonWithIndex:2];
            //ScrollView滚动
            [weakself.scrollView scrollRectToVisible:CGRectMake(kSCREEN_WIDTH*2, 0, kSCREEN_WIDTH, 60) animated:YES];
        }];
        
        [_chooseView addSubview:self.likeMeButton];
        [_chooseView addSubview:self.viewMeButton];
        [_chooseView addSubview:self.iLikeButton];
        
        self.indexView = [[UIView alloc]initWithFrame:CGRectMake(20, 35, 60, 2)];
        self.indexView.backgroundColor = [UIColor themeColor];
        
        [_chooseView addSubview:self.indexView];
        
        //喜欢我的提醒红点
        self.likesMePot = [[UIView alloc]init];
        self.likesMePot.backgroundColor = [UIColor redColor];
        [self.likesMePot xwDrawCornerWithRadiuce:3];
        [_chooseView addSubview:self.likesMePot];
        [self.likesMePot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@6);
            make.left.equalTo(self.likeMeButton.mas_right).offset(-13);
            make.top.equalTo(self.likeMeButton);
        }];
        self.likesMePot.hidden = YES;
        //看过我的提醒红点
        self.viewMePot = [[UIView alloc]init];
        self.viewMePot.backgroundColor = [UIColor redColor];
        [self.viewMePot xwDrawCornerWithRadiuce:3];
        [_chooseView addSubview:self.viewMePot];
        [self.viewMePot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@6);
            make.left.equalTo(self.viewMeButton.mas_right).offset(-10);
            make.top.equalTo(self.viewMeButton);
        }];
        self.viewMePot.hidden = YES;
        
    }
    return _chooseView;
}

- (void)chooseButtonWithIndex:(NSInteger)index
{
    //button选择状态
    switch (index) {
        case 0:
        {
            self.likeMeButton.selected = YES;
            self.viewMeButton.selected = NO;
            self.iLikeButton.selected = NO;
            //见过了喜欢我的，将未读消息刷新
            [LSRongYunHelper readNotificationLikeMe];
        }
            break;
        case 1:
        {
            self.likeMeButton.selected = NO;
            self.viewMeButton.selected = YES;
            self.iLikeButton.selected = NO;
            //见过了看过我的，将未读消息刷新
            [LSRongYunHelper readNotificationViewedMe];
        }
            break;
        case 2:
        {
            self.likeMeButton.selected = NO;
            self.viewMeButton.selected = NO;
            self.iLikeButton.selected = YES;
        }
            break;
            
        default:
            break;
    }
    
    //滚动条
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.indexView.frame = CGRectMake(20+100*index, 35, 60, 2);
    } completion:^(BOOL finished) {
        
    }];
    
    
}


@end
