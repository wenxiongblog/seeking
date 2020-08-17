//
//  LSChooseHWeightView.m
//  Project
//
//  Created by XuWen on 2020/3/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSChooseHWeightView.h"
typedef void(^SelectedBlock)(NSString *title);
@interface LSChooseHWeightView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,copy) SelectedBlock selectedBlock;
//高度
@property (nonatomic,assign) int myheight;
@property (nonatomic,assign) int maxInch;
@property (nonatomic,assign) int minInch;
@property (nonatomic,assign) CGFloat preHeight;
@end

@implementation LSChooseHWeightView


+ (void)showHeight:(CGFloat)height select:(void(^)(NSString *title))selectedBlock
{
    LSChooseHWeightView *alertView = [[LSChooseHWeightView alloc]initWithStyle:XWBaseAlertViewStyleBottom];
    alertView.preHeight = (round(height*10)) /10.0;
    alertView.selectedBlock = selectedBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [alertView appearAnimation];
}

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        
        //高度
        self.maxInch = 70;
        self.minInch = 54;
        self.myheight = self.minInch;
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.pickerView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.equalTo(self.contentView).offset(-20-kSafeAreaBottomHeight);
          make.width.equalTo(@(XW(340)));
          make.height.equalTo(@64);
          make.centerX.equalTo(self.contentView);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(340)));
        make.height.equalTo(@(XW(250)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-20);
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
    return (int)(self.maxInch - self.minInch);
}
// 返回pickerView 每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc]init];
        
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [whiteView xwDrawCornerWithRadiuce:18];
        [view addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
            make.height.equalTo(@64);
            make.center.equalTo(view);
        }];
    }

    //英尺
    CGFloat inch = (row+self.minInch)/10.0;
    UILabel *label = [[UILabel alloc]init];
    [label commonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentLeft];
    label.text = [NSString stringWithFormat:@"%d’%d’‘",(int)((inch*10)/10),(int)(inch*10)%10];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.right.equalTo(view.mas_centerX);
        make.width.equalTo(@100);
    }];
    
    //厘米
    CGFloat cm = inch/0.032808;
    UILabel *label1 = [[UILabel alloc]init];
    [label1 commonLabelConfigWithTextColor:[UIColor blackColor] font:Font(18) aliment:NSTextAlignmentRight];
    label1.text = [NSString stringWithFormat:@"%dcm",(int)cm];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view.mas_centerX);
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
    CGFloat inch = (row+self.minInch);
    self.myheight = inch;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 设置列的宽度
    return XW(340);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    // 设置列中的每行的高度
    return 70.0;
}



#pragma mark - setter & getter1
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView xwDrawCornerWithRadiuce:10];
    }
    return _contentView;
}

- (UIButton *)cancelButton
{
    if(!_cancelButton){
        _cancelButton = [UIButton creatCommonButtonConfigWithTitle:@"OK" font:Font(24) titleColor:[UIColor xwColorWithHexString:@"#FF0000"] aliment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton xwDrawCornerWithRadiuce:18];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        kXWWeakSelf(weakself);
        [_cancelButton setAction:^{
            if(weakself.selectedBlock){
                NSString *str = [NSString stringWithFormat:@"%.1f",(weakself.myheight)/10.0];
                weakself.selectedBlock(str);
            }
            [weakself disappearAnimation];
        }];
    }
    return _cancelButton;
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
//        [chooseView xwDrawBorderWithColor:[UIColor themeColor] radiuce:5 width:1.5];
        [_pickerView addSubview:chooseView];
        [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pickerView);
            make.height.equalTo(@(64));
            make.width.equalTo(self.pickerView);
        }];
    }
    return _pickerView;
}


- (void)setPreHeight:(CGFloat)preHeight
{
    _preHeight = preHeight;
    if(_preHeight < self.minInch/10.0 || _preHeight > self.maxInch/10.0
       ){
        return;
    }
    int row = (int)((preHeight*10 - self.minInch));
    [self.pickerView selectRow:row inComponent:0 animated:NO];
    self.myheight = (preHeight*10);
}

@end
