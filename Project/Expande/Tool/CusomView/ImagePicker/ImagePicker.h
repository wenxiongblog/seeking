//
//  ImagePickerUtils.h
//  SCGOV
//
//  Created by solehe on 2019/5/30.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePicker : NSObject

@property (assign, nonatomic) BOOL showTakePhotoBtnSwitch;  ///< 允许拍照
@property (assign, nonatomic) BOOL showTakeVideoBtnSwitch;  ///< 允许拍视频
@property (assign, nonatomic) BOOL sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (assign, nonatomic) BOOL allowPickingVideoSwitch; ///< 允许选择视频
@property (assign, nonatomic) BOOL allowPickingImageSwitch; ///< 允许选择图片
@property (assign, nonatomic) BOOL allowPickingGifSwitch;
@property (assign, nonatomic) BOOL allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (assign, nonatomic) BOOL showSheetSwitch; ///< 显示一个sheet,把拍照/拍视频按钮放在外面
@property (assign, nonatomic) NSUInteger maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic) NSUInteger columnNumberTF;
@property (assign, nonatomic) BOOL allowCropSwitch;
@property (assign, nonatomic) BOOL needCircleCropSwitch;
@property (assign, nonatomic) BOOL allowPickingMuitlpleVideoSwitch;
@property (assign, nonatomic) BOOL showSelectedIndexSwitch;
@property (nonatomic, copy) void(^completeBlock)(NSArray<UIImage *> *images);

/**
 展示选择提示框
 */
- (void)showPickerView:(NSString *)title vc:(UIViewController *)vc complete:(void(^)(NSArray<UIImage *> *images))block;

@end

NS_ASSUME_NONNULL_END
