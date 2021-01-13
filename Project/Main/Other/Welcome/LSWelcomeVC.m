//
//  LSWelcomeVC.m
//  Project
//
//  Created by XuWen on 2020/1/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSWelcomeVC.h"
#import "VESTTabBarVC.h"

@interface LSWelcomeVC ()
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int countDown;
@end

@implementation LSWelcomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.countDown = 3;
    //背景
    self.bgImageView.image = nil;
    self.bgImageView.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"vest_logo")];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.top.equalTo(self.view).offset(90);
        make.centerX.equalTo(self.view);
    }];
    //按钮
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@93);
        make.height.equalTo(@36);
        make.top.equalTo(self.view).offset(kTabbarHeight+10);
        make.right.equalTo(self.view).offset(-21);
    }];
    
    //开始倒数计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
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
    [self.button setTitle:[NSString stringWithFormat:@"%d",self.countDown] forState:UIControlStateNormal];
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton creatCommonButtonConfigWithTitle:@"3" font:Font(16) titleColor:[UIColor whiteColor] aliment:0];
        _button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
        [_button xwDrawCornerWithRadiuce:8];
//        kXWWeakSelf(weakself);
//        [_button setAction:^{
//            [weakself jump];
//        }];
    }
    return _button;
}

- (void)jump{
    //判断马甲包是否登录
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"kVestIsLogin"]){
        [VESTTabBarVC jumpVESTTabVC];
    }else{
        [JumpUtils jumpVestLoginModel];
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

@end
