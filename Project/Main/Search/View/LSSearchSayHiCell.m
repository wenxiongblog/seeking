//
//  LSSearchSayHiCell.m
//  Project
//
//  Created by XuWen on 2020/6/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSearchSayHiCell.h"
#import "LSSayHiAlertView.h"
#import "CountDownButton.h"
#import "FBShimmeringView.h"
#import "LSGirlZhaoHuHealper.h"
@interface LSSearchSayHiCell()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *zhaohuView;
@property (nonatomic,strong) CountDownButton *countDownButton;
@property (nonatomic,strong) NSArray *zhaohuYujuArray;
@property (nonatomic,strong) FBShimmeringView *shimmeringView; //辉光动画

@property (nonatomic,strong) UIProgressView *progressView;

//计时
@property (nonatomic,assign) int timeindex;
@end

@implementation LSSearchSayHiCell

- (void)MDSayHi_search{};

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)Timered:(NSTimer *)timer
{
    self.timeindex = self.timeindex + 1;
    [self.pickerView selectRow:(self.timeindex%(self.zhaohuYujuArray.count * 50)) inComponent:0 animated:YES];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.contentView xwDrawCornerWithRadiuce:10];
//    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.shimmeringView];
    self.shimmeringView.contentView = self.bgImageView;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.zhaohuView];
}

- (void)SEEKING_baseConstraintsConfig
{
    
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@30);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.zhaohuView.mas_top).offset(-10);
    }];
    [self.zhaohuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XW(300)));
        make.height.equalTo(@40);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.zhaohuYujuArray.count * 50;
}
// 返回pickerView 每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc]init];
    }
    UILabel *label = [[UILabel alloc]init];
    [label commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentCenter];
    label.text = kLanguage(self.zhaohuYujuArray[row%self.zhaohuYujuArray.count]);
    label.numberOfLines = 2;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerView.subviews objectAtIndex:3].backgroundColor = [UIColor clearColor];

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
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 设置列的宽度
    return XW(330);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    // 设置列中的每行的高度
    return 30.0;
}

#pragma mark - setter & getter1
- (UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        UIView *chooseView = [[UIView alloc]init];
        chooseView.backgroundColor = [UIColor clearColor];
        chooseView.userInteractionEnabled = NO;
        [chooseView xwDrawBorderWithColor:[UIColor clearColor] radiuce:5 width:1.5];
        [_pickerView addSubview:chooseView];
        _pickerView.userInteractionEnabled = NO;
        [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pickerView);
            make.height.equalTo(@(50));
            make.width.equalTo(self.pickerView);
        }];
    }
    return _pickerView;
}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,XW(336), XW(185))];
        _bgImageView.image = XWImageName(@"search_sayhi");
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor themeColor] font:FontBold(16) aliment:NSTextAlignmentCenter];
        _titleLabel.text = kLanguage(@"Send messages to get more attention");
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (NSArray *)zhaohuYujuArray
{
    if(!_zhaohuYujuArray){
        _zhaohuYujuArray = [NSArray arrayWithArray:[LSSayHiAlertView zhahuShortYujuArray]];
    }
    return _zhaohuYujuArray;
}

- (UIView *)zhaohuView
{
    if(!_zhaohuView){
        _zhaohuView = [[UIView alloc]init];
        [_zhaohuView xwDrawCornerWithRadiuce:5];
        _zhaohuView.backgroundColor = [UIColor xwColorWithHexString:@"#494949"];
        //进度条
        _progressView = [[UIProgressView alloc]init];
        _progressView.tintColor = [UIColor themeColor];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progress = 1;
        [_zhaohuView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.zhaohuView);
        }];
        //倒计时按钮
//        [_progressView addSubview:self.shimmeringView];
//        self.shimmeringView.contentView = self.countDownButton;
        
        [_zhaohuView addSubview:self.countDownButton];
        [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.zhaohuView);
        }];
        //辉光动画
    }
    return _zhaohuView;
}

- (FBShimmeringView *)shimmeringView
{
    if(!_shimmeringView){
        _shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0,0,XW(336), XW(185))];
        _shimmeringView.shimmering = YES;
    }
    return _shimmeringView;
}

- (CountDownButton *)countDownButton
{
    if(!_countDownButton){
        _countDownButton = [[CountDownButton alloc]init];
        _countDownButton.userInteractionEnabled = YES;
        _countDownButton.showTimeStyle = ShowTimeStyleMinite;
        [_countDownButton commonButtonConfigWithTitle:kLanguage(@"Send") font:FontBold(17) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        kXWWeakSelf(weakself);
        _countDownButton.CountDownProgressBlock = ^(BOOL finished, int progress) {
            weakself.progressView.progress = 1.0 - progress/(5*60.0);
            if(finished){
                weakself.shimmeringView.shimmering = YES;
                weakself.countDownButton.userInteractionEnabled = YES;
                [weakself.countDownButton setTitle:kLanguage(@"Send") forState:UIControlStateNormal];
            }
        };
        
        [_countDownButton setAction:^{
            weakself.shimmeringView.shimmering = NO;
            weakself.progressView.progress = 0;
            [weakself.countDownButton startCountDown:5*60];
            //发送消息
            NSLog(@"发送消息");
            [LSGirlZhaoHuHealper zhaohuWithoutAlert];
            //埋点
            [self MDSayHi_search];
        }];
    }
    return _countDownButton;;
}
@end
