//
//  LSThreeMsgVC.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSThreeMsgVC.h"
#import "VESTMsgSendView.h"
#import "VESTMessageView.h"
#import "VESTSaveMessageTool.h"

@interface LSThreeMsgVC ()
@property (nonatomic,strong)VESTMsgSendView *sendView;
@property (nonatomic,strong)VESTMessageView *messageview;
@property (nonatomic,strong) NSMutableArray<VESTMessageModel *>  *messageArray;
@end

@implementation LSThreeMsgVC


/**
 //nav 配置
 */
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.bgImageView.image = XWImageName(@"vest_signInBG");
    self.backButton.hidden = NO;
    [self.backButton setImage:XWImageName(@"vest_back") forState:UIControlStateNormal];
    self.titleString = @"Name";
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.font = FontBold(24);
    self.navTitleLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, kStatusBarHeight, 200, 44);
    [self.view addSubview:self.sendView];
    [self.view addSubview:self.messageview];
}

- (void)baseConstraintsConfig
{
    [self.messageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sendView.mas_top).offset(-20);
        make.top.equalTo(self.navBarView.mas_bottom).offset(20);
    }];
}

#pragma mark - setter & getter
- (VESTMsgSendView *)sendView
{
    if(!_sendView){
        _sendView = [[VESTMsgSendView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40-20-kSafeAreaBottomHeight, kSCREEN_WIDTH, (XW(40)+20+kSafeAreaBottomHeight))];
        _sendView.backgroundColor = [UIColor whiteColor];
        kXWWeakSelf(weakself);
        _sendView.SendBlock = ^(NSString * _Nonnull msg) {
            NSLog(@"%@",msg);
            if(msg.length > 0){
                VESTMessageModel *model = [VESTMessageModel createMsgWithUser:weakself.userModel direction:YES text:msg];
                [VESTSaveMessageTool saveMessage:model WithKey:weakself.userModel.name];
                weakself.messageview.messageArray = [NSMutableArray arrayWithArray:[VESTSaveMessageTool getMessageWithKey:weakself.userModel.name]];
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
    }
    return _messageArray;
}

- (void)setUserModel:(VESTUserModel *)userModel
{
    _userModel = userModel;
    self.messageArray = [NSMutableArray arrayWithArray:[VESTSaveMessageTool getMessageWithKey:userModel.name]];
    self.messageview.messageArray = self.messageArray;
}

@end
