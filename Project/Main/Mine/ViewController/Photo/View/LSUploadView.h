//
//  LSUploadView.h
//  Project
//
//  Created by XuWen on 2020/5/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSUploadView : UIView
- (instancetype)initWithEventVC:(UIViewController *)vc;
@property (nonatomic,strong,readonly) NSString *urlString;
@end

NS_ASSUME_NONNULL_END
