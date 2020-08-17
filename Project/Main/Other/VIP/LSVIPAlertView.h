//
//  LSVIPAlertView.h
//  Project
//
//  Created by XuWen on 2020/3/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"
/**
1. 首页底部
2. 精品用户底部
3. 筛选
4. 看喜欢我的人
5. 查看我的人
6. 发送消息
7. 设置界面
8. 开通权限Features
9. 隐私模式
10.匹配界面限制
*/
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, LSVIPAlertPointType) {
    LSVIPAlertPointType_noneSuccess = 0,  //不知道
    LSVIPAlertPointType_searchMore,  //    1. 首页底部
    LSVIPAlertPointType_cute,        //    2. 精品用户底部
    LSVIPAlertPointType_filter,      //    3. 筛选
    LSVIPAlertPointType_likeMe,      //    4. 看喜欢我的人
    LSVIPAlertPointType_viewMe,      //    5. 查看我的人
    LSVIPAlertPointType_message,     //    6. 发送消息
    LSVIPAlertPointType_Setting,     //    7. 设置界面
    LSVIPAlertPointType_Feature,     //    8. 开通权限Features
    LSVIPAlertPointType_Incognito,   //    9. 隐私模式
    LSVIPAlertPointType_Match,       //    10.匹配界面限制
};

@interface LSVIPAlertView : XWBaseAlertView

+ (void)purchaseWithType:(LSVIPAlertPointType)type;


//@property (nonatomic,strong) UIImage *bgImage;
@end

NS_ASSUME_NONNULL_END
