//
//  XWChooseImageButton.h
//  Project
//
//  Created by xuwen on 2018/7/31.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseImageBlock)(UIImage *image);
typedef void(^UploadingImageBlock)(UIImage *image,NSString *imgURL);
@interface XWChooseImageButton : UIButton
//是否选择了图片
@property (nonatomic,assign,readonly) BOOL isChooseImage;
//ViewController
@property (nonatomic,strong) UIViewController *eventVC;
//选择后的照片
@property (nonatomic,copy) ChooseImageBlock chooseImageBlock;
//上传后的照片和地址
@property (nonatomic,copy) UploadingImageBlock uploadingImageBlock;
//选择照片后是否直接上传？
@property (nonatomic,assign) BOOL isNeedUpload;
//照片是否需要裁减？
@property (nonatomic,assign) BOOL allowsEditing;
//照片是必须必须要头像
@property (nonatomic,assign) BOOL isMustface;
//init
- (instancetype)initWithFrame:(CGRect)frame eventViewController:(UIViewController *)eventVC;
@end


@interface UPloadImageProgressView : UIView

@property (nonatomic,assign) CGFloat progress;

@end
