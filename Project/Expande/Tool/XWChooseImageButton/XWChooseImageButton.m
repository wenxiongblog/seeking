//
//  XWChooseImageButton.m
//  Project
//
//  Created by xuwen on 2018/7/31.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWChooseImageButton.h"
#import "LSDetactFace.h"
#import "XQSImgUploadTool.h"
#import "ImagePicker.h"

@interface XWChooseImageButton()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,assign,readwrite) BOOL isChooseImage;
@property (nonatomic,assign,readwrite) BOOL isEdit;

@property (nonatomic,strong) UPloadImageProgressView *progressView;
@property (nonatomic,strong) ImagePicker *imagePicker;

@end

@implementation XWChooseImageButton

- (instancetype)initWithFrame:(CGRect)frame eventViewController:(UIViewController *)eventVC
{
    self = [self initWithFrame:frame];
    if(self){
        self.eventVC = eventVC;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addTarget:self action:@selector(chooseMoreImages) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - 相册还是拍照
- (void)chooseMoreImages
{
    kXWWeakSelf(weakself);
    [self.imagePicker showPickerView:@"" vc:self.eventVC complete:^(NSArray<UIImage *> * _Nonnull images) {
        [weakself handleImage:images.firstObject];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self handleImage:image];
}

- (void)handleImage:(UIImage *)image
{
    kXWWeakSelf(weakself);
    if(self.isMustface){
        //检测是否有头像
        [LSDetactFace detactImage:image haveFace:^(NSInteger faceCount) {
            if(faceCount == 0){
                //没有检测到脸部
                [AlertView toast:@"The head image must have a clear face" inView:[self getCurrentVC].view];
                [weakself setBackgroundImage:nil forState:UIControlStateSelected];
                self.isChooseImage = NO;
                if(self.chooseImageBlock){
                    self.chooseImageBlock(nil);
                }
                
            }else{
                //检测到脸部
                [weakself setBackgroundImage:image forState:UIControlStateSelected];
                
                if(self.isNeedUpload){
                    //不需要头像，需要上传
                    [self uploadImage:image];
                }else{
                    //不要头像，不需要上传
                    self.isChooseImage = YES;
                    if(self.chooseImageBlock){
                        self.chooseImageBlock(image);
                    }
                }
            }
        }];
        
    }else{
        //不需要检测是否有头像
        if(self.isNeedUpload){
            //不需要头像，需要上传
            [self uploadImage:image];
        }else{
            //不要头像，不需要上传
            self.isChooseImage = YES;
            if(self.chooseImageBlock){
                self.chooseImageBlock(image);
            }
        }
        
    }
}

- (void)uploadImage:(UIImage *)image
{
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",kUser.id];
    NSDictionary *params = @{
        @"id":kUser.id,
        @"file": filename,
    };

    UploadFile *file = [[UploadFile alloc] init];
    [file setData:UIImageJPEGRepresentation(image, 0.75)];
    [file setName:[NSString stringWithFormat:@"%@.jpg",kUser.id]];
    [file setKey:@"file"];
    kXWWeakSelf(weakself);
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [XQSImgUploadTool uploadPhotoAsync:image progress:^(float progress) {
        NSLog(@"%.2f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
            self.progressView.hidden = progress == 1;
        });
    } resultBlock:^(BOOL isOK, NSString * _Nonnull url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isOK){
                self.progressView.hidden = YES;
                self.progressView = nil;
                
                //先sd一次
                [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:image];
                
                if(self.uploadingImageBlock){
                    self.uploadingImageBlock(image, url);
                }
            }else{
                //上传失败
                self.progressView = nil;
            }
        });
    }];
}


#pragma mark - setter & getter1
- (ImagePicker *)imagePicker
{
    if(!_imagePicker){
        _imagePicker = [[ImagePicker alloc]init];
        _imagePicker.showTakePhotoBtnSwitch = YES;
        _imagePicker.allowPickingImageSwitch = YES;
        _imagePicker.allowPickingOriginalPhotoSwitch = NO;
        _imagePicker.allowCropSwitch = YES;
        _imagePicker.maxCountTF = 1;
    }
    return _imagePicker;
}

- (UPloadImageProgressView *)progressView
{
    if(!_progressView){
        _progressView = [[UPloadImageProgressView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _progressView.hidden = YES;
    }
    return _progressView;
}

@end



@interface UPloadImageProgressView ()

@end

@implementation UPloadImageProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    }
    return self;
}


#pragma mark - baseConfig1



#pragma mark - setter & getter1
- (CAShapeLayer *)maskStyle2:(CGFloat)progress {
    
    CGFloat radius = self.width/2.0;

    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(self.width, self.height/2.0)];
    [path1 addLineToPoint:CGPointMake(self.width, self.height)];
    [path1 addLineToPoint:CGPointMake(0,self.height)];
    [path1 addLineToPoint:CGPointMake(0,0)];
    [path1 addLineToPoint:CGPointMake(self.width,0)];
    [path1 closePath];
    
    UIBezierPath *path0 = [UIBezierPath bezierPath];
    [path0 moveToPoint:self.center];
    [path0 addLineToPoint:CGPointMake(self.center.x+radius, self.center.y)];
    UIBezierPath *cycle = [UIBezierPath bezierPathWithArcCenter:self.center
                                                         radius:radius
                                                     startAngle:0.0
                                                       endAngle:M_PI*2*progress
                                                      clockwise:YES];
    [path0 appendPath:cycle];
    [path0 addLineToPoint:self.center];
    [path0 closePath];
    
    //
    [path1 appendPath:path0];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path1 CGPath];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.layer.mask = [self maskStyle2:progress];
}



@end
