//
//  LSSignUpHeadVC.m
//  Project
//
//  Created by XuWen on 2020/2/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpHeadVC.h"
#import "XWChooseImageButton.h"
#import "XQSImgUploadTool.h"
#import "LSDetactFace.h"
#import "LSSignUpLocationVC.h"
#import "LSSignUpNotifyVC.h"

@interface LSSignUpHeadVC ()
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) XWChooseImageButton *photoButton;
//图片路径保存
@property (nonatomic,strong) UIImage *image;
@end

@implementation LSSignUpHeadVC
#pragma mark - 头像
- (void)MDChooseHeadImage06{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    self.titleLabel.text = kLanguage(@"Picture time!\nChoose your photo");
    self.titleLabel.font = FontBold(24);
    self.titleLabel.numberOfLines = 2;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.nextButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(XW(370)));
        make.width.equalTo(@(XW(300)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@(XW(300)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.photoButton.mas_bottom).offset(50);
    }];
}


#pragma mark - setter & getter1
- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"UPLOAD PHOTO") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg_no") forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        [button setAction:^{
            [weakself uploadImage:weakself.image];
        }];
        _nextButton = button;
    }
    return _nextButton;
}

- (XWChooseImageButton *)photoButton
{
    if(!_photoButton){
        _photoButton = [[XWChooseImageButton alloc]initWithFrame:CGRectZero eventViewController:self];
        _photoButton.allowsEditing = YES;
        _photoButton.isNeedUpload = NO;
//        _photoButton.isMustface = YES;  //必须要有头像
        _photoButton.backgroundColor = [UIColor xwColorWithHexString:@"#1F304F"];
        [_photoButton xwDrawBorderWithColor:[UIColor themeColor] radiuce:10 width:1];
        [_photoButton setImage:XWImageName(kLanguage(@"login_addPhoto")) forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        _photoButton.chooseImageBlock = ^(UIImage *image) {
            if(image != nil){
                //进行人脸检测
                [LSDetactFace detactImage:image haveFace:^(NSInteger faceCount) {
                    if(faceCount == 0){
                        //没有检测到人脸
                        [weakself.photoButton setImage:image forState:UIControlStateNormal];
                        weakself.photoButton.selected = NO;
                        weakself.nextButton.userInteractionEnabled = NO;
                        weakself.nextButton.selected = NO;
                        weakself.titleLabel.text = @"Unable to recognize your face";
                        [weakself.titleLabel commonLabelConfigWithTextColor:[UIColor themeColor] font:Font(18) aliment:NSTextAlignmentCenter];
                    }else{
                        weakself.image = image;
                        [weakself.photoButton setImage:image forState:UIControlStateNormal];
                        weakself.photoButton.selected = YES;
                        weakself.nextButton.userInteractionEnabled = YES;
                        weakself.nextButton.selected = YES;
                        weakself.titleLabel.text = kLanguage(@"Good! Nice photo");
                        [weakself.titleLabel commonLabelConfigWithTextColor:[UIColor themeColor] font:Font(24) aliment:NSTextAlignmentCenter];
                    }
                }];
            }
        };
    }
    return _photoButton;
}

- (void)uploadImage:(UIImage *)image
{
    [AlertView showLoading:kLanguage(@"Uploading") inView:self.view];
    kXWWeakSelf(weakself);
    [XQSImgUploadTool uploadPhotoAsync:image progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } resultBlock:^(BOOL isOK, NSString * _Nonnull url) {
        [AlertView hiddenLoadingInView:self.view];
        if(isOK){
            //上传完成 这里判断是 更新头像 还是 更新相册
            if(weakself.isReUpload){
                NSArray *imageArray = nil;
                if(kUser.imageslist.length > 10){
                    [kUser.imageslist componentsSeparatedByString:@","];
                }
                NSString *str = imageArray.firstObject;
                if(str.length == 0){
                    imageArray = [NSArray array];
                }
                NSMutableArray *array = [NSMutableArray arrayWithArray:imageArray];
                [array addObject:url];
                
                NSMutableString *string = [NSMutableString string];
                for(int i = 0;i<array.count;i++){
                    NSString *str = array[i];
                    if(i!=0){
                       [string appendString:@","];
                    }
                    [string appendString:str];
                }
                kUser.imageslist = string;
                [weakself uploadPhotoSuccess];
                
            }else{
                kUser.images = url;
                [self MDChooseHeadImage06];
                [weakself uploadSuccess];
            }
        }else{
            //上传失败
            [AlertView toast:@"Upload failed!" inView:self.view];
            [self.photoButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }];
}

- (void)uploadSuccess
{
    [self updateUserInfo:^(BOOL finished) {
        if(finished){
            if(![kUser.address isEqualToString:@"Secrete"] || ![kUser.address isEqualToString:@"保密"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:@{@"key":@"1"}];
            }else{
                LSSignUpNotifyVC *vc = [[LSSignUpNotifyVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (void)uploadPhotoSuccess
{
    kXWWeakSelf(weakself);
    [self updateUserInfo:^(BOOL finished) {
        if(finished){
            [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
            NSArray *array = nil;
            if(kUser.imageslist.length > 10){
                array = [kUser.imageslist componentsSeparatedByString:@","];
            }
            
            if(array.count >= 2){
                [[NSNotificationCenter defaultCenter]postNotificationName:kNOtification_ImageGreateThan3 object:nil];
            }
        }
    }];
}

@end
