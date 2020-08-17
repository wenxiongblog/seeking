//
//  LSPictureView.m
//  Project
//
//  Created by XuWen on 2020/5/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPictureView.h"
#import "LSUploadPhotoVC.h"

@interface LSPictureView ()
@property (nonatomic,strong) UIView *uploadView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation LSPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadImagemorethan3) name:kNOtification_ImageGreateThan3 object:nil];
    }
    return self;
}

- (void)uploadImagemorethan3
{
    self.uploadView.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.userInteractionEnabled = YES;
    [self addSubview:self.uploadView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - setter & getter1
- (UIView *)uploadView
{
    if(!_uploadView){
        _uploadView = [[UIView alloc]init];
        _uploadView.hidden = YES;
        _uploadView.backgroundColor = [UIColor clearColor];
        //模糊层
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [_uploadView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.uploadView);
        }];
        
        self.button = [UIButton creatCommonButtonConfigWithTitle:@"Add photos" font:FontMediun(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        self.button.backgroundColor = [UIColor themeColor];
        [self.button xwDrawCornerWithRadiuce:5];
        [_uploadView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@246);
            make.height.equalTo(@52);
            make.centerX.equalTo(self.uploadView);
            make.top.equalTo(self.uploadView.mas_centerY).offset(70);
        }];
        kXWWeakSelf(weakself);
        [self.button setAction:^{
            
            NSArray *array = nil;
            if(kUser.imageslist.length > 10){
                [kUser.imageslist componentsSeparatedByString:@","];
            }
            if(array.count < 2){
                LSUploadPhotoVC *vc = [[LSUploadPhotoVC alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.modalPresentationStyle = 0;
                [[weakself getCurrentVC] presentViewController:nav animated:YES
                                     completion:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:kNOtification_ImageGreateThan3 object:nil];
            }
        }];
        //lable
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(24) aliment:NSTextAlignmentCenter];
        label.numberOfLines = 2;
        label.text = @"Upload at least 3 photos\nto see all pics";
        [_uploadView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.uploadView);
        }];
        
        //imageView
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"match_uplpad")];
        [_uploadView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@100);
            make.centerX.equalTo(self.uploadView);
            make.bottom.equalTo(label.mas_top).offset(-50);
        }];
    }
    return _uploadView;
}

- (void)setShowUpload:(BOOL)showUpload
{
    _showUpload = showUpload;
    self.uploadView.hidden = !showUpload;
}
@end
