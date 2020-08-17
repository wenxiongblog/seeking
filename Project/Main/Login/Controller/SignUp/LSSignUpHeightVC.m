//
//  LSSignUpHeightVC.m
//  Project
//
//  Created by XuWen on 2020/2/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpHeightVC.h"
#import "LSSignUpHeadVC.h"
#import "LSSignUpLocationVC.h"


@interface LSSignUpHeightVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIButton *nextButton;
//
@property (nonatomic,assign) CGFloat heigth;
@property (nonatomic,assign) CGFloat maxInch;
@property (nonatomic,assign) CGFloat minInch;

@end

@implementation LSSignUpHeightVC

#pragma mark - 埋点
- (void)MDChooseHeight05{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxInch = 7.0;
    self.minInch = 5.4;
    self.heigth = self.minInch;
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView selectRow:4 inComponent:0 animated:NO];
    });
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.titleLabel.text = kLanguage(@"Your height");
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.pickerView];
}

- (void)SEEKING_baseConstraintsConfig
{
     [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.equalTo(@(XW(300)));
           make.height.equalTo(@(XW(200)));
           make.centerX.equalTo(self.view);
           make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
       }];
       [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.equalTo(@50);
           make.width.equalTo(@(XW(300)));
           make.centerX.equalTo(self.view);
           make.top.equalTo(self.pickerView.mas_bottom).offset(30);
       }];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //7.0英寸到5.4英寸
    return (int)(self.maxInch - self.minInch)*10;
}
// 返回pickerView 每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc]init];
        view.backgroundColor = [UIColor xwColorWithHexString:@"#18233e"];
    }

    //英尺
    CGFloat inch = (row+self.minInch*10)/10.0;
    UILabel *label = [[UILabel alloc]init];
    [label commonLabelConfigWithTextColor:[UIColor themeColor] font:Font(18) aliment:NSTextAlignmentLeft];
    label.text = [NSString stringWithFormat:@"%d’%d’‘",(int)((inch*10)/10),(int)(inch*10)%10];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
        make.width.equalTo(@100);
    }];
    
    //厘米
    CGFloat cm = inch/0.032808;
    UILabel *label1 = [[UILabel alloc]init];
    [label1 commonLabelConfigWithTextColor:[UIColor themeColor] font:Font(18) aliment:NSTextAlignmentRight];
    label1.text = [NSString stringWithFormat:@"%dcm",(int)cm];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(view);
        make.width.equalTo(@100);
    }];
    
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerView.subviews objectAtIndex:3].backgroundColor = [UIColor clearColor];
//
    return view;
}
// 返回pickerView 每行的内容
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
}
*/
// 选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CGFloat inch = (row+self.minInch*10)/10.0;
    self.heigth = inch;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 设置列的宽度
    return XW(200);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    // 设置列中的每行的高度
    return 50.0;
}

- (UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        UIView *chooseView = [[UIView alloc]init];
        chooseView.backgroundColor = [UIColor clearColor];
        chooseView.userInteractionEnabled = NO;
        [chooseView xwDrawBorderWithColor:[UIColor themeColor] radiuce:5 width:1.5];
        [_pickerView addSubview:chooseView];
        [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pickerView);
            make.height.equalTo(@(50));
            make.width.equalTo(self.pickerView);
        }];
    }
    return _pickerView;
}


#pragma mark - setter & getter1
- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"THIS IS MY HEIGHT") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [button setAction:^{
            kUser.height = [NSString stringWithFormat:@"%.1f",self.heigth];
            [self MDChooseHeight05];
            
            LSSignUpHeadVC *vc = [[LSSignUpHeadVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        _nextButton = button;
    }
    return _nextButton;
}



@end
