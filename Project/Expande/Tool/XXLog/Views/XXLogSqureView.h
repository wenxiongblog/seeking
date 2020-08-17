//
//  XXLogSqureView.h
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XXLogSqureView;

@protocol XXLogSqureViewDelegate <NSObject>

- (void)logSqureViewDidClose:(XXLogSqureView *)squreView;

@end

// 矩形日志框
@interface XXLogSqureView : UIView

@property (nonatomic, weak) id<XXLogSqureViewDelegate> delegate;

// 新增日志
- (void)addLog:(XXLogModel *)model;
// 清空日志
- (void)clear;

@end


@interface XXLogSqureDragView : UIView

@property (nonatomic, copy) void(^dragBlock)(CGPoint point);

- (BOOL)enableDrag;

@end


@interface XXLogSqureViewCell : UITableViewCell

// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 内容
@property (nonatomic, strong) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
