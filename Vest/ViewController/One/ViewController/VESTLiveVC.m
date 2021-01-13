//
//  VESTLiveVC.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTLiveVC.h"
#import "VESTMsgSendView.h"
#import "VESTMessageView.h"
#import "VESTCustomerAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "VESTUserTool.h"
#import "LSChooseAlertView.h"

@interface VESTLiveVC ()
@property (nonatomic,strong)UIButton *hostButton;
@property (nonatomic,strong)UIButton *oneButton;
@property (nonatomic,strong)UIButton *twoButton;
@property (nonatomic,strong)UIButton *threeButton;
@property (nonatomic,strong)UIButton *fourButton;

@property (nonatomic,strong)VESTMsgSendView *sendView;
@property (nonatomic,strong)VESTMessageView *messageview;

@property (nonatomic,strong) NSMutableArray<VESTMessageModel *>  *messageArray;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (nonatomic,strong) UIButton *jubaoButton;
@end

@implementation VESTLiveVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.userModel.yuying withExtension:@""];
      self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
      self.audioPlayer.numberOfLoops = -1;
      [self.audioPlayer prepareToPlay];
      [self.audioPlayer play];
}

- (void)dealloc
{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    //nav 配置
   self.bgImageView.image = XWImageName(@"vest_signInBG");
   self.backButton.hidden = NO;
   [self.backButton setImage:XWImageName(@"vest_back") forState:UIControlStateNormal];
   self.titleString = @"Chat";
   self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
   self.navTitleLabel.font = FontBold(24);
   self.navTitleLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44);
    
    [self.view addSubview:self.jubaoButton];
       [self.jubaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.height.centerY.equalTo(self.backButton);
           make.right.equalTo(self.view).offset(-15);
       }];
    
    [self.view addSubview:self.hostButton];
    [self.view addSubview:self.oneButton];
    [self.view addSubview:self.twoButton];
    [self.view addSubview:self.threeButton];
    [self.view addSubview:self.fourButton];
    
    [self.view addSubview:self.sendView];
    [self.view addSubview:self.messageview];
}

- (void)baseConstraintsConfig
{
    [self.hostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(XW(220)));
        make.top.equalTo(self.navBarView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(-XW(43));
    }];
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(XW(84)));
        make.top.equalTo(self.hostButton).offset(XW(18));
        make.left.equalTo(self.hostButton.mas_right).offset(10);
    }];
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.oneButton);
        make.top.equalTo(self.oneButton);
        make.left.equalTo(self.oneButton.mas_right);
    }];
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.oneButton);
        make.bottom.equalTo(self.hostButton).offset(XW(-18));
        make.left.equalTo(self.oneButton);
    }];
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.oneButton);
        make.bottom.equalTo(self.threeButton);
        make.left.equalTo(self.twoButton);
    }];
    [self.messageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sendView.mas_top).offset(-20);
        make.top.equalTo(self.hostButton.mas_bottom).offset(20);
    }];
}

#pragma mark - setter & getter
- (UIButton *)hostButton
{
    if(!_hostButton){
        _hostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hostButton xwDrawCornerWithRadiuce:XW(154)];
//        [_hostButton setImage:XWImageName(@"vest_test") forState:UIControlStateNormal];
        _hostButton.backgroundColor = [UIColor xwRandomDarkColor];
        [_hostButton setAction:^{
            VESTCustomerAlertView *alertView = [[VESTCustomerAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
            alertView.eventVC = self;
            alertView.userModel = self.userModel;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            [alertView appearAnimation];
        }];
    }
    return _hostButton;
}

- (UIButton *)oneButton
{
    if(!_oneButton){
        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneButton xwDrawCornerWithRadiuce:XW(59)];
        [_oneButton setBackgroundImage:XWImageName(@"add_z") forState:UIControlStateNormal];
    }
    return _oneButton;;
}

- (UIButton *)twoButton
{
    if(!_twoButton){
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoButton xwDrawCornerWithRadiuce:XW(59)];
        [_twoButton setBackgroundImage:XWImageName(@"add_z") forState:UIControlStateNormal];
        _twoButton.hidden = YES;
    }
    return _twoButton;
}

- (UIButton *)threeButton
{
    if(!_threeButton){
        _threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_threeButton xwDrawCornerWithRadiuce:XW(59)];
        [_threeButton setBackgroundImage:XWImageName(@"add_z") forState:UIControlStateNormal];
        _threeButton.hidden = YES;
    }
    return _threeButton;
}

- (UIButton *)fourButton
{
    if(!_fourButton){
        _fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fourButton xwDrawCornerWithRadiuce:XW(59)];
        [_fourButton setBackgroundImage:XWImageName(@"add_z") forState:UIControlStateNormal];
        _fourButton.hidden = YES;
    }
    return _fourButton;
}

- (VESTMsgSendView *)sendView
{
    if(!_sendView){
        _sendView = [[VESTMsgSendView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40-20-kSafeAreaBottomHeight, kSCREEN_WIDTH, (XW(40)+20+kSafeAreaBottomHeight))];
        kXWWeakSelf(weakself);
        _sendView.SendBlock = ^(NSString * _Nonnull msg) {
            NSLog(@"%@",msg);
            if(msg.length > 0){
                VESTMessageModel *model = [VESTMessageModel createMsgWithUser:nil direction:YES text:msg];
                [weakself.messageArray addObject:model];
                weakself.messageview.messageArray = weakself.messageArray;
            }
        };
    }
    return _sendView;
}

- (VESTMessageView *)messageview
{
    if(!_messageview){
        _messageview = [[VESTMessageView alloc]init];
        _messageview.messageArray = self.messageArray;
    }
    return _messageview;
}

- (NSMutableArray<VESTMessageModel *> *)messageArray
{
    if(!_messageArray){
        _messageArray = [NSMutableArray array];
//        VESTMessageModel *model1 = [VESTMessageModel createMsgWithUser:nil direction:NO text:@"Hi,how are you"];
//        VESTMessageModel *model2 = [VESTMessageModel createMsgWithUser:nil direction:NO text:@"Hi,how are you,What are you doing?"];
//        VESTMessageModel *model3 = [VESTMessageModel createMsgWithUser:nil direction:NO text:@"It's a nice day"];
//        [_messageArray addObject:model1];
//        [_messageArray addObject:model2];
//        [_messageArray addObject:model3];
    }
    return _messageArray;
}

- (void)setUserModel:(VESTUserModel *)userModel
{
    _userModel = userModel;
    [self.hostButton setBackgroundImage:XWImageName(userModel.headUrl) forState:UIControlStateNormal];
    [self.oneButton setBackgroundImage:[VESTUserTool GetHeadImageFromLocal] forState:UIControlStateNormal];
}

- (UIButton *)jubaoButton
{
    if(!_jubaoButton){
        _jubaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jubaoButton setImage:XWImageName(@"jubao") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_jubaoButton setAction:^{
            [LSChooseAlertView showWithTileArray:@[@"Report",@"Block User",] select:^(NSString * _Nonnull title) {
                if([title isEqualToString:@"Report"]){
                    [weakself reportUser];
                } if([title isEqualToString:@"Block User"]){
                    [weakself blockUser];
                }else{
                    
                }
            }];
        }];
    }
    return _jubaoButton;
}


- (void)reportUser
{
    [LSChooseAlertView showWithTileArray:@[@"Makes me unconfortable",@"Inappropriate content",@"Pron or stolen photo",@"Spam or scarm",] select:^(NSString * _Nonnull title) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AlertView toast:@"Report success" inView:self.view];
        });
    }];
}

- (void)blockUser
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Are you sure you want to block the user" message:@"" preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//           [self postBlockUser];
           [AlertView toast:@"Block success" inView:self.view];
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
@end
