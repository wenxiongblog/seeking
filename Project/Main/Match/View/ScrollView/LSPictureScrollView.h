//
//  LSPictureScrollView.h
//  Project
//
//  Created by XuWen on 2020/5/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSPictureScrollView : UIView
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,assign) BOOL scrollEnable;
//滚动到某一页
- (void)scrollToPage:(NSInteger)page;
@property (nonatomic,copy) void(^ScrollToPageBlock)(NSInteger page);
@end

NS_ASSUME_NONNULL_END
