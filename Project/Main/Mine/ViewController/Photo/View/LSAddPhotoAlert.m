//
//  LSAddPhotoAlert.m
//  Project
//
//  Created by XuWen on 2020/5/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSAddPhotoAlert.h"

@interface LSAddPhotoAlert()
@property (nonatomic,strong) UIImageView *cameraImageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *button;
@end

@implementation LSAddPhotoAlert

- (void)MDUploadOK{}
- (void)MDUploadFaild{}
- (void)MDUPloadEnter{}

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        [self MDUPloadEnter];
    }
    return self;
}

#pragma mark - public

#pragma mark - private

#pragma mark - event


#pragma mark - baseConfig1

- (void)SEEKING_baseUIConfig
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.placeView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self addSubview:self.placeView];
    
    [self.placeView addSubview:self.cameraImageView];
    [self.placeView addSubview:self.label];
    [self.placeView addSubview:self.button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [self.placeView addGestureRecognizer:tap];
}

- (void)tapClicked
{
    [self MDUploadFaild];
    [self disappearAnimation];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.label.mas_top).offset(-30);
        make.width.equalTo(@(137));
        make.height.equalTo(@(95));
        make.centerX.equalTo(self.placeView);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.placeView);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(231));
        make.height.equalTo(@48);
         make.centerX.equalTo(self.placeView);
        make.top.equalTo(self.label.mas_bottom).offset(50);
    }];
}

#pragma mark - setter & getter1
- (UIImageView *)cameraImageView
{
    if(!_cameraImageView){
        _cameraImageView = [[UIImageView alloc]initWithImage:XWImageName(@"Mine_camera")];
    }
    return _cameraImageView;
}

- (UILabel *)label
{
    if(!_label){
        _label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(24) aliment:NSTextAlignmentCenter];
        _label.text = @"Upload photos \nto view more users";
        _label.numberOfLines = 2;
    }
    return _label;
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton creatCommonButtonConfigWithTitle:@"Add photos" font:Font(18) titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_button xwDrawCornerWithRadiuce:24];
        _button.backgroundColor = [UIColor whiteColor];
        kXWWeakSelf(weakself);
        [_button setAction:^{
            [weakself disappearAnimation];
            if(weakself.ChoosePhotoBlock){
                [weakself MDUploadOK];
                weakself.ChoosePhotoBlock(YES);
            }
        }];
    }
    return _button;
}
@end
