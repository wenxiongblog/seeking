//
//  VESTTwoLiveVC.m
//  Project
//  
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//
    
#import "VESTTwoLiveVC.h"
#import "VESTMsgSendView.h"
#import "VESTMessageView.h"
#import <AVKit/AVKit.h>
                                            
@interface VESTTwoLiveVC ()
@property (nonatomic,strong)VESTMsgSendView *sendView;
@property (nonatomic,strong)VESTMessageView *messageview;

@property (nonatomic,strong) NSMutableArray<VESTMessageModel *>  *messageArray;

@property (nonatomic,strong) AVPlayer* player;

@property (nonatomic,strong) UIButton *jubaoButton;

@end

@implementation VESTTwoLiveVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    
    [self.player play];
    //添加通知循环播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)moviePlayDidEnd:(NSNotification *)notification
{
    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}

#pragma mark - public
/*
#pragma mark - private
- (void)addPlaterWithURL:(NSURL *)url
{
    [self.player setUrl:url];
    [self.player setShouldAutoplay:YES];
    [self.player setBufferSizeMax:2];
    [self.player setShouldLoop:NO];
    [self.player prepareToPlay];
    [self.whiteView addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kSCREEN_WIDTH));
        make.height.equalTo(@(kSCREEN_WIDTH/108*192));
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.view).offset(10);
    }];
}

- (void)removePlayer{
    [self.player reset:NO];
    [self.player stop];
    [self.player.view removeFromSuperview];
    self.player = nil;
}
 */
#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    self.backButton.hidden = NO;
    [self.backButton setImage:XWImageName(@"vest_back") forState:UIControlStateNormal];
    [self.view addSubview:self.jubaoButton];
    [self.jubaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.backButton);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.view addSubview:self.sendView];
       [self.view addSubview:self.messageview];
}

- (void)baseConstraintsConfig
{
    [self.messageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sendView.mas_top).offset(-20);
        make.height.equalTo(@300);
    }];
}

#pragma mark - setter & getter
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

- (AVPlayer *)player
{
    if(!_player){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"neiron.mp4" ofType:@""];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem*videoItem = [[AVPlayerItem alloc] initWithURL:url];
        _player =  [AVPlayer playerWithPlayerItem:videoItem];
        _player.volume =10;
        
        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.backgroundColor = [UIColor whiteColor].CGColor;
        playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
        playerLayer.frame = self.view.bounds;
        [self.bgImageView.layer insertSublayer:playerLayer atIndex:0];
        
        
    }
    return _player;
}

- (UIButton *)jubaoButton
{
    if(!_jubaoButton){
        _jubaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jubaoButton setImage:XWImageName(@"jubao") forState:UIControlStateNormal];
    }
    return _jubaoButton;
}

@end
