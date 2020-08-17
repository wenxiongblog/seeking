//
//  LSDraggableCardView.h
//  Project
//
//  Created by XuWen on 2020/1/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "CCDraggableCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSDraggableCardView : CCDraggableCardView
@property (nonatomic,strong) SEEKING_Customer *customer;
@property (nonatomic,copy) void(^detailBlock)(SEEKING_Customer *customer);
- (void)likeButtonAlpha:(CGFloat)alpha;
@property (nonatomic,weak) UIViewController *eventVC;
@end

NS_ASSUME_NONNULL_END
