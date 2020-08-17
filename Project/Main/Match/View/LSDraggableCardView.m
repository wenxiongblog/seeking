//
//  LSDraggableCardView.m
//  Project
//
//  Created by XuWen on 2020/1/22.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDraggableCardView.h"
#import "LSPictureScrollView.h"
#import "LSUploadPhotoVC.h"

@interface LSDraggableCardView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *preButton; //隐形上一张
@property (nonatomic,strong) UIButton *nextButton; //隐形下一张
@property (nonatomic,strong) UIButton *detailButton; //隐形详情
@property (nonatomic,strong) LSPictureScrollView *pictureView; //ScrollView
@property (nonatomic,strong) UIButton *uploadButton; //上传照片点击
@property (nonatomic,strong) NSMutableArray *pageIndexArray;

//个人信息
@property (nonatomic,strong) UIImageView *infoView;  //个人信息
@property (nonatomic,strong) UILabel *vipLabel; //VIPlabel
@property (nonatomic,strong) UILabel *nameLabel;   //个人姓名
@property (nonatomic,strong)UIImageView *vipImageView; //vipImageVeiw;

@property (nonatomic,strong) UIImageView *ne24ImageView; //new标签
@property (nonatomic,strong) UIImageView *onlineImageView; //在线标签

//滑动页面
@property (nonatomic,strong) UIView *pageView;

//相册数量
@property (nonatomic,strong) UIView *imageCountView;
@property (nonatomic,strong) UILabel *imageCountLabel;
@property (nonatomic,strong) UIImageView *imageCountImage;

//是否是
@property (nonatomic,strong) UIImageView *likeImageView;
@property (nonatomic,strong) UIImageView *dislikeImageView;
@property (nonatomic,strong) UIView *colorChangeView;

//当前页码
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation LSDraggableCardView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //上一张，下一张
        UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        preButton.backgroundColor = [UIColor clearColor];
        self.preButton = preButton;
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.backgroundColor = [UIColor clearColor];
        self.nextButton = nextButton;
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.backgroundColor = [UIColor clearColor];
        self.detailButton = detailButton;
        //上传照片button
        self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.uploadButton.hidden = YES;
        kXWWeakSelf(weakself);
        [self.uploadButton setAction:^{
            NSLog(@"隐形上传照片点击");
            NSArray *array = nil;
            if(kUser.imageslist.length > 10){
                [kUser.imageslist componentsSeparatedByString:@","];
            }
            if(array.count < 2){
                LSUploadPhotoVC *vc = [[LSUploadPhotoVC alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.modalPresentationStyle = 0;
                [weakself.eventVC presentViewController:nav animated:YES
                                     completion:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:kNOtification_ImageGreateThan3 object:nil];
            }
        }];
        
        [self addSubview:preButton];
        [self addSubview:nextButton];
        [self addSubview:detailButton];
        [self addSubview:self.uploadButton];
        [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.right.equalTo(self.mas_centerX);
            make.bottom.equalTo(detailButton.mas_top);
        }];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.left.equalTo(self.mas_centerX);
            make.bottom.equalTo(detailButton.mas_top);
        }];
        [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(XW(230)));
        }];
        [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@246);
            make.height.equalTo(@52);
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(70);
        }];
        [preButton setAction:^{
            [weakself scrollToPage:self.currentPage-1];
        }];
        [nextButton setAction:^{
            [weakself scrollToPage:self.currentPage+1];
        }];
        [detailButton setAction:^{
            if(self.detailBlock){
                self.detailBlock(self.customer);
            }
        }];
        
        //添加控件
        [self addSubview:self.pictureView];
        [self addSubview:self.infoView];
        [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(XW(170)));
        }];
        
        //topShadow
        UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:XWImageName(@"macth_shadow_top")];
        [self addSubview:shadowImageView];
        [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(123));
        }];
        
        //honey
        UIImageView *iconImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"macth_Honeyicon"))];
        [self addSubview:iconImageView];
        iconImageView.hidden = YES;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@52);
            make.height.equalTo(@24);
            make.left.equalTo(self).offset(24);
            make.top.equalTo(self).offset(kStatusBarHeight);
        }];
        
        //颜色改变
        [self addSubview:self.colorChangeView];
        [self.colorChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //显示喜欢和不喜欢的按钮
        [self addSubview:self.likeImageView];
        [self addSubview:self.dislikeImageView];
        [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(95)));
            make.height.equalTo(@(XW(50)));
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
        [self.dislikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(95)));
            make.height.equalTo(@(XW(50)));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
    }
    //通知上传照片超过了3张
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadImagemorethan3) name:kNOtification_ImageGreateThan3 object:nil];
    
    return self;
}

- (void)uploadImagemorethan3
{
    self.uploadButton.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - private
- (void)scrollToPage:(NSInteger)page
{
    if(page>=0 || page < self.pageIndexArray.count){
        [self.pictureView scrollToPage:page];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    self.currentPage = x/kSCREEN_WIDTH;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    self.currentPage = x/kSCREEN_WIDTH;
    for(UIView *view in self.pageIndexArray){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    UIView *view = self.pageIndexArray[self.currentPage];
    view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - baseConfig1


#pragma mark - setter & getter1


- (UIImageView *)infoView
{
    if(!_infoView){
        _infoView = [[UIImageView alloc]init];
        _infoView.image = XWImageName(@"macth_shadow_bottom");
        [_infoView addSubview:self.nameLabel];
        [_infoView addSubview:self.vipImageView];
        [_infoView addSubview:self.imageCountView];
        [_infoView addSubview:self.pageView];
        [_infoView addSubview:self.vipLabel];
        
        [_infoView addSubview:self.onlineImageView];
        [_infoView addSubview:self.ne24ImageView];
        
        [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.nameLabel);
            make.left.equalTo(self.infoView).offset(16);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(16);
            make.top.equalTo(self.infoView);
        }];
        [self.imageCountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(16);
            make.width.equalTo(@50);
            make.height.equalTo(@27);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
        [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(65));
            make.height.equalTo(@27.5);
            make.centerY.equalTo(self.imageCountView);
            make.left.equalTo(self.imageCountView.mas_right).offset(10);
        }];
        [self.ne24ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(57));
            make.height.equalTo(@27.5);
            make.centerY.equalTo(self.imageCountView);
            make.left.equalTo(self.onlineImageView.mas_right).offset(10);
        }];
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.infoView).offset(-kTabbarHeight-30);
            make.left.right.equalTo(self.infoView);
            make.height.equalTo(@4);
        }];
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@27.5);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.nameLabel);
        }];
    }
    return _infoView;
}

- (UILabel *)vipLabel
{
    if(!_vipLabel){
        _vipLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(14) aliment:NSTextAlignmentCenter];
        _vipLabel.text = @"V";
        _vipLabel.backgroundColor = [UIColor themeColor];
        [_vipLabel xwDrawCornerWithRadiuce:3];
    }
    return _vipLabel;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(24) aliment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UIImageView *)vipImageView
{
    if(!_vipImageView){
        _vipImageView = [[UIImageView alloc]initWithImage:XWImageName(@"huangguan")];
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}


- (UIImageView *)likeImageView
{
    if(!_likeImageView){
        _likeImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"likes"))];
        _likeImageView.alpha = 0.0;
    }
    return _likeImageView;
}

- (UIImageView *)dislikeImageView
{
    if(!_dislikeImageView){
        _dislikeImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"dislikes"))];
        _dislikeImageView.alpha = 0.0;
    }
    return _dislikeImageView;
}

- (void)likeButtonAlpha:(CGFloat)alpha
{
    if(alpha>0.0){
        //喜欢
        self.colorChangeView.backgroundColor = [UIColor purpleColor];
        self.colorChangeView.alpha = alpha/1.5;
        self.dislikeImageView.alpha = 0.0;
        self.likeImageView.alpha = 1.0;
    }else if(alpha < 0.0){
        //不喜欢
        self.colorChangeView.backgroundColor = [UIColor yellowColor];
        self.colorChangeView.alpha = -alpha/1.5;
        self.dislikeImageView.alpha = 1.0;
        self.likeImageView.alpha = 0.0;
    }else{
        self.dislikeImageView.alpha = 0.0;
        self.likeImageView.alpha = 0.0;
        self.colorChangeView.alpha = 0.0;
    }
}

- (void)configImages:(NSArray *)imageList
{
    //pages
    if(imageList.count <= 1){
        self.pageView.hidden = YES;
    }
    self.pageView.hidden = NO;
    CGFloat edge = 15;
    CGFloat space = 10;
    CGFloat width = (kSCREEN_WIDTH-edge*2-(imageList.count-1)*space)/imageList.count;
    self.pageIndexArray = [NSMutableArray array];
    for(int i = 0; i<imageList.count; i++){
        UIView *indexView = [[UIView alloc]initWithFrame:CGRectMake(edge+i*(space + width), 0, width, 3)];
        if(i == 0){
            indexView.backgroundColor = [UIColor whiteColor];
        }else{
            indexView.backgroundColor = [UIColor lightGrayColor];
        }
        [self.pageView addSubview:indexView];
        [indexView xwDrawCornerWithRadiuce:1.5];
        [self.pageIndexArray addObject:indexView];
    }
}

- (UIView *)colorChangeView
{
    if(!_colorChangeView){
        _colorChangeView = [[UIView alloc]init];
        _colorChangeView.alpha = 0;
    }
    return _colorChangeView;
}

- (UIView *)pageView
{
    if(!_pageView){
        _pageView = [[UIView alloc]init];
    }
    return _pageView;
}

- (UIView *)imageCountView
{
    if(!_imageCountView){
        _imageCountView = [[UIView alloc]init];
        _imageCountView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_imageCountView xwDrawCornerWithRadiuce:5];
        
        self.imageCountImage = [[UIImageView alloc]initWithImage:XWImageName(@"相机")];
        [_imageCountView addSubview:self.imageCountImage];
        [self.imageCountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@16);
            make.centerY.equalTo(self.imageCountView);
            make.right.equalTo(self.imageCountView).offset(-7.5);
        }];
        
        self.imageCountLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(12) aliment:NSTextAlignmentCenter];
        self.imageCountLabel.text = @"1";
        [_imageCountView addSubview:self.imageCountLabel];
        [self.imageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageCountView);
            make.left.equalTo(self.imageCountView).offset(0);
            make.right.equalTo(self.imageCountImage.mas_left);
        }];
    }
    return _imageCountView;
}


- (UIImageView *)onlineImageView
{
    if(!_onlineImageView){
        _onlineImageView = [[UIImageView alloc]initWithImage:XWImageName(kLanguage(@"match_Online"))];
    }
    return _onlineImageView;
}
- (UIImageView *)ne24ImageView
{
    if(!_ne24ImageView){
        _ne24ImageView = [[UIImageView alloc]initWithImage:XWImageName(@"match_new")];
    }
    return _ne24ImageView;
}

- (LSPictureScrollView *)pictureView
{
    if(!_pictureView){
        _pictureView = [[LSPictureScrollView alloc]init];
        _pictureView.userInteractionEnabled = NO;
        kXWWeakSelf(weakself);
        _pictureView.ScrollToPageBlock = ^(NSInteger page) {
            weakself.currentPage = page;
            
            for(UIView *view in weakself.pageIndexArray){
                view.backgroundColor = [UIColor lightGrayColor];
            }
            UIView *view = weakself.pageIndexArray[weakself.currentPage];
            view.backgroundColor = [UIColor whiteColor];
            
            //是否可以点击上传照片按钮
            // 如果是第2张图片以上，并且个人相册少于两张，就需要上传。
//            NSArray *array = [kUser.imageslist componentsSeparatedByString:@","];
            NSArray *array = nil;
            if(kUser.imageslist.length > 10){
                [kUser.imageslist componentsSeparatedByString:@","];
            }
            if(page>=2 && array.count < 2){
                weakself.uploadButton.hidden = NO;
            }else{
                weakself.uploadButton.hidden = YES;
            }
            
        };
    }
    return _pictureView;
}

- (void)setCustomer:(SEEKING_Customer *)customer
{
    _customer = customer;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@,%d",[customer.name filter],customer.age];
    NSArray *images = nil;
    if(customer.imageslist.length > 10){
       images = [customer.imageslist componentsSeparatedByString:@","];
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    if(customer.images != nil){
        [mutableArray addObject:customer.images];
    }
    [mutableArray addObjectsFromArray:images];
    if(mutableArray.count > 0){
        self.pictureView.imageArray = [NSArray arrayWithArray:mutableArray];
        [self configImages:mutableArray];
    }
    
    self.imageCountLabel.text = [NSString stringWithFormat:@"%ld",mutableArray.count];
    
    //判断是否是会员
    if(customer.isVIPCustomer){
        self.vipLabel.hidden = NO;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(46);
        }];
    }else{
        self.vipLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(16);
        }];
    }
    
    //隐藏
    self.pageView.hidden = mutableArray.count <=1;
    
    if(!customer.isOnline){
        self.onlineImageView.hidden = NO;
        
        NSLog(@"%@",customer.creattime);

        NSDate *creatTimedate = [NSDate dateWithString:customer.creattime];
        //是否是新用户
        if([NSDate judgeisNews24HoursDate:creatTimedate]){
            self.ne24ImageView.hidden = NO;
            [self.ne24ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.onlineImageView.mas_right).offset(10);
            }];
        }else{
            self.ne24ImageView.hidden = YES;
        }
        
    }else{
        self.onlineImageView.hidden = YES;
        
        //是否是新用户
         NSDate *creatTimedate = [NSDate dateWithString:customer.creattime];
        if([NSDate judgeisNews24HoursDate:creatTimedate]){
            self.ne24ImageView.hidden = NO;
            [self.ne24ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageCountView.mas_right).offset(10);
            }];
        }else{
            self.ne24ImageView.hidden = YES;
        }
    }
    
    self.vipImageView.highlighted = !customer.isVIPCustomer;
}

@end
