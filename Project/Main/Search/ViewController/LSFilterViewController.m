//
//  LSFilterViewController.m
//  Project
//
//  Created by XuWen on 2020/3/5.
//  Copyright © 2020 xuwen. All rights reserved.
//
                
#import "LSFilterViewController.h"
#import "DoubleSliderView.h"
#import "LSVIPAlertView.h"
#import "LSSlider.h"
    
@interface LSFilterViewController ()
@property (nonatomic,strong) UIButton *updateButton;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *showmeLabel;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *GuysButton;
@property (nonatomic,strong) UIButton *GirlsButton;
@property (nonatomic,strong) UIButton *BothButton;
//搜索年龄
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UILabel *ageValueLabel;
@property (nonatomic,strong) DoubleSliderView *slider;

//搜索范围
@property (nonatomic,strong) UILabel *rediusLabel;
@property (nonatomic,strong) UILabel *rediusValueLabel;
@property (nonatomic,strong) LSSlider *rediusSlider;

//临时数据
@property (nonatomic,assign) int sex;
@property (nonatomic,assign) int startAge;
@property (nonatomic,assign) int endAge;
@property (nonatomic,assign) int redius;
@end

@implementation LSFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sex = [kFilter.sex intValue];
    self.redius = [kFilter.redius intValue];
    if([kFilter.startage intValue] >=18 || [kFilter.startage intValue] <=60){
        self.startAge = [kFilter.startage intValue];
        self.endAge = [kFilter.endage intValue];
    }
    
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    
    [self.view bringSubviewToFront:self.navBarView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //禁用侧滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //开启侧滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self speciceNavWithTitle:kLanguage(@"Filter")];
    [self.view addSubview:self.updateButton];
    
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.showmeLabel];
    [self.contentView addSubview:self.chooseView];
    
    [self.contentView addSubview:self.ageLabel];
    [self.contentView addSubview:self.ageValueLabel];
    [self.contentView addSubview:self.slider];
    
    [self.contentView addSubview:self.rediusLabel];
    [self.contentView addSubview:self.rediusValueLabel];
    [self.contentView addSubview:self.rediusSlider];
    
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-30);
        make.height.equalTo(@50);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.equalTo(@(400));
    }];
    [self.showmeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(40);
    }];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(XW(340.5)));
        make.height.equalTo(@(XW(44)));
        make.top.equalTo(self.showmeLabel.mas_bottom).offset(15);
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showmeLabel);
        make.top.equalTo(self.chooseView.mas_bottom).offset(55);
    }];
    [self.ageValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.ageLabel);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.ageValueLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    [self.rediusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showmeLabel);
        make.top.equalTo(self.slider.mas_bottom).offset(50);
    }];
    [self.rediusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.rediusLabel);
    }];
    [self.rediusSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.rediusValueLabel.mas_bottom).offset(35);
        make.height.equalTo(@40);
    }];
}

#pragma mark - event
- (void)chooseButtonClicked:(UIButton *)sender
{
    self.GuysButton.selected = NO;
    self.GirlsButton.selected = NO;
    self.BothButton.selected = NO;
    sender.selected = YES;
    NSLog(@"%ld",(long)sender.tag);
    self.sex = (int)sender.tag;
}

#pragma mark -  setter & getter
- (UIButton *)updateButton
{
    if(!_updateButton){
        _updateButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Update") font:Font(17) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_updateButton xwDrawCornerWithRadiuce:5];
        [_updateButton setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_updateButton setAction:^{
            
            if(!kUser.isVIP){
                  [LSVIPAlertView purchaseWithType:LSVIPAlertPointType_filter];
                  return;
              }
            
            kFilter.startage = [NSString stringWithFormat:@"%d",weakself.startAge];
            kFilter.endage = [NSString stringWithFormat:@"%d",weakself.endAge];
            kFilter.sex = [NSString stringWithFormat:@"%d",weakself.sex];
            kFilter.redius = [NSString stringWithFormat:@"%d",weakself.redius];
            kFilter.isFilter = @"1";
            [kFilter synchronize];
            if(weakself.filterBlock){
                weakself.filterBlock(YES);
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _updateButton;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor projectBlueColor];
    }
    return _contentView;
}

- (UILabel *)showmeLabel
{
    if(!_showmeLabel){
        _showmeLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8C8C8C"] font:Font(12) aliment:NSTextAlignmentLeft];
        _showmeLabel.text = kLanguage(@"SHOW ME");
    }
    return _showmeLabel;
}

- (UIView *)chooseView
{
    if(!_chooseView){
        _chooseView = [[UIView alloc]init];
        _chooseView.backgroundColor = [UIColor themeBlueColor];
        [_chooseView xwDrawCornerWithRadiuce:XW(22)];
        
        [_chooseView addSubview:self.BothButton];
        [_chooseView addSubview:self.GuysButton];
        [_chooseView addSubview:self.GirlsButton];
        
        [self.BothButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.chooseView);
            make.width.equalTo(self.chooseView).multipliedBy(1/3.0);
        }];
        [self.GuysButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.chooseView);
            make.left.equalTo(self.BothButton.mas_right);
            make.width.equalTo(self.BothButton);
        }];
        [self.GirlsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.chooseView);
            make.width.equalTo(self.chooseView).multipliedBy(1/3.0);
        }];
        
    }
    return _chooseView;
}

- (UIButton *)GuysButton
{
    if(!_GuysButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Guys") font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        button.selected = [kFilter.sex isEqualToString:@"1"];
        _GuysButton = button;
    }
    return _GuysButton;
}

- (UIButton *)GirlsButton
{
    if(!_GirlsButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Girls") font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        button.selected = [kFilter.sex isEqualToString:@"2"];
        _GirlsButton = button;
    }
    return _GirlsButton;
}

- (UIButton *)BothButton
{
    if(!_BothButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Both") font:Font(15) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:XWImageName(@"buttonBg") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        button.selected = ([kFilter.sex isEqualToString:@"0"]||kFilter.sex.length == 0);
        _BothButton = button;
    }
    return _BothButton;
}

- (UILabel *)ageLabel
{
    if(!_ageLabel){
        _ageLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8C8C8C"] font:Font(12) aliment:NSTextAlignmentLeft];
        _ageLabel.text = kLanguage(@"AGE");
    }
    return _ageLabel;
}

- (UILabel *)ageValueLabel
{
    if(!_ageValueLabel){
        _ageValueLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(12) aliment:NSTextAlignmentLeft];
        if([kFilter.startage intValue] >= 18){
            _ageValueLabel.text = [NSString stringWithFormat:@"%d-%d",[kFilter.startage intValue],[kFilter.endage intValue]];
        }else{
            _ageValueLabel.text = @"18-60";
        }
    }
    return _ageValueLabel;
}

- (DoubleSliderView *)slider
{
    if(!_slider){
        _slider = [[DoubleSliderView alloc]initWithFrame:CGRectMake(15, 20, kSCREEN_WIDTH-30, 30)];
        _slider.curMinValue = 18;
        _slider.curMaxValue = 60;
        
        if(kFilter.startage.length == 0){
            _slider.initMinValue = 18;
            _slider.initMaxValue = 60;
        }else{
            _slider.initMinValue = ([kFilter.startage floatValue] - 18.0)/(60-18);
            _slider.initMaxValue = ([kFilter.endage floatValue]- 18.0)/(60-18);
        }
        
        _slider.minInterval = 0.1;
        _slider.needAnimation = YES;
        _slider.midTintColor = [UIColor themeColor];
        _slider.minTintColor = [UIColor themeBlueColor];
        _slider.maxTintColor = [UIColor themeBlueColor];
        
        
        kXWWeakSelf(weakself);
        _slider.sliderBtnLocationChangeBlock = ^(BOOL isLeft, BOOL finish) {
            NSLog(@"min%f",weakself.slider.curMinValue);
            NSLog(@"max%f",weakself.slider.curMaxValue);
            
            CGFloat min = 18+weakself.slider.curMinValue*(60-18);
            CGFloat max = 18+weakself.slider.curMaxValue*(60-18);
            NSInteger minInt = (NSInteger)min;
            NSInteger maxInt = (NSInteger)max;
            weakself.ageValueLabel.text = [NSString stringWithFormat:@"%ld-%ld",minInt,maxInt];
            
            //赋值
            weakself.startAge = minInt;
            weakself.endAge = maxInt;
        };
    }
    return _slider;
}


- (UILabel *)rediusLabel
{
    if(!_rediusLabel){
        _rediusLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#8C8C8C"] font:Font(12) aliment:NSTextAlignmentLeft];
        _rediusLabel.text = kLanguage(@"SEARCH REDIUS");
    }
    return _rediusLabel;
}

- (UILabel *)rediusValueLabel
{
    if(!_rediusValueLabel){
        _rediusValueLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(12) aliment:NSTextAlignmentRight];
        if(self.redius == 0){
           _rediusValueLabel.text = kLanguage(@"ALL");
        }else{
            _rediusValueLabel.text = [NSString stringWithFormat:@"%dKM",self.redius];
        }
        
    }
    return _rediusValueLabel;
}

- (LSSlider *)rediusSlider
{
    if(!_rediusSlider){
        _rediusSlider = [[LSSlider alloc]initWithFrame:CGRectMake(15, 20, kSCREEN_WIDTH-30, 40)];
        _rediusSlider.minimumValue = 0.0;
        _rediusSlider.maximumValue = 5000;
        _rediusSlider.value = self.redius;
        _rediusSlider.minimumTrackTintColor = [UIColor themeColor];
        _rediusSlider.maximumTrackTintColor = [UIColor themeBlueColor];
        [_rediusSlider setThumbImage:XWImageName(@"slider_image") forState:UIControlStateNormal];
        [_rediusSlider addTarget:self action:@selector(rediusValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _rediusSlider;
}

- (void)rediusValueChange:(LSSlider *)sender
{
    self.redius = sender.value;
    if(sender.value == 0.0){
        self.rediusValueLabel.text = kLanguage(@"ALL");
    }else{
        self.rediusValueLabel.text = [NSString stringWithFormat:@"%dKM",self.redius];
    }
}
@end
