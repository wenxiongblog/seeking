//
//  LSSayHiAlertView.m
//  Project
//
//  Created by XuWen on 2020/3/1.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSSayHiAlertView.h"

@interface LSSayHiAlertView()

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UISlider *slider;
@end

@implementation LSSayHiAlertView

- (void)MDSayHiOK{}
- (void)MDSayHiFailed{}
- (void)MDSayHi{}

-  (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self MDSayHi];
    [self.placeView addSubview:self.contentView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@335);
        make.height.equalTo(@(375-140+XW(140)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kTabbarHeight);
    }];
}

#pragma mark - setter & gette
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:30];
        
        //title
        UILabel *titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontBold(36) aliment:NSTextAlignmentCenter];
        titleLabel.text = kLanguage(@"Say ”Hi”");
        [_contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(13);
        }];
        
        //ImageView 隐藏掉
        UIImageView *myImageView = [[UIImageView alloc]init];
        [myImageView sd_setImageWithURL:[NSURL URLWithString:kUser.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
        myImageView.contentMode = UIViewContentModeScaleAspectFill;
        [myImageView xwDrawBorderWithColor:[UIColor whiteColor] radiuce:XW(36) width:2];
        [_contentView addSubview:myImageView];
        [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(XW(72)));
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self.contentView);
        }];
        
        //滑块
        [_contentView addSubview:self.slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(myImageView.mas_bottom).offset(30);
            make.height.equalTo(@30);
            make.width.equalTo(@(300));
        }];
        UILabel *minLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontMediun(18) aliment:NSTextAlignmentCenter];
        minLabel.text = @"5";
        UILabel *maxLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:FontMediun(18) aliment:NSTextAlignmentCenter];
        maxLabel.text = @"20";
        [_contentView addSubview:minLabel];
        [_contentView addSubview:maxLabel];
        [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.slider.mas_left).offset(5);
            make.top.equalTo(self.slider.mas_bottom);
        }];
        [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.slider.mas_right).offset(-5);
            make.top.equalTo(self.slider.mas_bottom);
        }];

        //subtitle
          UILabel *subtitle = [UILabel createCommonLabelConfigWithTextColor:[UIColor lightGrayColor] font:FontBold(15) aliment:NSTextAlignmentCenter];
          subtitle.text = kLanguage(@"Select the number of people\nyou want to greet");
          subtitle.numberOfLines = 2;
          [_contentView addSubview:subtitle];
          [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerX.equalTo(self.contentView);
              make.top.equalTo(self.slider.mas_bottom).offset(30);
          }];
        
        //button
        UIButton *messageButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Send") font:FontBold(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        messageButton.backgroundColor = [UIColor themeColor];
        [messageButton xwDrawCornerWithRadiuce:5];
        [self.contentView addSubview:messageButton];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.equalTo(@(300));
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-25);
        }];
        kXWWeakSelf(weakself);
        [messageButton setAction:^{
            [weakself MDSayHiOK];
            [weakself disappearAnimation];
            if(self.dazhaohuBlock){
                int count = (int)weakself.slider.value;
                weakself.dazhaohuBlock(YES,count);
            }
        }];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:XWImageName(@"sayhiclose") forState:UIControlStateNormal];
        [self.contentView addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        [playButton setAction:^{
            [weakself MDSayHiFailed];
            [weakself disappearAnimation];
        }];
        
    }
    return _contentView;
}

- (UISlider *)slider
{
    if(!_slider){
        _slider = [[UISlider alloc]init];
        _slider.minimumValue = 5;
        _slider.maximumValue = 20;
        _slider.value = 12.5;
        _slider.tintColor = [UIColor themeColor];
        _slider.thumbTintColor = [UIColor themeColor];
    }
    return _slider;
}

+ (NSArray *)zhahuShortYujuArray
{
    return @[
       @"How are you doing?💖",
       @"What's up?",
       @"Hi. Long time no see.💗",
       @"How about yourself?",
       @"Today is a great day.",
       @"Are you making progress?",
       @"May I have your name, please?😄",
       @"I've heard so much about you.",
       @"I hope you're enjoying your staying here.",
       @"I'm glad to have met you.❤️",
       @"Keep in touch.",
       @"I had a wonderful time here.😊",
       @"Nice talking to you.",
       @"I feel terrible.😭",
       @"What do you do?",
       @"I like reading and listening to music.",
       @"What's wrong?",
       @"What happened?",
       @"I hope nothing is wrong.",
       @"I know how you feel.",
       @"I like your style.",
       @"How do I look?",
       @"You look great!😍",
       @"Are you married or single?",
       @"I've been dying to see you.",
       @"I'm tired of working all day.",
       @"It's a small world.",
       @"May I help you?",
       @"What a surprise!",
       @"I need some sleep🍌",
       @"Take it easy🍌",
       @"Just relax🍌",
       @"May I join in? I’m easy to get along. ",
       @"Which city do you live in",
       @"You are a bucket of awesome",
       @"What was the coolest girl you ever met",
       @"Romance or passion?",
       @"What would you tell your younger self?",
       @"How's your day?",
       @"Two truths and a lie. Ready, set, go!",
       @"You have free time. What will you do?",
       @"What's your biggest passion?",
       @"Cats or dogs?",
       ];
}


+ (NSString *)zhaohuYuju
{
    NSArray *array = [self zhahuShortYujuArray];
    int x = arc4random() % array.count;
    NSString *str = array[x];
    return kLanguage(str);
}
@end
