//
//  LSConversationVC.m
//  Project
//
//  Created by XuWen on 2020/1/22.
//  Copyright © 2020 xuwen. All rights reserved.

#import "LSConversationVC.h"
#import "LSConversationCell.h"
#import "LSMessageMatchView.h"
#import "LSRYChatViewController.h"
#import "LSRongYunHelper.h"
#import "HPTabBarController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LSChatNotificationView.h"  //底部消息推送的框
#import "CountDownButton.h"
#import "LSGirlZhaoHuHealper.h"
#import "FBShimmeringView.h"

@interface LSConversationVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UIView *navBarView;
@property (nonatomic,strong)UILabel *navTitleLabel;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) LSMessageMatchView *matchView;
@property (nonatomic,strong) UILabel *matchLabel;
//开启Norification弹窗
@property (nonatomic,strong) LSChatNotificationView *nofiticationView;
//数据
@property (nonatomic,strong) NSMutableArray <SEEKING_Customer *>*dataArray;

//打招呼
@property (nonatomic,strong) UIView *zhaohuView;
@property (nonatomic,strong) CountDownButton *countDownButton;
@property (nonatomic,strong) FBShimmeringView *shimmeringView;

@end

@implementation LSConversationVC

- (void)MDOpenNotification{}
- (void)MDSayHi_message{}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //底部notificationView
    if([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone){
        self.nofiticationView = [[LSChatNotificationView alloc]init];
        kXWWeakSelf(weakself);
        self.nofiticationView.CloseBlockClicked = ^{
            [weakself.view sendSubviewToBack:weakself.nofiticationView];
        };
        self.nofiticationView.TapClicked = ^{
            [weakself.view sendSubviewToBack:weakself.nofiticationView];
            [JumpUtils jumpSystemSetting];
        };
        [self.view addSubview:self.nofiticationView];
        [self.nofiticationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarHeight);
            make.height.equalTo(@70);
        }];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"commonBg")];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view sendSubviewToBack:imageView];
    
    //系统会话置顶
    [[RCIMClient sharedRCIMClient]setConversationToTop:ConversationType_SYSTEM targetId:@"Meet_system" isTop:YES];
    
    //融云列表为空的显示关闭，方便显示自己的
    self.emptyConversationView = [UIView new];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                             @(ConversationType_GROUP)]];
    //self.view
    self.view.backgroundColor = [UIColor clearColor];
    
    //navBar
    
    //tableViewConfig
    self.conversationListTableView.emptyDataSetDelegate = self;
    self.conversationListTableView.emptyDataSetSource = self;
    self.conversationListTableView.tableHeaderView = self.headView;
    [self.conversationListTableView commonTableViewConfig];
    [self.conversationListTableView registerClass:[LSConversationCell class] forCellReuseIdentifier:kLSConversationCellIdentifier];
    self.conversationListTableView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.delaysContentTouches = NO;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(kUser.sex == 2){
        //打招呼
        [self.view addSubview:self.zhaohuView];
        [self.zhaohuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight+5);
            make.width.equalTo(@(XW(336)));
            make.height.equalTo(@(XW(43)));
            make.centerX.equalTo(self.view);
        }];
        //女生有打招呼内容
        [self.conversationListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.zhaohuView.mas_bottom).offset(10);
        }];
    }else{
        [self.conversationListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight+5);
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    {
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController.navigationBar addSubview:self.navBarView];
        self.navBarView.frame = CGRectMake(0, -kStatusBarHeight, kSCREEN_WIDTH, kStatusBarAndNavigationBarHeight);
    }
    
    [self notifyUpdateUnreadMessageCount];
    
    //尝试登录 后获取配对
    [JumpUtils jumpLoginModelComplete:^(BOOL success) {
       if(success){
           [self matchListData];
       }
    }];
    
    //统计开启了推送
    NSLog(@"asdf");
    if([UIApplication sharedApplication].currentUserNotificationSettings.types != UIUserNotificationTypeNone){
        if(![[NSUserDefaults standardUserDefaults]boolForKey:@"openNotification"]){
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"openNotification"];
            [self MDOpenNotification];
        }
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    //发送打招呼刷新一下
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dazhaohuNotifi) name:kNotifidation_DazhaHuReloead object:nil];
}

- (void)dazhaohuNotifi
{
//    [self willReloadTableData:self.conversationListDataSource];
//    [self.conversationListTableView reloadData];
     [super viewWillAppear:NO];
     [super viewDidAppear:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - 自定义
//对数据进行重新筛选
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    NSMutableArray *data = [dataSource copy];
    for(RCConversationModel *model in dataSource){
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        
        //会话是发送方
        if(model.lastestMessageDirection == MessageDirection_SEND){
            //会话的消息数量 是1
            int count = [[RCIMClient sharedRCIMClient]getMessageCount:model.conversationType targetId:model.targetId];
            if(count > 1){
                continue;
            }
            //会话中包含了 打招呼
            NSString *str = model.lastestMessage.senderUserInfo.extra;
            if(str){
                NSDictionary *dict = [str josnToDictionary];
                if(dict != nil){
                    NSString *zhaohu = dict[@"zhaohu"];
                    if([zhaohu isEqualToString:@"zhaohu"]){
                        //删除消息
                        [[RCIMClient sharedRCIMClient]deleteMessages:model.conversationType targetId:model.targetId success:^{
                            //删除会话
                            [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
                        } error:^(RCErrorCode status) {
                            
                        }];
                    }
                }
            }
        }
    }
    return data;
}

-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    //接收到消息
    [super didReceiveMessageNotification:notification];
}

- (void)notifyUpdateUnreadMessageCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LSRongYunHelper notifyUpdateUnreadMessageCount];
    });
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.5;
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSConversationCellIdentifier forIndexPath:indexPath];
    return cell;
}

 #pragma mark - 设置cell的删除事件
- (void)didDeleteConversationCell:(RCConversationModel *)model
{
    [super didDeleteConversationCell:model];
    [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
    [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:model.targetId];

    //删除后的刷新方法有点奇怪。
    [super viewWillAppear:NO];
    [super viewDidAppear:NO];
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
// default 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Noti_likesMe"];
}

// default 描述字段
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"No messages, yet.");
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// default subtitle 描述字段
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = kLanguage(@"No messages in your inbox.\nStart chatting with people around you.");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor xwColorWithHexString:@"#bfbfbf"],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


//button图片
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [UIImage imageNamed:kLanguage(@"chat_Match")];
}

//button 点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Logout_TabChanged object:nil];
}

//距离顶部的距离 的偏移
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return YH(0);
}

#pragma mark - 点击进入聊天界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    LSRYChatViewController *chatVC = [[LSRYChatViewController alloc]initWithSystemInfo:model.conversationType == ConversationType_SYSTEM];
    //看如果是匹配用户，就不需要VIP
    chatVC.conversationType = model.conversationType;
    chatVC.targetId = model.targetId;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma mark - private
#pragma mark - Data

- (void)matchListData
{
    if(kUser.isLogin){
        NSDictionary *params = @{
            @"id":kUser.id,
        };
        kXWWeakSelf(weakself);
        [self post:kURL_MatchList params:params success:^(Response * _Nonnull response) {
            if(response.isSuccess){
                NSArray *dataArray = response.content;
                NSArray <SEEKING_Customer *>*cutomerArray = [SEEKING_Customer mj_objectArrayWithKeyValuesArray:dataArray];
                weakself.dataArray = [NSMutableArray arrayWithArray:cutomerArray];
                [weakself reloadMatchData]; //刷新machData
                
                //缓存融云用户数据
                [LSRongYunHelper ryCashUserArray:cutomerArray];
                kUser.matchArray = cutomerArray;
                [weakself.conversationListTableView reloadData]; //刷新会话数据,match。
            }
        } fail:^(NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark - setter * getter
- (UIView *)navBarView
{
    if(!_navBarView){
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kStatusBarAndNavigationBarHeight)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"nag_bg")];
        [_navBarView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navBarView);
        }];
        
        _navBarView.backgroundColor = [UIColor clearColor];
        [_navBarView addSubview:self.navTitleLabel];
    }
    return _navBarView;
}
- (UILabel *)navTitleLabel
{
    if(!_navTitleLabel){
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kStatusBarHeight, 200, 44)];
        [_navTitleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(30) aliment:NSTextAlignmentLeft];
        _navTitleLabel.text = kLanguage(@"Message");
    }
    return _navTitleLabel;
}

- (void)reloadMatchData
{
    self.matchView.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
    
    if(self.dataArray.count > 0){
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 120);
            self.headView.alpha = 1;
            self.matchLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [self.conversationListTableView reloadData];
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
            self.headView.alpha = 0;
            self.matchLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.conversationListTableView reloadData];
        }];
    }
}

- (UIView *)headView
{
    if(!_headView){
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
        _headView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#AAAAAA"] font:Font(12) aliment:NSTextAlignmentLeft];
        label.text = kLanguage(@"Matches");
        [_headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset(20);
            make.top.equalTo(self.headView).offset(10);
        }];
        self.matchLabel = label;
        self.matchLabel.alpha = 0;
        //matchView
        [_headView addSubview:self.matchView];
        [self.matchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(0);
            make.left.equalTo(self.headView).offset(0);
            make.right.equalTo(self.headView).offset(0);
            make.height.equalTo(@100);
        }];
    }
    return _headView;
}

- (LSMessageMatchView *)matchView
{
    if(!_matchView){
        _matchView = [[LSMessageMatchView alloc]init];
    }
    return _matchView;
}

- (NSMutableArray<SEEKING_Customer *> *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)zhaohuView
{
    if(!_zhaohuView){
        _zhaohuView = [[UIView alloc]init];
        [_zhaohuView xwDrawCornerWithRadiuce:6];
        _zhaohuView.backgroundColor = [UIColor clearColor];
        
        //背景图片
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"match_zhaohuBg")];
        bgImageView.frame = CGRectMake(0, 0, XW(336), XW(43));
        [_zhaohuView addSubview:self.shimmeringView];
        self.shimmeringView.contentView = bgImageView;
        
        //箭头
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:XWImageName(@"matchs_right")];
        [_zhaohuView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.zhaohuView);
            make.right.equalTo(self.zhaohuView).offset(-10);
        }];
        
        //倒计时安娜
        [_zhaohuView addSubview:self.countDownButton];
        self.countDownButton.hitEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
        [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.zhaohuView);
            make.right.equalTo(arrowImageView.mas_left).offset(-10);
        }];
        
    }
    return _zhaohuView;
}

- (CountDownButton *)countDownButton
{
    if(!_countDownButton){
        _countDownButton = [[CountDownButton alloc]init];
        _countDownButton.userInteractionEnabled = YES;
        _countDownButton.showTimeStyle = ShowTimeStyleCustomer;
//        [_countDownButton setImage:XWImageName(@"matchs_right") forState:UIControlStateNormal];
        [_countDownButton commonButtonConfigWithTitle:kLanguage(@"Send messages to get attention     ") font:FontBold(17) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentRight];
//        [_countDownButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        kXWWeakSelf(weakself);
        _countDownButton.CountDownProgressBlock = ^(BOOL finished, int progress) {
            if(finished){
                weakself.shimmeringView.shimmering = YES;
                weakself.countDownButton.userInteractionEnabled = YES;
                [weakself.countDownButton setTitle:kLanguage(@"Send messages to get more attention     ") forState:UIControlStateNormal];
            }
        };
        
        [_countDownButton setAction:^{
            weakself.shimmeringView.shimmering = NO;
            [weakself.countDownButton startCountDown:5*60];
            //发送消息
            NSLog(@"发送消息");
            [LSGirlZhaoHuHealper zhaohuWithoutAlert];
            //埋点
            [weakself MDSayHi_message];
        }];
    }
    return _countDownButton;;
}

- (FBShimmeringView *)shimmeringView
{
    if(!_shimmeringView){
        _shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, XW(336), XW(43))];
        _shimmeringView.shimmering = YES;
    }
    return _shimmeringView;
}

@end
