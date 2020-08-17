//
//  XXLogView.h
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXLogModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XXLogStyle) {
    XXLogStyleCircle,  //圆形悬浮统计
    XXLogStyleSquare   //矩形详细日志
};

@interface XXLogView : UIView

// 日志控件展示样式
@property (nonatomic, assign) XXLogStyle logStyle;
// 当模式为XXLogModelCircle时，是否可以拖拽，默认为YES
@property (nonatomic, assign) BOOL enabelDrag;

// 添加日志
- (void)addLog:(XXLogModel *)log;
// 清空日志
- (void)clear;

@end

NS_ASSUME_NONNULL_END
