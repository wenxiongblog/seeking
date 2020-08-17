//
//  LSMatchMsgCell.h
//  Project
//
//  Created by XuWen on 2020/4/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendMessageBlock)(NSString * _Nullable msg);

NS_ASSUME_NONNULL_BEGIN
static NSString * const kLSMatchMsgCellIdentifier = @"LSMatchMsgCell";
@interface LSMatchMsgCell : UICollectionViewCell
@property (nonatomic,strong) NSString *title;
@property (nonatomic,copy)SendMessageBlock sendBlock;
@end

NS_ASSUME_NONNULL_END
