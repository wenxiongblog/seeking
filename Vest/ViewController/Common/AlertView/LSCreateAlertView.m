//
//  LSCreateAlertView.m
//  Project
//
//  Created by XuWen on 2020/8/27.
//  Copyright © 2020 xuwen. All rights reserved.
//
    
#import "LSCreateAlertView.h"
#import "VESTThreeVC.h"
#import "VESTCreateFinishAlertView.h"
#import "VESTChargeVC.h"

@interface LSCreateAlertView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLabel;//房间类型
@property (nonatomic,strong) UIButton *typeButton1;
@property (nonatomic,strong) UIButton *typeButton2;

@property (nonatomic,strong) UILabel *titleLabel2;
@property (nonatomic,strong) NSMutableArray *themeButtonArray;

@property (nonatomic,strong) UIButton *createButton;
@property (nonatomic,strong) UILabel *label;

//临时数据
@property (nonatomic,assign) BOOL typeSelected;
@property (nonatomic,assign) BOOL themeSelected;

@end

@implementation LSCreateAlertView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}
#pragma mark - public
#pragma mark - private

- (void)create
{
    if(!self.typeSelected){
        [AlertView toast:@"Please select type" inView:self];
        return;
    }
    if(!self.themeSelected){
        [AlertView toast:@"Please select Theme" inView:self];
        return;
    }
    [self disappearAnimation];
    
    if([VESTChargeVC costCoins:80]){
        //弹出提示框
          VESTCreateFinishAlertView *AlertView  = [[VESTCreateFinishAlertView alloc]initWithStyle:XWBaseAlertViewStyleCenter];
          [[UIApplication sharedApplication].keyWindow addSubview:AlertView ];
          [AlertView  appearAnimation];
    }else{
        [AlertView toast:@"Insufficient coins" inView:self];
    }
  
}

#pragma mark - event
- (void)typeButtonClicke:(UIButton *)sender
{
    self.typeButton1.selected = NO;
    self.typeButton2.selected = NO;
    sender.selected = YES;
    self.typeSelected = YES;
}

- (void)themeButtonClicked:(UIButton *)sender
{
    for(UIButton *button in self.themeButtonArray){
        button.selected = NO;
    }
    sender.selected = YES;
    self.themeSelected = YES;
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.placeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.typeButton1];
    [self.contentView addSubview:self.typeButton2];
    
    [self.contentView addSubview:self.titleLabel2];
    
    [self.contentView addSubview:self.createButton];
    [self.contentView addSubview:self.label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    tap.delegate = self;
    [self.placeView addGestureRecognizer:tap];
}

- (void)tapClicked
{
    [self disappearAnimation];
}

- (void)baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@306);
        make.height.equalTo(@(409));
        make.center.equalTo(self.placeView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17);
        make.top.equalTo(self.contentView).offset(20);
    }];
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17);
        make.top.equalTo(self.contentView).offset(115);
    }];
    
    [self.typeButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@130);
        make.height.equalTo(@42);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [self.typeButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@132);
        make.height.equalTo(@42);
        make.left.equalTo(self.typeButton1.mas_right).offset(12);
        make.top.equalTo(self.typeButton1);
    }];
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.label.mas_top).offset(-10);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self createThemeButtons];
}

- (void)createThemeButtons
{
    NSArray *array = @[@"Singing",@"Chat",@"Friends",@"Family",@"Others"];
    int x = 12;
    int y = 145;
    int i = 0;
    for(NSString *title in array){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:title font:Font(15) titleColor:[UIColor xwColorWithHexString:@"#454545"] aliment:0];
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor xwColorWithHexString:@"#CBCBCB"]] forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button xwDrawCornerWithRadiuce:21];
        
        button.frame = CGRectMake(x+(i%2)*100, y+(i/2)*52, 90, 42);
        button.tag = i;
        [button addTarget:self action:@selector(themeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [self.themeButtonArray addObject:button];
    
        i++;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isDescendantOfView:self.contentView]){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - setter & getter
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:16];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentLeft];
        _titleLabel.text = @"Room type";
    }
    return _titleLabel;
}

- (UILabel *)titleLabel2
{
    if(!_titleLabel2){
        _titleLabel2 = [UILabel createCommonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentLeft];
        _titleLabel2.text = @"Theme";
    }
    return _titleLabel2;
}


- (UIButton *)typeButton1
{
    if(!_typeButton1){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:@"Chat room" font:Font(15) titleColor:[UIColor xwColorWithHexString:@"#454545"] aliment:0];
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor xwColorWithHexString:@"#CBCBCB"]] forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button xwDrawCornerWithRadiuce:21];
        [button addTarget:self action:@selector(typeButtonClicke:) forControlEvents:UIControlEventTouchUpInside];
        _typeButton1 = button;
    }
    return _typeButton1;
}

- (UIButton *)typeButton2
{
    if(!_typeButton2){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:@"Live streaming" font:Font(15) titleColor:[UIColor xwColorWithHexString:@"#454545"] aliment:0];
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor xwColorWithHexString:@"#CBCBCB"]] forState:UIControlStateNormal];
        [button setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button xwDrawCornerWithRadiuce:21];
        [button addTarget:self action:@selector(typeButtonClicke:) forControlEvents:UIControlEventTouchUpInside];
        _typeButton2 = button;
    }
    return _typeButton2;
}


- (NSMutableArray *)themeButtonArray
{
    if(!_themeButtonArray){
        _themeButtonArray = [NSMutableArray array];
    }
    return _themeButtonArray;
}

- (UIButton *)createButton
{
    if(!_createButton){
        _createButton = [UIButton creatCommonButtonConfigWithTitle:@"Create" font:Font(16) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_createButton setBackgroundImage:XWImageName(@"vest_buttonBG") forState:UIControlStateNormal];
        [_createButton xwDrawCornerWithRadiuce:21];
        [_createButton setAction:^{
            [self create];
        }];
    }
    return _createButton;
}

- (UILabel *)label
{
    if(!_label){
        _label = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:Font(14) aliment:NSTextAlignmentLeft];
        _label.text = @"cost 80 coins";
    }
    return _label;
}


@end
