//
//  DYLaunchVC.m
//  DeYang
//
//  Created by XuWen on 2020/8/25.
//  Copyright © 2020 xuwen. All rights reserved.
//
    
#import "DYLaunchVC.h"
#import "VESTTabBarVC.h"
#import "HPTabBarController.h"

@interface DYLaunchVC ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int countDown;
@end

@implementation DYLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countDown = 5;
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.button];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@93);
        make.height.equalTo(@36);
        make.top.equalTo(self.view).offset(kStatusHeight+10);
        make.right.equalTo(self.view).offset(-21);
    }];
    
    //开始倒数计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [11]    (null)    @"iconUrl" : @"https://www.dysmt.cn/res/static/u/cms/dyzw/202012/04235733l22k.jpg"
    //请求一下启动页数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"2702" forKey:@"channelIds"];
    [self post:kURL_QiDong params:params success:^(Response * _Nonnull response) {
        if([response.code isEqualToString:@"0"]){
            NSArray *array = response.data;
            NSDictionary *dict = array.firstObject;
            NSString *iconURL = dict[@"iconUrl"];
            if(iconURL){
                [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] completed:nil];
            }
            
        }else{
            
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

- (void)dealloc {
    [self.timer invalidate];
    NSLog(@"%s", __func__);
}

- (void)handleTimer
{
    self.countDown--;
    
    if(self.countDown <=0){
        [self jump];
    }
    [self.button setTitle:[NSString stringWithFormat:@"跳过(%d)",self.countDown] forState:UIControlStateNormal];
}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"1242_2208.jpg")];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton creatCommonButtonConfigWithTitle:@"跳过(5)" font:Font(16) titleColor:[UIColor whiteColor] aliment:0];
        _button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
        [_button xwDrawCornerWithRadiuce:8];
        kXWWeakSelf(weakself);
        [_button setAction:^{
            [weakself jump];
        }];
    }
    return _button;
}

- (void)jump{
    
    UIViewController *vc = nil;
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"JumpOlder"];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"JumpOlder"]){
        vc = [[HPTabBarController alloc]init];
    }else{
        vc = [[VESTTabBarVC alloc]init];
    }
    CATransition *transtition = [CATransition animation];
    transtition.duration = 0.1;
    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];

    [self.timer invalidate];
    self.timer = nil;
}

@end
