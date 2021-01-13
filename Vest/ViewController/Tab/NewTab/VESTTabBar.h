//
//  VESTTabBar.h
//  Project
//
//  Created by XuWen on 2020/9/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VESTTabBar;
@protocol VESTTabBarDelegate <NSObject>
@optional
- (void)tabBar:(VESTTabBar *)tabBar didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;
@end

@interface VESTTabBar : UIView
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger seletedIndex;
@property (nonatomic, weak) id<VESTTabBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
