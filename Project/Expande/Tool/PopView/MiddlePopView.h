//
//  MiddlePopView.h
//  SCGov
//
//  Created by solehe on 2019/7/25.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiddlePopView : UIView

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

- (void)showInView:(UIView *)superView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
