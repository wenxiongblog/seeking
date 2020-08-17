//
//  LSMineFeatureVC.m
//  Project
//
//  Created by XuWen on 2020/6/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineFeatureVC.h"
#import "LSVIPAlertView.h"

@interface LSMineFeatureVC ()
@property (nonatomic,strong) UIButton *updateButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation LSMineFeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self speciceNavWithTitle:kLanguage(@"My features")];
    [self SEEKING_baseUIConfig];
    [self baseConstaintsConfig];
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self.view addSubview:self.updateButton];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.contentImageView];
}

- (void)baseConstaintsConfig
{
    if(!kUser.isVIP){
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(28);
            make.right.equalTo(self.view).offset(-28);
            make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
            make.height.equalTo(@50);
        }];
    }else{
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(28);
            make.right.equalTo(self.view).offset(-28);
            make.bottom.equalTo(self.view).offset(50);
            make.height.equalTo(@50);
        }];
    }
    

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.updateButton.mas_top).offset(-30);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView).offset(0);
        make.right.equalTo(self.scrollView).offset(0);
    }];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    //  make.height.equalTo(@2000);
    }];
    
}


#pragma mark - setter & getter1
- (UIButton *)updateButton
{
    if(!_updateButton){
        _updateButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Update") font:Font(17) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_updateButton xwDrawCornerWithRadiuce:5];
        [_updateButton setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_updateButton setAction:^{
            if(!kUser.isVIP){
                  [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_Feature];
              }
        }];
    }
    return _updateButton;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UIImageView *)contentImageView
{
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc]init];
        //图片不能过长
        _contentImageView.image = kUser.isVIP? XWImageName(kLanguage(@"Mine_feature_Vip")):XWImageName(kLanguage(@"Mine_feature_notVip"));
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

@end
