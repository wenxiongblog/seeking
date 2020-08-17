//
//  LSPhotoEditView.m
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPhotoEditView.h"
#import "XWChooseImageButton.h"
#import "XQSImgUploadTool.h"

@interface LSPhotoEditView()
@property (nonatomic,assign,readwrite) BOOL isEdit;
@property (nonatomic,weak) UIViewController *eventVC;

@property (nonatomic,strong) XWChooseImageButton *headButton;
@property (nonatomic,strong) XWChooseImageButton *button2;
@property (nonatomic,strong) XWChooseImageButton *button3;
@property (nonatomic,strong) XWChooseImageButton *button4;
@property (nonatomic,strong) XWChooseImageButton *button5;
@property (nonatomic,strong) XWChooseImageButton *button6;
@property (nonatomic,strong) NSArray *buttonArray;
@end

@implementation LSPhotoEditView

- (instancetype)initWithFrame:(CGRect)frame eventVC:(UIViewController *)eventVC
{
    self = [super initWithFrame:frame];
    if(self){
        self.eventVC = eventVC;
        [self SEEKING_baseUIConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    CGFloat bigWidth = (kSCREEN_WIDTH-28*2)/3*2+12;
    CGFloat smallWidth = (kSCREEN_WIDTH-28*2)/3;
    //头像照片
    self.headButton = [self buttonWithIndex:1 frame:CGRectMake(16, 0, bigWidth, bigWidth)];
    self.headButton.allowsEditing = YES;
    self.headButton.isMustface = YES;
    
    //相册
    self.button2 = [self buttonWithIndex:2 frame:CGRectMake(bigWidth+12+16, 0, smallWidth, smallWidth)];
    self.button3 = [self buttonWithIndex:3 frame:CGRectMake(bigWidth+12+16, smallWidth+12, smallWidth, smallWidth)];
    self.button4 = [self buttonWithIndex:4 frame:CGRectMake(16, bigWidth+12, smallWidth, smallWidth)];
    self.button5 = [self buttonWithIndex:5 frame:CGRectMake(16+smallWidth+12, bigWidth+12, smallWidth, smallWidth)];
    self.button6 = [self buttonWithIndex:6 frame:CGRectMake(16+smallWidth*2 +12*2 , bigWidth+12, smallWidth, smallWidth)];
    
    
    [self addSubview:self.headButton];
    [self addSubview:self.button2];
    [self addSubview:self.button3];
    [self addSubview:self.button4];
    [self addSubview:self.button5];
    [self addSubview:self.button6];
    //加进去buttonArry
    self.buttonArray = @[self.button2,self.button3,self.button4,self.button5,self.button6];
}

#pragma mar - private
- (XWChooseImageButton *)buttonWithIndex:(NSInteger)index frame:(CGRect)frame
{
    kXWWeakSelf(weakself);
    XWChooseImageButton *button = [[XWChooseImageButton alloc]initWithFrame:frame eventViewController:self.eventVC];
    button.backgroundColor = [UIColor projectBlueColor];
    [button xwDrawCornerWithRadiuce:8];
    if(index == 1){
        //头像按钮
        button.isNeedUpload = YES;
        button.isMustface = YES;
        button.uploadingImageBlock = ^(UIImage *image, NSString *imgURL) {
            weakself.isEdit = YES;
            weakself.headImagesURL = imgURL;
        };
    }else{
        //不是头像 从2开始  2-0 3-1
        button.isNeedUpload = YES;
        button.isMustface = YES;
        button.uploadingImageBlock = ^(UIImage *image, NSString *imgURL) {
            weakself.isEdit = YES;
            if(weakself.imageUrlArray.count<index-1){
                //添加
                [weakself.imageUrlArray addObject:imgURL];
            }else{
                //更换
                [weakself.imageUrlArray replaceObjectAtIndex:index-2 withObject:imgURL];
            }
        };
    }
    
    
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8C8C8C"] font:Font(15) aliment:NSTextAlignmentCenter];
    label.text = [NSString stringWithFormat:@"%ld",(long)index];
    label.backgroundColor = [UIColor whiteColor];
    [label xwDrawCornerWithRadiuce:12.5];
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.right.equalTo(button).offset(-5);
        make.bottom.equalTo(button).offset(-5);
    }];
    
    return button;
}


#pragma mark - setter & getter1

- (void)setHeadImagesURL:(NSString *)headImagesURL
{
    _headImagesURL = headImagesURL;
    [self.headButton sd_setImageWithURL:[NSURL URLWithString:headImagesURL] forState:UIControlStateNormal];
}

- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    for(int i = 0; i < imageUrlArray.count; i++){
        if(i<self.buttonArray.count){
            XWChooseImageButton *button = [self.buttonArray objectAtIndex:i];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrlArray[i]] forState:UIControlStateNormal];
        }
    }
}

@end
