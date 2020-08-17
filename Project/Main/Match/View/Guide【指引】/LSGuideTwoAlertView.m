//
//  LSGuideTwoAlertView.m
//  Project
//
//  Created by XuWen on 2020/4/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSGuideTwoAlertView.h"

@interface LSGuideTwoAlertView ()
@property (nonatomic,strong) UIButton *clearButton;
@end

@implementation LSGuideTwoAlertView

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
    [self.placeView addSubview:self.clearButton];
    self.placeView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
}

- (void)baseConstrainsConfig
{
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@205);
        make.centerX.equalTo(self.placeView);
        make.bottom.equalTo(self.placeView).offset(-kTabbarHeight-60);
    }];
    
    UILabel* profileLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentCenter];
    profileLabel.text = @"OPEN PROFLE";
    [self.placeView addSubview:profileLabel];
    [profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.placeView);
        make.bottom.equalTo(self.clearButton.mas_top).offset(-47);
    }];
    
    UILabel *detailInfo = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
//    detailInfo.text = @"TAP USER INFO OR SWIPE UP TO";
    detailInfo.text = @"SWIPE UP TO";
    [self.placeView addSubview:detailInfo];
    [detailInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.placeView);
        make.bottom.equalTo(profileLabel.mas_top).offset(-20);
    }];
    
    //线条
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.placeView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.placeView);
        make.width.equalTo(@2);
        make.bottom.equalTo(self.placeView.mas_centerY);
        make.top.equalTo(self.placeView).offset(kStatusBarAndNavigationBarHeight+30);
    }];
    
    //左边点击
    
    UILabel* leftTapLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentCenter];
    leftTapLabel.numberOfLines = 2;
    leftTapLabel.text = @"PREVIOUS\nPHOTO";
    [self.placeView addSubview:leftTapLabel];
    [leftTapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.placeView.mas_centerY).offset(-40);
        make.left.equalTo(self.placeView);
        make.right.equalTo(self.placeView.mas_centerX);
    }];

    UILabel *leftTapInfo = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
    leftTapInfo.text = @"TAP HERE TO";
    [self.placeView addSubview:leftTapInfo];
    [leftTapInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.placeView);
        make.right.equalTo(self.placeView.mas_centerX);
        make.bottom.equalTo(leftTapLabel.mas_top).offset(-20);
    }];
    
    //右边点击
    
    UILabel* rightTapLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(30) aliment:NSTextAlignmentCenter];
    rightTapLabel.numberOfLines = 2;
    rightTapLabel.text = @"NEXT\nPHOTO";
    [self.placeView addSubview:rightTapLabel];
    [rightTapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.placeView.mas_centerY).offset(-40);
        make.right.equalTo(self.placeView);
        make.left.equalTo(self.placeView.mas_centerX);
    }];
    
    UILabel *rightTapInfo = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
    rightTapInfo.text = @"TAP HERE TO";
    [self.placeView addSubview:rightTapInfo];
    [rightTapInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.placeView);
        make.left.equalTo(self.placeView.mas_centerX);
        make.bottom.equalTo(rightTapLabel.mas_top).offset(-20);
    }];
}


#pragma mark - setter & getter1

- (UIButton *)clearButton
{
    if(!_clearButton){
        _clearButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Clear!") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_clearButton xwDrawBorderWithColor:[UIColor whiteColor] radiuce:6 width:2];
        kXWWeakSelf(weakself);
        [_clearButton setAction:^{
            [weakself disappearAnimation];
        }];
        
    }
    return _clearButton;
}
@end
