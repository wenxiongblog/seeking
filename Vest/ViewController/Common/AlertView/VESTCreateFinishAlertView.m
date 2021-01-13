//
//  VESTCreateFinishAlertView.m
//  Project
//
//  Created by XuWen on 2020/9/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTCreateFinishAlertView.h"
@interface VESTCreateFinishAlertView()
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UIButton *createButton;
@property (nonatomic,strong) UILabel *titleLabel;
@end


@implementation VESTCreateFinishAlertView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

#pragma mark - public
#pragma mark - private
#pragma mark - event
#pragma mark - baseConfig
- (void)baseUIConfig
{
   self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.placeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.createButton];
}
- (void)baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@(280));
        make.center.equalTo(self.placeView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.createButton.mas_top).offset(-50);
        make.left.right.equalTo(self.createButton);
    }];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-35);
    }];
}

#pragma mark - setter & getter
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:5];
    }
    return _contentView;
}

- (UIButton *)createButton
{
    if(!_createButton){
        _createButton = [UIButton creatCommonButtonConfigWithTitle:@"CONTINUE" font:Font(16) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_createButton setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateNormal];
        [_createButton xwDrawCornerWithRadiuce:21];
        kXWWeakSelf(weakself);
        [_createButton setAction:^{
            [weakself disappearAnimation];
        }];
    }
    return _createButton;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:Font(18) aliment:NSTextAlignmentCenter];
        _titleLabel.text = @"Your request has been received. It will be processed within 24 hours. Your room will be displayed when processed.";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


@end
