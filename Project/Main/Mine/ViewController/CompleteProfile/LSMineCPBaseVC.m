//
//  LSMineCPBaseVC.m
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineCPBaseVC.h"
#import "LSMineProfileChooseCell.h"
#import <UITextView+Placeholder.h>

#define kCellWidth (kSCREEN_WIDTH-40-15*2-11)/2.0
#define kCellHeight 50


@interface LSMineCPBaseVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *backBtn; //back
@property (nonatomic,strong) UILabel *numberLabel; //number
@property (nonatomic,strong) UIButton *skipButton; //skip
@property (nonatomic,strong) UILabel *titleLabel; //标题

@property (nonatomic,strong) UIView *inputView;  //输入模式
@property (nonatomic,strong) UITextView *textView; //
@property (nonatomic,strong) UIButton *nextButton; //下一步

@property (nonatomic,strong) UICollectionView *collectionView; //选择模式
//

@end

@implementation LSMineCPBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SEEKING_baseUIConfig];
    [self baseConstrainsConfig];
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor xwColorWithHexString:@"#4B75EC"];
    [self.view addSubview:self.closeButton];
    
    UILabel *label = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
    label.text = kLanguage(@"Complete profile");
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeButton);
        make.centerX.equalTo(self.view);
    }];
    //contentView
    [self.view addSubview:self.contentView];
}

- (void)baseConstrainsConfig
{
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.equalTo(self.view).offset(15);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight-80);
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
    LSMineProfileChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLSMineProfileChooseCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.isChoosed = [cell.title isEqualToString:self.value];
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((!_isSingleLine)?kCellWidth:(kSCREEN_WIDTH-40-15*2), kCellHeight);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = self.titleArray[indexPath.row];
    if(self.nextBlock){
        self.nextBlock(NO, self.key,title);
    }
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
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSMineProfileChooseCell class] forCellWithReuseIdentifier:kLSMineProfileChooseCellIdentifier];
    }
    return _collectionView;
}
- (UIButton *)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage: XWImageName(@"Mine_complete_close") forState:UIControlStateNormal];
        kXWWeakSelf(weakself);
        [_closeButton setAction:^{
            if(weakself.closeBlock){
                weakself.closeBlock(YES);
            }
        }];
    }
    return _closeButton;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView xwDrawCornerWithRadiuce:5];
        //
        [_contentView addSubview:self.backBtn];
        [_contentView addSubview:self.skipButton];
        [_contentView addSubview:self.numberLabel];
        [_contentView addSubview:self.titleLabel];
        
        //
        [_contentView addSubview:self.inputView];
        //
        //collectionView
        [_contentView addSubview:self.collectionView];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@50);
            make.height.equalTo(@30);
        }];
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@30);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.skipButton);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.numberLabel.mas_bottom).offset(30);
        }];
        
        [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.nextButton.mas_bottom);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return _contentView;
}

- (UIButton *)backBtn
{
    if(!_backBtn){
        _backBtn = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Back") font:FontMediun(18) titleColor:[UIColor xwColorWithHexString:@"#828282"] aliment:UIControlContentHorizontalAlignmentLeft];
        kXWWeakSelf(weakself);
        [_backBtn setAction:^{
            if(weakself.backBlock){
                weakself.backBlock(YES,weakself.key);
            }
        }];
    }
    return _backBtn;
}

- (UIButton *)skipButton
{
    if(!_skipButton){
        _skipButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Skip") font:FontMediun(18) titleColor:[UIColor xwColorWithHexString:@"#828282"] aliment:UIControlContentHorizontalAlignmentRight];
        kXWWeakSelf(weakself);
        [_skipButton setAction:^{
            if(weakself.nextBlock){
                weakself.nextBlock(YES, weakself.key, @"");
            }
        }];
    }
    return _skipButton;
}

- (UILabel *)numberLabel
{
    if(!_numberLabel){
        _numberLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(18) aliment:NSTextAlignmentCenter];
        _numberLabel.text = @"0/11";
    }
    return _numberLabel;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontMediun(18) aliment:NSTextAlignmentCenter];
        _titleLabel.text = @"Tell us a little about yourself";
    }
    return _titleLabel;
}

- (UIView *)inputView
{
    if(!_inputView){
        _inputView = [[UIView alloc]init];
        _inputView.hidden = YES;
        
        [_inputView addSubview:self.textView];
        [_inputView addSubview:self.nextButton];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputView);
            make.left.equalTo(self.inputView).offset(13);
            make.right.equalTo(self.inputView).offset(-13);
            make.height.equalTo(@155);
        }];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.textView);
            make.top.equalTo(self.textView.mas_bottom).offset(30);
            make.height.equalTo(@50);
        }];
    }
    return _inputView;
}

- (UITextView *)textView
{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor projectBlueColor];
        [_textView xwDrawCornerWithRadiuce:5];
        _textView.placeholderColor = [UIColor lightGrayColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = FontMediun(15);
    }
    return _textView;
}

- (UIButton *)nextButton
{
    if(!_nextButton){
        _nextButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"NEXT") font:FontMediun(18) titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_nextButton xwDrawCornerWithRadiuce:5];
        _nextButton.backgroundColor = [UIColor themeColor];
        kXWWeakSelf(weakself);
        [_nextButton setAction:^{
            if(weakself.nextBlock){
                weakself.nextBlock(NO, weakself.key, weakself.textView.text);
            }
        }];
    }
    return _nextButton;
}

- (NSArray *)titleArray
{
    if(!_titleArray){
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

#pragma mark - 配置
- (void)setType:(LSMineProfieType)type
{
    _type = type;
    self.collectionView.hidden = type != LSMineProfieTypeChoose;
    self.inputView.hidden = type == LSMineProfieTypeChoose;
}

- (void)setProfileTitle:(NSString *)profileTitle
{
    _profileTitle = profileTitle;
    self.titleLabel.text = profileTitle;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textView.placeholder = kLanguage(placeholder);
}

- (void)setNumber:(NSString *)number
{
    _number = number;
    self.numberLabel.text = number;
}

- (void)setHiddenBack:(BOOL)hiddenBack
{
    _hiddenBack = hiddenBack;
    self.backBtn.hidden = hiddenBack;
}

- (void)setIsSingleLine:(BOOL)isSingleLine
{
    _isSingleLine = isSingleLine;
    [self.collectionView reloadData];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    if(self.type == LSMineProfieTypeChoose){
        [self.collectionView reloadData];
    }else{
        self.textView.text = value;
    }
}

@end
