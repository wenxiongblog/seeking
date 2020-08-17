//
//  LSMatchAlertView.m
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMatchAlertView.h"
#import "LSRYChatViewController.h"
#import "LSMatchMsgCell.h"
#import "LSRongYunHelper.h"
#import "LSMessageSendView.h"

@interface LSMatchAlertView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UIImageView *taImageView;

@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextField *textFiled;
@property (nonatomic,strong) UIButton *sendButton;

//数据
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LSMatchAlertView

-  (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
     CGRect keyboredBeginFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboredEndFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        CGFloat yDistance = fabs(keyboredBeginFrame.origin.y - keyboredEndFrame.origin.y);
        if (!floor(yDistance)) {
            return;
        }
        //键盘弹出或变化
        if (keyboredBeginFrame.origin.y > keyboredEndFrame.origin.y || (keyboredBeginFrame.size.height != yDistance)) {
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-10-keyboredEndFrame.size.height);
            }];
        }else{
        //键盘收回
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-kSafeAreaBottomHeight-35);
            }];
        }
        
    } completion:nil];
    
}

- (void)disappearAnimation
{
    [super disappearAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.placeView addSubview:self.contentView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSMatchMsgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSMatchMsgCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    kXWWeakSelf(weakself);
    cell.sendBlock = ^(NSString * _Nullable msg) {
        NSLog(@"发送消息:%@",msg);
        [LSRongYunHelper matchsendMessage:msg customer:weakself.customer finish:^(BOOL isFinish) {
            [LSMessageSendView showWithCustomer:weakself.customer];
            [weakself disappearAnimation];
        }];
    };
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.titleArray[indexPath.row];
    CGFloat fontWidth = [title sizeWithAttributes:@{NSFontAttributeName:FontMediun(17)}].width;
    return CGSizeMake(fontWidth+94, 50);
}
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 18;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - setter & getter1
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSMatchMsgCell class] forCellWithReuseIdentifier:kLSMatchMsgCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView xwDrawCornerWithRadiuce:10];
        
        //图像
        [_contentView addSubview:self.taImageView];
        [self.taImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        //上下阴影
        UIImageView *topShadowView = [[UIImageView alloc]initWithImage:XWImageName(@"macth_shadow_top")];
        UIImageView *bottomShadowView = [[UIImageView alloc]initWithImage:XWImageName(@"macth_shadow_bottom")];
        [_contentView addSubview:topShadowView];
        [_contentView addSubview:bottomShadowView];
        [topShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@(123+kTabbarHeight));
        }];
        [bottomShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@(XW(150)+kSafeAreaBottomHeight));
        }];
        //关闭按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:XWImageName(@"closeButton_white") forState:UIControlStateNormal];
        [_contentView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(kStatusBarHeight);
            make.width.height.equalTo(@30);
        }];
        kXWWeakSelf(weakself);
        [closeButton setAction:^{
            [weakself disappearAnimation];
        }];
        //It's a match
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"It’s a Match!"))];
        [_contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@174);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(closeButton.mas_bottom);
        }];
        //输入框
        UIView *inputView = [[UIView alloc]init];
        inputView.backgroundColor = [UIColor whiteColor];
        self.inputView = inputView;
        [inputView xwDrawCornerWithRadiuce:25];
        [_contentView addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
            make.bottom.equalTo(_contentView).offset(-kSafeAreaBottomHeight-35);
        }];
        [inputView addSubview:self.textFiled];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(inputView).offset(25);
            make.top.bottom.equalTo(inputView);
            make.right.equalTo(inputView).offset(-50);
        }];
        [inputView addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(inputView).offset(-15);
            make.centerY.equalTo(inputView);
            make.width.height.equalTo(@34);
        }];
        
        //collectionView
        [_contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(inputView.mas_top).offset(-15);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
        
    }
    return _contentView;
}

- (UIImageView *)taImageView
{
    if(!_taImageView){
        _taImageView = [[UIImageView alloc]init];
        _taImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _taImageView;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    [self.taImageView sd_setImageWithURL:[NSURL URLWithString:customer.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
}

- (UITextField *)textFiled
{
    if(!_textFiled){
        _textFiled = [[UITextField alloc]init];
        _textFiled.placeholder = @"or write something...";
        _textFiled.font = FontMediun(17);
        _textFiled.textColor = [UIColor projectMainTextColor];
        [_textFiled addTarget:self action:@selector(textfiledChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFiled;
}

- (void)textfiledChanged:(UITextField *)sender
{
    self.sendButton.hidden = sender.text.trim.length == 0;
}

- (UIButton *)sendButton
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:XWImageName(@"match_send") forState:UIControlStateNormal];
        _sendButton.hidden = YES;
        kXWWeakSelf(weakself);
        [_sendButton setAction:^{
            [LSRongYunHelper matchsendMessage:weakself.textFiled.text customer:weakself.customer finish:^(BOOL isFinish) {
                [LSMessageSendView showWithCustomer:weakself.customer];
                [weakself disappearAnimation];
            }];
        }];
    }
    return _sendButton;
}

- (NSArray *)titleArray
{
    if(!_titleArray){
        _titleArray = @[@"Hi",@"Hello",@"Are you ready for a hot Latte rn？"];
    }
    return _titleArray;
}


@end
