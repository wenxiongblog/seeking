//
//  LSUploadView.m
//  Project
//
//  Created by XuWen on 2020/5/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSUploadView.h"
#import "XWChooseImageButton.h"
#import "LSDetactFace.h"
#import "XQSImgUploadTool.h"

@interface LSUploadView()

@property (nonatomic,strong) UIViewController *vc;

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) XWChooseImageButton *chooseButton;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIImageView *bottomImageView;

@property (nonatomic,strong,readwrite) NSString *urlString;
@end

@implementation LSUploadView

- (instancetype)initWithEventVC:(UIViewController *)vc
{
    self = [super init];
    if(self){
        self.vc = vc;
        [self SEEKING_baseUIConfig];
        [self baseConstriaintsConfig];
    }
    return self;
}



#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self xwDrawCornerWithRadiuce:5];
    [self addSubview:self.bgImageView];
    [self addSubview:self.chooseButton];
    [self addSubview:self.bottomImageView];
    [self addSubview:self.progressView];
}

- (void)baseConstriaintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@30);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomImageView);
    }];
}


#pragma mark - setter & getter1

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"photo_upload")];
        _bgImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bgImageView;
}

- (XWChooseImageButton *)chooseButton
{
    if(!_chooseButton){
        _chooseButton = [[XWChooseImageButton alloc]initWithFrame:CGRectZero eventViewController:self.vc];
        kXWWeak(_chooseButton, weakbutton);
        _chooseButton.contentMode = UIViewContentModeScaleAspectFill;
        kXWWeakSelf(weakself);
        _chooseButton.chooseImageBlock = ^(UIImage *image) {
            weakself.urlString = nil;
            [weakbutton setBackgroundImage:image forState:UIControlStateNormal];
            //检测是否有人脸
            [LSDetactFace detactImage:image haveFace:^(NSInteger faceCount) {
                if(faceCount == 0){
                    //没有人脸
                    weakself.bottomImageView.image = XWImageName(@"photo_cha");
                }else{
                    //有人脸，开始上传
                    weakself.progressView.hidden = NO;
                    [XQSImgUploadTool uploadPhotoAsync:image progress:^(float progress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakself.progressView.progress = progress;
                        });
                        
                    } resultBlock:^(BOOL isOK, NSString * _Nonnull url) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           weakself.progressView.hidden = YES;
                              if(isOK){
                                  weakself.bottomImageView.image = XWImageName(@"photo_ok");
                                  weakself.urlString = url;
                              }else{
                                  weakself.bottomImageView.image = XWImageName(@"photo_cha");
                              }
                        });
                       
                    }];
                }
            }];
        };
    }
    return _chooseButton;
}

- (UIProgressView *)progressView
{
    if(!_progressView){
        _progressView = [[UIProgressView alloc]init];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIImageView *)bottomImageView
{
    if(!_bottomImageView){
        _bottomImageView = [[UIImageView alloc]initWithImage:XWImageName(@"")];
    }
    return _bottomImageView;
}
@end
