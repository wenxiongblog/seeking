//
//  LSPhotoEditView.h
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSPhotoEditView : UIView
- (instancetype)initWithFrame:(CGRect)frame eventVC:(UIViewController *)eventVC;
//是否进行过更改
@property (nonatomic,assign,readonly) BOOL isEdit;
//头像图片
@property (nonatomic,strong) NSString *headImagesURL;
//图片数组
@property (nonatomic,strong) NSMutableArray *imageUrlArray;
@end

NS_ASSUME_NONNULL_END
