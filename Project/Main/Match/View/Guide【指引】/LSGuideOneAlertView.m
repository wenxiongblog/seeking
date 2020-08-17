//
//  LSGuideOneAlertView.m
//  Project
//
//  Created by XuWen on 2020/4/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSGuideOneAlertView.h"

@interface LSGuideOneAlertView()
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UIButton *clearButton;
@end

@implementation LSGuideOneAlertView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        
        [self baseConstrainsConfig];
    }
    return self;
}


#pragma mark - baseConfig1

- (void)SEEKING_baseUIConfig
{
    self.placeView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    self.leftImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"match_guide_left"))];
    self.rightImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"match_guide_right"))];
    self.clearButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Clear!") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
    [self.clearButton xwDrawBorderWithColor:[UIColor whiteColor] radiuce:6 width:2];
    [self.placeView addSubview:self.leftImageView];
    [self.placeView addSubview:self.rightImageView];
    [self.placeView addSubview:self.clearButton];
    
    kXWWeakSelf(weakself);
    [self.clearButton setAction:^{
        [weakself disappearAnimation];
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@150);
        make.centerX.equalTo(self.placeView);
        make.bottom.equalTo(self.placeView.mas_centerY).offset(-130);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@150);
        make.centerX.equalTo(self.placeView);
        make.top.equalTo(self.leftImageView.mas_bottom).offset(100);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@205);
        make.centerX.equalTo(self.placeView);
        make.top.equalTo(self.rightImageView.mas_bottom).offset(40);
    }];
}

- (void)baseConstrainsConfig
{
    
}


#pragma mark - setter & getter1
@end
