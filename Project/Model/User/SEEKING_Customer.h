//
//  SEEKING_Customer.h
//  Project
//
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SEEKING_Customer : NSObject

//添加
@property (nonatomic,strong) NSString *conversationId; //会话id

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int sex;  //1 男 2 女
@property (nonatomic,assign) int seeking;  //1 男 2 女
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *birthday;

@property (nonatomic,strong) NSString *images; //头像
@property (nonatomic,strong) NSString *imageslist; //相册
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *identityToken;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,assign) int online;
@property (nonatomic,assign) int state;
@property (nonatomic,assign) uint age;
@property (nonatomic,strong) NSString *page;
@property (nonatomic,strong) NSString *pagesize;

@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;

@property (nonatomic,strong) NSString *videostate;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *follow;
@property (nonatomic,strong) NSString *fans;
@property (nonatomic,strong) NSString *platform;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *blacklisttime;
@property (nonatomic,assign) int balance;
@property (nonatomic,strong) NSArray *giftlist;

//后面添加
@property (nonatomic,strong) NSString * height;
@property (nonatomic,strong) NSString * weight;  
@property (nonatomic,strong) NSString * relationship; //情感状态
@property (nonatomic,strong) NSString * lookingforage; //找的年龄区间

@property (nonatomic,strong) NSString * interested;  //兴趣
@property (nonatomic,strong) NSString * address;  //城市 city换名称
@property (nonatomic,assign) float distance; //距离 这里要传入自己的金纬度

//详情信息
@property (nonatomic,assign) int islike;  //通过详情接口获取，是否喜欢 1已经喜欢，0没喜欢
@property (nonatomic,assign) int iscollection; //是否自己收藏过的用户， 1已经收藏，0没收藏

//VIP有效期
@property (nonatomic,strong) NSString *effectiveTime;
@property (nonatomic,assign) BOOL isVIPCustomer;
//填写的 11个步骤
@property (nonatomic,strong) NSString *about;
@property (nonatomic,strong) NSString *school;
@property (nonatomic,strong) NSString *job;
@property (nonatomic,strong) NSString *needfor;  //交友目的
@property (nonatomic,strong) NSString *kid;
@property (nonatomic,strong) NSString *pet;
@property (nonatomic,strong) NSString *belief;
@property (nonatomic,strong) NSString *bodyType;
@property (nonatomic,strong) NSString *drinking;
@property (nonatomic,strong) NSString *smoking;
@property (nonatomic,strong) NSString *diet;
//我的标签 自定义
@property (nonatomic,strong) NSArray *tags;

@property (nonatomic,strong) NSString *creattime;//创建时间  是否是新用户
@property (nonatomic,strong) NSString *paytime;  //付款时间
@property (nonatomic,assign) CGFloat paymoney;  //付款金额
@property (nonatomic,strong) NSDictionary *other; //预备字段
@property (nonatomic,assign) BOOL isOnline; //是否在线  0是在线 1是不在线
@property (nonatomic,assign) int incognito; //是否是隐身模式

//融云的额外信息
@property (nonatomic,strong) NSString *rongYunExtra;
//融云额外字段，包括了招呼标识
- (NSString *)rongYunExtraWithZhaoHu;
@end

NS_ASSUME_NONNULL_END
