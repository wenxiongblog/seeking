//
//  SenLin_Dating_URL.h
//  Project
//
//  Created by XuWen on 2020/3/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#ifndef SenLin_Dating_URL_h
#define SenLin_Dating_URL_h

// 环境切换，1为生产，0为测试环境
#define ENV_RELEASE     1

#if ENV_RELEASE
#define BASE_URL              ([XXLog requestUrl:@"https://meetdating.com.cn/"])
//#define BASE_URL              ([XXLog requestUrl:@"http://54.215.133.245:10003/"])
#else
#define BASE_URL              ([XXLog requestUrl:@"http://47.114.7.228:10003/"])
#endif

#pragma mark - URL = BASE_URL + (v)

#define URL(v)                [NSString stringWithFormat:@"%@%@", BASE_URL, v]

//隐私协议
#define URL_Privicy  URL(@"web/static/adivitise/protocol.html?code=TFTB_PRIVACY_POLICY")
//用户协议
#define URL_REAL_NAME_REG_AGREEMENT URL(@"web/static/adivitise/protocol.html?code=REAL_NAME_REG_AGREEMENT")
#pragma mark - 模块 = URL + (@"") = BASE_URL + (v) +  (@"")
#define Users(v)                [NSString stringWithFormat:@"%@%@", URL(@"users"), v]

#pragma mark - 接口
// 邮箱注册
#define kURL_RegisterByEmail URL(@"rongyun")
// 邮箱登录
#define kURL_LoginByEmial URL(@"userlogin")
// 普通账号密码注册接口
#define kURL_RegisterByPwd   URL(@"register")
// 首页用户
#define kURL_HomeList   URL(@"home")
// 完善用户信息
#define kURL_UpdateUserInfo  URL(@"updateusermessbyid")
// 获取用户信息
#define kURL_GetUserInfo URL(@"getusermessbyid")
// 更新用户经纬度
#define kURL_LocationRefresh URL(@"iprefresh")
// 发现，拉取卡片
#define kURL_DiscoverCards URL(@"getcard")
// 喜欢  右话
#define KURL_Like URL(@"saveLike")
// 不喜欢 左滑
#define KURL_DISLike URL(@"saveDisLike")
// 取消喜欢
#define kURL_CancelMatch URL(@"delmatch")
// 我喜欢的人列表
#define kURL_GetILike URL(@"getilike")
// 喜欢我的人列表
#define kURL_GetLikeMe URL(@"getlikeme")
// 查看过我的人的列表
#define kURL_ViewedMe URL(@"getuserlistlookme")
// 筛选喜欢的人
#define kURL_Filter URL(@"search")
// 用户信息详情
#define KURL_DetailInfo URL(@"getusermessbyid")
// 加入收藏
#define KURL_CollectCustomer URL(@"saveCollection")
// 取消收藏
#define KURL_DIS_CollectCustomer URL(@"removeCollection")
// 上传头像照片
#define KURL_UploadImg URL(@"upload")
// 加入黑名单
#define kURL_BlockUser URL(@"addblacklist")
// 匹配成功人的列表
#define kURL_MatchList URL(@"getMutualliking")
// 销毁账号
#define KURL_DestroyAccount URL(@"deluser")
// 我的收藏
#define kURL_GetCollection URL(@"geticollection")
// 获取打招呼的人
#define KURL_RandowZhaoHu URL(@"random")
// 精品用户
#define KURL_ElileMan URL(@"fineuser")
#endif /* SenLin_Dating_URL_h */
