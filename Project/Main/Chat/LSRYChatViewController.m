//
//  LSRYChatViewController.m
//  Project
//
//  Created by XuWen on 2020/3/8.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSRYChatViewController.h"
#import "LSChooseAlertView.h"
#import "LSDetailViewController.h"
#import "LSVIPAlertView.h"
#import "LSRongYunHelper.h"
#import "LSMessageFastSendView.h" //快速发送消息
#import "LSNotificationAlertView.h"

@interface LSRYChatViewController ()
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong)UIView *navBarView;
@property (nonatomic,strong)UILabel *navTitleLabel;
@property (nonatomic,strong) UIImageView *headImageView;
//开启通知
@property (nonatomic,strong) UIView *notificationView;
@property (nonatomic,strong) UILabel *notificationLabel;
//customer
@property (nonatomic,strong) SEEKING_Customer *customer;  //通过targetID 得到 id block profile用
//判断是否是系统消息
@property (nonatomic,assign) BOOL isSystemInfo;
@end

@implementation LSRYChatViewController

- (instancetype)initWithSystemInfo:(BOOL)systemInfo
{
    self = [super init];
    if(self){
        self.isSystemInfo = systemInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //不显示
    self.displayUserNameInCell = NO;
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.notificationView];
    [self.view bringSubviewToFront:self.conversationMessageCollectionView];
    //背景颜色
    self.conversationMessageCollectionView.backgroundColor = [UIColor projectBackGroudColor];
    
    //是否开启了推送
    if([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone){
        [self.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight+50);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.chatSessionInputBarControl.mas_top);
        }];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [self.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.chatSessionInputBarControl.mas_top);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 消息数量是否为空？展示快速发送消息
//    NSLog(@"%ld",self.conversationDataRepository.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.isSystemInfo){
                //要展示VIP内购就不展示了
                [LSMessageFastSendView show:NO onVC:self];
            }else{
                [LSMessageFastSendView show:self.conversationDataRepository.count == 0 onVC:self];
            }
        });
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - UIConfige
//更换聊天气泡
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell isMemberOfClass:[RCTextMessageCell class]]){
        RCTextMessageCell *textCell=(RCTextMessageCell *)cell;
        if(cell.messageDirection == MessageDirection_SEND){
            //发送
            textCell.bubbleBackgroundView.image = XWImageName(@"chat_send_bubble");
        }else{
            //接受
            textCell.bubbleBackgroundView.image = XWImageName(@"chat_receive_bubble");
        }
    }
//
//    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
//            RCTextMessageCell *textCell=(RCTextMessageCell *)cell;
//    //      自定义气泡图片的适配
//            UIImage *image=textCell.bubbleBackgroundView.image;
//            textCell.bubbleBackgroundView.image=[textCell.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
//    //      更改字体的颜色
//            textCell.textLabel.textColor=[UIColor redColor];
//        }
}

#pragma mark - event
- (void)headImageButtonClicked
{
    kXWWeakSelf(weakself);
    [LSChooseAlertView showWithTileArray:@[@"Profile",@"Report",@"Block User",] select:^(NSString * _Nonnull title) {
        if([title isEqualToString:@"Report"]){
            [weakself reportUser];
        } if([title isEqualToString:@"Block User"]){
            [weakself blockUser];
        }else if([title isEqualToString:@"Profile"]){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LSDetailViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    return ;
                }
            }
            LSDetailViewController *vc = [[LSDetailViewController alloc]init];
            vc.customer = self.customer;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
}

#pragma mark - private
- (void)blockUser
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure you want to block the user" message:@"After that, this user's profile will not be shown in your Search result page, and he/she can't view or message you any more." preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self postBlockUser];
       }];
       
       UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           //取消
       }];
       
       //把action添加到actionSheet里
       [actionSheet addAction:yesAction];
       [actionSheet addAction:noAction];
       
       [self presentViewController:actionSheet animated:YES completion:^{
       }];
}

- (void)reportUser
{
    [LSChooseAlertView showWithTileArray:@[@"Makes me unconfortable",@"Inappropriate content",@"Pron or stolen photo",@"Spam or scarm",] select:^(NSString * _Nonnull title) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AlertView toast:@"Report success" inView:self.view];
        });
    }];
}

- (void)postBlockUser
{
    NSDictionary *params = @{
        @"id":kUser.id,
        @"blacklistid":self.customer.id,
    };
    kXWWeakSelf(weakself);
    [self post:kURL_BlockUser params:params success:^(Response * _Nonnull response) {
        if(response.isSuccess){
            [AlertView toast:@"You bloked this user!" inView:weakself.view];
        }else{
            [AlertView toast:@"failed" inView:weakself.view];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView toast:error.description inView:weakself.view];
    }];
}

#pragma mark - 准备发送消息的回调
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent
{
    
    //1.如果自己是VIP可以发送消息
    //2.如果对方是VIP可以发送消息
    //3.如果是匹配用户，可以发送消息
    //4.如果是自己是女性可以发送消息
    //5.如果是第一条消息可以发送

    //是否是VIP
    NSString *str = self.userInfo.extra;
    BOOL taisVIP = NO;
    if(str){
       NSDictionary *dict = [self.userInfo.extra josnToDictionary];
       if(dict != nil){
           if(dict[@"isVIP"]){
               BOOL isVIP = [dict[@"isVIP"] boolValue];
               NSLog(@"%d",isVIP);
               taisVIP = isVIP;
           }
        }
    }
    
    //是否匹配
    BOOL isMatch = [kUser.matchArray containsObject:self.userInfo.userId];
    
    if(kUser.isVIP || kUser.sex == 2 || taisVIP == YES || self.conversationDataRepository.count == 0 || isMatch){
        return messageContent;
    }else{
        [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_message];
       return nil;
    }
}

- (void)didSendMessage:(NSInteger)status content:(RCMessageContent *)messageContent
{
    NSLog(@"发送了消息");
    dispatch_async(dispatch_get_main_queue(), ^{
        [LSMessageFastSendView show:NO onVC:self];
    });
}


#pragma mark - setter & getter1
- (UIView *)navBarView
{
    if(!_navBarView){
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kStatusBarAndNavigationBarHeight)];
        _navBarView.backgroundColor = [UIColor projectBackGroudColor];
        [_navBarView addSubview:self.navTitleLabel];
        [_navBarView addSubview:self.backButton];
        [_navBarView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@34);
            make.centerY.equalTo(self.backButton);
            make.right.equalTo(self.navBarView).offset(-15);
        }];
    }
    return _navBarView;
}

- (UILabel *)navTitleLabel
{
    if(!_navTitleLabel){
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44)];
        [_navTitleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentCenter];
    }
    return _navTitleLabel;
}

- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageButtonClicked)];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView xwDrawCornerWithRadiuce:17];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UIButton *)backButton
{
    if(!_backButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
        [button setImage:XWImageName(@"ReturnButton") forState:UIControlStateNormal];
        _backButton = button;
    }
    return _backButton;
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUserInfo:(RCUserInfo *)userInfo
{
    _userInfo = userInfo;
    //判断是否是系统消息
    //单独判断 userinfo == nil 不行
    if(self.isSystemInfo && userInfo == nil){
        //系统消息没有userInfo
        self.navTitleLabel.text = kLanguage(@"System messages");
        self.notificationLabel.text = [NSString stringWithFormat:kLanguage(@"Open notification when %@ answers"),self.navTitleLabel.text];
        self.headImageView.hidden = YES;
        self.customer = nil;
    }else{
        self.headImageView.hidden = NO;
        self.navTitleLabel.text = userInfo.name;
        self.notificationLabel.text = [NSString stringWithFormat:kLanguage(@"Open notification when %@ answers"),self.navTitleLabel.text];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
        self.customer = [[SEEKING_Customer alloc]init];
        self.customer.id = [userInfo.userId componentsSeparatedByString:@"_"].lastObject;
    }
}

- (void)setTargetId:(NSString *)targetId
{
    [super setTargetId:targetId];
    self.userInfo = [LSRongYunHelper getUserInfoCach:targetId];
}

//- (void)setIsSystemInfo:(BOOL)isSystemInfo
//{
//    _isSystemInfo = isSystemInfo;
//    if(!isSystemInfo){
//
//    }else{
//        //如果是系统消息隐藏底部 输入框
////        [self.chatSessionInputBarControl mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(self.view.mas_bottom);
////            make.left.right.equalTo(self.view);
////            make.height.equalTo(@20);
////        }];
//        self.chatSessionInputBarControl.alpha = 0;
//    }
//}

- (BOOL)haveReceiveMessage
{
    NSArray <RCMessageModel *>*array = [NSArray arrayWithArray:self.conversationDataRepository];
    for(RCMessageModel *model in array){
        if(model.messageDirection == MessageDirection_RECEIVE){
            return YES;
        }
    }
    return NO;
}

- (UIView *)notificationView
{
    if(!_notificationView){
        _notificationView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kSCREEN_WIDTH, 50)];
        _notificationView.backgroundColor = [UIColor themeColor];
        //通知设置按钮
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"ENABLE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawBorderWithColor:[UIColor whiteColor] radiuce:5 width:1];
        [_notificationView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@92);
            make.height.equalTo(@31);
            make.centerY.equalTo(self.notificationView);
            make.right.equalTo(self.notificationView).offset(-16);
        }];
        kXWWeakSelf(weakself);
        [button setAction:^{
            [weakself.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.chatSessionInputBarControl.mas_top);
            }];
            [JumpUtils jumpSystemSetting];
        }];
        
        //通知label
        [_notificationView addSubview:self.notificationLabel];
        [self.notificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.notificationView).offset(10);
            make.top.bottom.equalTo(self.notificationView);
            make.right.equalTo(button.mas_left).offset(-10);
        }];
        
    }
    return _notificationView;
}

- (UILabel *)notificationLabel
{
    if(!_notificationLabel){
        _notificationLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(17) aliment:NSTextAlignmentLeft];
        _notificationLabel.numberOfLines = 2;
    }
    return _notificationLabel;
}

- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}


@end
