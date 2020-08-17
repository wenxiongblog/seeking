//
//  XXLogCircleView.h
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXLogCircleView;

@protocol XXLogCircleViewDelegate <NSObject>

- (void)logCircleViewDidClose:(XXLogCircleView *)circleView;

@end

// 圆形悬浮框
@interface XXLogCircleView : UIView

@property (nonatomic, weak) id<XXLogCircleViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
