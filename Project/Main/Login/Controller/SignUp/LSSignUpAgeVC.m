//
//  LSSignUpAgeVC.m
//  Project
//
//  Created by XuWen on 2020/2/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSignUpAgeVC.h"
#import "LSSignUpHeightVC.h"

@interface LSSignUpAgeVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIButton *nextButton;
//临时数据
@property (nonatomic,assign) uint age;
@end

@implementation LSSignUpAgeVC

#pragma mark - 埋点
- (void)MDChooseAge04{}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self SEEKING_baseConstraintsConfig];
    self.age = 23;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    self.titleLabel.text = kLanguage(@"Your age");
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.pickerView];
    [self.pickerView reloadComponent:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView selectRow:5 inComponent:0 animated:YES];
    });
    
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
    return 60-18;
}
// 返回pickerView 每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc]init];
    }
    UILabel *label = [[UILabel alloc]init];
    [label commonLabelConfigWithTextColor:[UIColor themeColor] font:Font(18) aliment:NSTextAlignmentCenter];
    label.text = [NSString stringWithFormat:@"%ld",row+18];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
//    //隐藏上下直线
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
    self.age = 18 + row;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 设置列的宽度
    return 100.0;
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
        chooseView.backgroundColor = [UIColor xwColorWithHexString:@"#18233e"];
        [_pickerView addSubview:chooseView];
        [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pickerView);
            make.height.equalTo(@(50));
            make.width.equalTo(self.pickerView);
        }];
    }
    return _pickerView;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"THIS IS MY AGE") font:Font(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button xwDrawCornerWithRadiuce:5];
        [button setBackgroundImage:XWImageName(@"nextButtonBg") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [button setAction:^{
            kUser.age = self.age;
            [self MDChooseAge04];
            LSSignUpHeightVC *vc = [[LSSignUpHeightVC alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
            
        }];
        _nextButton = button;
    }
    return _nextButton;
}
@end
