//
//  LSVIPAlertView.m
//  Project
//
//  Created by XuWen on 2020/3/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSVIPAlertView.h"
//#import "LSPurchaseButton.h"
#import "LSPurchaseNewButton.h"
#import <RMStore/RMStore.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LSPurchaseManager.h"

@interface LSVIPAlertView()

@property (nonatomic,assign) LSVIPAlertPointType pointType;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *restoreButton;

//@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIButton *continueButton;

@property (nonatomic,strong) UIImageView *saveImageView0;
@property (nonatomic,strong) UIImageView *saveImageView1;
@property (nonatomic,strong) UIImageView *saveImageView2;
@property (nonatomic,strong) UIView *purchaseView;

@property (nonatomic,strong) LSPurchaseNewButton *button0;
@property (nonatomic,strong) LSPurchaseNewButton *button1;
@property (nonatomic,strong) LSPurchaseNewButton *button2;
@property (nonatomic,strong) NSArray <LSPurchaseNewButton *>*buttonArray;
@property (nonatomic,strong) LSPurchaseModel *selectedModel;

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

//模糊的背景图片
@property (nonatomic,strong) UIImageView *shadowImageView;
@property (nonatomic,strong) UIVisualEffectView *effectView;
//临时数据
@property (nonatomic,assign) NSInteger selectedItem;

@end

@implementation LSVIPAlertView

//购买成功
- (void)purchase01_searchMore{}  //    1. 首页底部
- (void)purchase02_cute{}       //    2. 精品用户底部
- (void)purchase03_filter{}      //    3. 筛选
- (void)purchase04_likeMe{}      //    4. 看喜欢我的人
- (void)purchase05_viewMe{}      //    5. 查看我的人
- (void)purchase06_message{}     //    6. 发送消息
- (void)purchase07_Setting{}     //    7. 设置界面
- (void)purchase08_Feature{}     //    8. 开通权限Features
- (void)purchase09_Incognito{}   //    9. 隐私模式
- (void)purchase10_Match{}       //    10.匹配界面限制

//关闭
- (void)MDPurchaseClose{}

//开始购买
- (void)purchase01_searchMore_Begin{}  //    1. 首页底部
- (void)purchase02_cute_Begin{}       //    2. 精品用户底部
- (void)purchase03_filter_Begin{}      //    3. 筛选
- (void)purchase04_likeMe_Begin{}      //    4. 看喜欢我的人
- (void)purchase05_viewMe_Begin{}      //    5. 查看我的人
- (void)purchase06_message_Begin{}     //    6. 发送消息
- (void)purchase07_Setting_Begin{}     //    7. 设置界面
- (void)purchase08_Feature_Begin{}     //    8. 开通权限Features
- (void)purchase09_Incognito_Begin{}   //    9. 隐私模式
- (void)purchase10_Match_Begin{}       //    10.匹配界面限制

//开始购买总次数
- (void)MDpurchase_begin{}

#pragma mark - public 购买类型
+ (void)purchaseWithType:(LSVIPAlertPointType)type
{
    LSVIPAlertView *alertView = [[LSVIPAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
    alertView.pointType = type;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [alertView appearAnimation];
}

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){

        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        self.effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
        [self.placeView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.placeView);
        }];
        
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        
        //显示数据
        [self configDatas];
    }
    return self;
}



#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    //
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.cycleScrollView];
    
    [self.contentView addSubview:self.purchaseView];
    [self.contentView addSubview:self.continueButton];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.restoreButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kSCREEN_WIDTH));
//        make.height.equalTo(@(XW(409)));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.purchaseView.mas_top).offset(-10);
    }];
    [self.purchaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(345)));
        make.height.equalTo(@(XW(161)+XW(45)));
//        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.continueButton.mas_top).offset(-30);
    }];
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@75);
        make.height.equalTo(@24);
        make.top.equalTo(self.contentView).offset(kStatusBarHeight);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self.restoreButton);
        make.left.equalTo(self.contentView).offset(15);
    }];
}

//加载数据，这里有预先加载完毕的
- (void)configDatas
{
    kXWWeakSelf(weakself);
    [[LSPurchaseManager share]preGetPurchaseInfo:^(NSArray<LSPurchaseModel *> * _Nonnull array) {
        if(array.count >=3){
            weakself.button0.model = array.firstObject;
            weakself.button1.model = array[1];
            weakself.button2.model = array.lastObject;
            //选中第一个
            weakself.selectedModel = array.firstObject;
            weakself.button0.selected = YES;
            weakself.button1.selected = NO;
            weakself.button2.selected = NO;
        }
    }];
}

#pragma mark - private
- (void)restoreClicked:(UIButton *)sender
{
    kXWWeakSelf(weakself);
    [LSPurchaseManager restore:^(BOOL isSuccess) {
        if(isSuccess){
            [weakself disappearAnimation];
        }else{
            
        }
    }];
}

#pragma mark - 埋点方法
//开始进入

#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor xwColorWithHexString:@"#0B0C11"];
    }
    return _contentView;
}

- (UIButton *)continueButton
{
    if(!_continueButton){
        _continueButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"CONTINUE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _continueButton.backgroundColor = [UIColor themeColor];
        [_continueButton xwDrawCornerWithRadiuce:5];
        kXWWeakSelf(weakself);
        [_continueButton setAction:^{
            //埋点
            [weakself MDpurchase_begin];
            
            //去进行支付
            [LSPurchaseManager purchseWithModel:weakself.selectedModel completeBlock:^(BOOL isSuccess) {
                if(isSuccess){
                    [weakself maidianPurchaseOK];
                    [weakself disappearAnimation];
                }else{
                    
                }
            }];
        }];
    }
    return _continueButton;
}

- (UIImageView *)saveImageView0
{
    if(!_saveImageView0){
        _saveImageView0 = [[UIImageView alloc]initWithImage:XWImageName(@"vip_save")];
        _saveImageView0.contentMode = UIViewContentModeScaleAspectFit;
        _saveImageView0.hidden = YES;
        
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
        label.text = kLanguage(@"SAVE 70%");
        [_saveImageView0 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.saveImageView0);
            make.top.equalTo(self.saveImageView0);
            make.bottom.equalTo(self.saveImageView0).offset(-4);
        }];
        
    }
    return _saveImageView0;
}

- (UIImageView *)saveImageView1
{
    if(!_saveImageView1){
        _saveImageView1 = [[UIImageView alloc]initWithImage:XWImageName(@"vip_save")];
        _saveImageView1.contentMode = UIViewContentModeScaleAspectFit;
        _saveImageView1.hidden = YES;
        
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
        label.text = kLanguage(@"POPULAR");
        [_saveImageView1 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.saveImageView1);
            make.top.equalTo(self.saveImageView1);
            make.bottom.equalTo(self.saveImageView1).offset(-4);
        }];
    }
    return _saveImageView1;
}

- (UIImageView *)saveImageView2
{
    if(!_saveImageView2){
        _saveImageView2 = [[UIImageView alloc]initWithImage:XWImageName(@"vip_save")];
        _saveImageView2.contentMode = UIViewContentModeScaleAspectFit;
        _saveImageView2.hidden = YES;
        
        UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
        label.text = kLanguage(@"SAVE 80%");
        [_saveImageView2 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.saveImageView2);
            make.top.equalTo(self.saveImageView2);
            make.bottom.equalTo(self.saveImageView2).offset(-4);
        }];
    }
    return _saveImageView2;
}

- (UIView *)purchaseView
{
    if(!_purchaseView){
        kXWWeakSelf(weakself);
        _purchaseView = [[UIView alloc]init];
        
        self.button0 = [[LSPurchaseNewButton alloc]init];
        self.button1 = [[LSPurchaseNewButton alloc]init];
        self.button2 = [[LSPurchaseNewButton alloc]init];
        self.buttonArray = @[self.button0,self.button1,self.button2];
        
        self.button0.selected = YES;
//        self.selectedModel =  [LSPurchaseModel createWithType:LSPurchaseType_30_Days];
        self.selectedItem = 0;
        self.saveImageView0.hidden = NO;
        
        [_purchaseView addSubview:self.saveImageView0];
        [_purchaseView addSubview:self.saveImageView1];
        [_purchaseView addSubview:self.saveImageView2];
        
        [_purchaseView addSubview:self.button0];
        [_purchaseView addSubview:self.button1];
        [_purchaseView addSubview:self.button2];
        
        [self.saveImageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(112)));
            make.centerX.equalTo(self.button0);
            make.top.equalTo(self.purchaseView);
        }];
        [self.saveImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(112)));
            make.centerX.equalTo(self.button1);
            make.top.equalTo(self.purchaseView);
        }];
        [self.saveImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(112)));
            make.centerX.equalTo(self.button2);
            make.top.equalTo(self.purchaseView);
        }];
        [self.button0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.purchaseView);
            make.width.equalTo(self.saveImageView0);
            make.top.equalTo(self.saveImageView0.mas_bottom).offset(5);
        }];
        [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.purchaseView);
            make.width.equalTo(self.saveImageView0);
            make.top.equalTo(self.saveImageView1.mas_bottom).offset(5);
        }];
        [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.purchaseView);
            make.width.equalTo(self.saveImageView0);
            make.top.equalTo(self.saveImageView2.mas_bottom).offset(5);
        }];
        
        [self.button0.button setAction:^{
            weakself.button0.selected = YES;
            weakself.button1.selected = NO;
            weakself.button2.selected = NO;
            weakself.selectedItem = 0;
            weakself.selectedModel = weakself.button0.model;
            
            weakself.saveImageView0.hidden = NO;
            weakself.saveImageView1.hidden = YES;
            weakself.saveImageView2.hidden = YES;
        }];
        [self.button1.button setAction:^{
            weakself.button0.selected = NO;
            weakself.button1.selected = YES;
            weakself.button2.selected = NO;
            weakself.selectedItem = 1;
            weakself.selectedModel = weakself.button1.model;
            
            weakself.saveImageView0.hidden = YES;
            weakself.saveImageView1.hidden = NO;
            weakself.saveImageView2.hidden = YES;
        }];
        [self.button2.button setAction:^{
            weakself.button0.selected = NO;
            weakself.button1.selected = NO;
            weakself.button2.selected = YES;
            weakself.selectedItem = 2;
            weakself.selectedModel = weakself.button2.model;
            
            weakself.saveImageView0.hidden = YES;
            weakself.saveImageView1.hidden = YES;
            weakself.saveImageView2.hidden = NO;
        }];
        
    }
    return _purchaseView;
}

- (UIButton *)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:XWImageName(@"VIP_close") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_closeButton setAction:^{
            [weakself MDPurchaseClose];
            [weakself disappearAnimation];
            
        }];
    }
    return _closeButton;
}


- (UIButton *)restoreButton
{
    if(!_restoreButton){
        _restoreButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Restore") font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _restoreButton.backgroundColor = [[UIColor xwColorWithHexString:@"#232A39"]colorWithAlphaComponent:0.5];
        [_restoreButton xwDrawCornerWithRadiuce:12];
        [_restoreButton addTarget:self action:@selector(restoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        kXWWeakSelf(weakself);
        [_restoreButton setAction:^{
            [LSPurchaseManager restore:^(BOOL isSuccess) {
                if(isSuccess){
                    [weakself disappearAnimation];
                }
            }];
        }];
    }
    return _restoreButton;
}

- (SDCycleScrollView *)cycleScrollView
{
    if(!_cycleScrollView){
        SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, XW(300), XW(409)) delegate:nil placeholderImage:nil];
        cycleScrollView4.backgroundColor = [UIColor clearColor];
        cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView4.imageURLStringsGroup = @[kLanguage(@"vip1"),kLanguage(@"vip2"),kLanguage(@"vip3"),kLanguage(@"vip4"),kLanguage(@"vip5")];
        cycleScrollView4.autoScrollTimeInterval = 2;
        cycleScrollView4.showPageControl = YES;
        cycleScrollView4.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView4.titleLabelTextAlignment = NSTextAlignmentCenter;
        cycleScrollView4.titleLabelBackgroundColor = [UIColor clearColor];
        cycleScrollView4.titleLabelTextFont = FontBold(18);
        cycleScrollView4.titleLabelHeight = 80;
        cycleScrollView4.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView = cycleScrollView4;
    }
    return _cycleScrollView;
}

- (UIImageView *)shadowImageView
{
    if(!_shadowImageView){
        _shadowImageView = [[UIImageView alloc]init];
    }
    return _shadowImageView;
}

- (void)setPointType:(LSVIPAlertPointType)pointType
{
    _pointType = pointType;
     [self maidianPurchase_begin];
}

- (void)maidianPurchase_begin
{
    switch (self.pointType) {
        case LSVIPAlertPointType_searchMore:
        {
            [self purchase01_searchMore_Begin];
        }
        break;//    1. 首页底部
        case LSVIPAlertPointType_cute:
        {
            [self purchase02_cute_Begin];
        }
        break;        //    2. 精品用户底部
        case LSVIPAlertPointType_filter:
        {
            [self purchase03_filter_Begin];
        }
        break;      //    3. 筛选
        case LSVIPAlertPointType_likeMe:
        {
            [self purchase04_likeMe_Begin];
        }
        break;      //    4. 看喜欢我的人
        case LSVIPAlertPointType_viewMe:
        {
            [self purchase05_viewMe_Begin];
        }
        break;      //    5. 查看我的人
        case LSVIPAlertPointType_message:
        {
            [self purchase06_message_Begin];
        }
        break;     //    6. 发送消息
        case LSVIPAlertPointType_Setting:
        {
            [self purchase07_Setting_Begin];
        }
        break;     //    7. 设置界面
        case LSVIPAlertPointType_Feature:
        {
            [self purchase08_Feature_Begin];
        }
        break;     //    8. 开通权限Features
        case LSVIPAlertPointType_Incognito:
        {
            [self purchase09_Incognito_Begin];
        }
        break;   //    9. 隐私模式
        case LSVIPAlertPointType_Match:
        {
            [self purchase10_Match_Begin];
        }
        break;       //    10.匹配界面限制
        default:{
            
        }// other
    }
}


- (void)maidianPurchaseOK
{
    switch (self.pointType) {
        case LSVIPAlertPointType_searchMore:
        {
            [self purchase01_searchMore];
        }
        break;//    1. 首页底部
        case LSVIPAlertPointType_cute:
        {
            [self purchase02_cute];
        }
        break;        //    2. 精品用户底部
        case LSVIPAlertPointType_filter:
        {
            [self purchase03_filter];
        }
        break;      //    3. 筛选
        case LSVIPAlertPointType_likeMe:
        {
            [self purchase04_likeMe];
        }
        break;      //    4. 看喜欢我的人
        case LSVIPAlertPointType_viewMe:
        {
            [self purchase05_viewMe];
        }
        break;      //    5. 查看我的人
        case LSVIPAlertPointType_message:
        {
            [self purchase06_message];
        }
        break;     //    6. 发送消息
        case LSVIPAlertPointType_Setting:
        {
            [self purchase07_Setting];
        }
        break;     //    7. 设置界面
        case LSVIPAlertPointType_Feature:
        {
            [self purchase08_Feature];
        }
        break;     //    8. 开通权限Features
        case LSVIPAlertPointType_Incognito:
        {
            [self purchase09_Incognito];
        }
        break;   //    9. 隐私模式
        case LSVIPAlertPointType_Match:
        {
            [self purchase10_Match];
        }
        break;       //    10.匹配界面限制
        default:{
            
        }// other
    }
}


@end
