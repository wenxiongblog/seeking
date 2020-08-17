//
//  LSMineEditVC.m
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineEditVC.h"
#import "LSPhotoEditView.h"
#import "LSChooseAlertView.h"
#import "LSChooseHWeightView.h"
#import "LSChooseWightView.h"
#import <objc/runtime.h>

@interface LSMineEditVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) LSPhotoEditView *photoEditView;

@property (nonatomic,strong) UITextField *userNameTextField; //姓名
@property (nonatomic,strong) UITextView *aboutMeTextView;  //about Me


@property (nonatomic,strong) NSMutableArray <LSMineEditModel *>*dataArray;

//编辑中的userModel
@property (nonatomic,strong) SEEKING_UserModel *editUserModel;
//是否编辑过
@property (nonatomic,assign) BOOL isEdited;
@end

@implementation LSMineEditVC

//埋点
- (void)MDUploadPhoto{};


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editUserModel = [kUser copy];
    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self speciceNavWithTitle:kLanguage(@"Edit Profile")];
    kXWWeakSelf(weakself);
    [self addRightItemWithString:kLanguage(@"Done") clickBlock:^{
        //保存，更新用户信息
        [weakself saveInfo];
    }];
    [self.view addSubview:self.mainTableView];
}

- (void)baseConstriantsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}

#pragma mark - saveInfo
- (void)saveInfo
{
    //头像
    if(self.photoEditView.isEdit){
        [self MDUploadPhoto];
        self.isEdited = YES;
        kUser.images = self.photoEditView.headImagesURL;
        NSMutableString *str = [NSMutableString string];
        for(int i = 0 ;i<self.photoEditView.imageUrlArray.count;i++){
            NSString *urlStr = self.photoEditView.imageUrlArray[i];
            if(i!=0){
               [str appendString:@","];
            }
            [str appendString:urlStr];
        }
        kUser.imageslist = str;
    }
    //姓名
    if(![kUser.name isEqualToString:self.editUserModel.name]){
        if(self.editUserModel.name.length == 0){
            [AlertView toast:@"Username is empty" inView:self.view];
            return;
        }
        self.isEdited = YES;
        kUser.name = self.editUserModel.name;
    }
    //about
    NSLog(@"%@",kUser.about);
    if(![kUser.about isEqualToString:self.editUserModel.about]){
        if(self.editUserModel.name.length == 0){
            self.editUserModel.about = @" ";
        }
        self.isEdited = YES;
        kUser.about = self.editUserModel.about;
    }
    //heigth
    if(![kUser.height isEqualToString:self.editUserModel.height]){
        self.isEdited = YES;
        kUser.height = self.editUserModel.height;
    }
    //体重
    if(![kUser.weight isEqualToString:self.editUserModel.weight]){
        self.isEdited = YES;
        kUser.weight = self.editUserModel.weight;
    }
    //relationship
    if(![kUser.relationship isEqualToString:self.editUserModel.relationship]){
        self.isEdited = YES;
        kUser.relationship = self.editUserModel.relationship;
    }
    //needfriendsfor
    if(![kUser.needfor isEqualToString:self.editUserModel.needfor]){
        self.isEdited = YES;
        kUser.needfor = self.editUserModel.needfor;
    }
    //looking for age
    if(![kUser.lookingforage isEqualToString:self.editUserModel.lookingforage]){
        self.isEdited = YES;
        kUser.lookingforage= self.editUserModel.lookingforage;
    }
    //interested
    if(![kUser.interested isEqualToString:self.editUserModel.interested]){
        self.isEdited = YES;
        kUser.interested= self.editUserModel.interested;
    }
    //education
    if(![kUser.school isEqualToString:self.editUserModel.school]){
        self.isEdited = YES;
        kUser.school = self.editUserModel.school;
    }
    //job
    if(![kUser.job isEqualToString:self.editUserModel.job]){
        self.isEdited = YES;
        kUser.job = self.editUserModel.job;
    }
    //kid
    if(![kUser.kid isEqualToString:self.editUserModel.kid]){
        self.isEdited = YES;
        kUser.kid = self.editUserModel.kid;
    }
    //pets
    if(![kUser.pet isEqualToString:self.editUserModel.pet]){
        self.isEdited = YES;
        kUser.pet = self.editUserModel.pet;
    }
    //belief
    if(![kUser.belief isEqualToString:self.editUserModel.belief]){
        self.isEdited = YES;
        kUser.belief = self.editUserModel.belief;
    }
    //body type
    if(![kUser.bodyType isEqualToString:self.editUserModel.bodyType]){
        self.isEdited = YES;
        kUser.bodyType = self.editUserModel.bodyType;
    }
    //drinding
    if(![kUser.drinking isEqualToString:self.editUserModel.drinking]){
        self.isEdited = YES;
        kUser.drinking = self.editUserModel.drinking;
    }
    //smoking
    if(![kUser.smoking isEqualToString:self.editUserModel.smoking]){
        self.isEdited = YES;
        kUser.smoking = self.editUserModel.smoking;
    }
    //diet
    if(![kUser.diet isEqualToString:self.editUserModel.diet]){
        self.isEdited = YES;
        kUser.diet = self.editUserModel.diet;
    }
    
    if(self.isEdited == NO){
        //没有编辑过
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    kXWWeakSelf(weakself);
    [self updateUserInfo:^(BOOL finished) {
        if(finished){
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
//            [AlertView ]
            NSLog(@"编辑失败");
        }
    }];
}

#pragma mark - event
- (void)nameChangeed:(UITextField *)textField
{
    self.isEdited = YES;
    self.editUserModel.name = textField.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.isEdited = YES;
    self.editUserModel.about = textView.text;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LSMineEditModel *model = self.dataArray[section];
    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMyEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kLSMyEditCellIdentifier forIndexPath:indexPath];
    LSMineEditModel *model = self.dataArray[indexPath.section];
    NSString *title = model.content[indexPath.row];
    cell.type = model.type;
    cell.name = title;
    cell.key = model.key;
    kXWWeakSelf(weakself);
    cell.changeBlock = ^(NSString * _Nonnull key, NSString * _Nullable changeText) {
        //runtime赋值 注意(__bridge void *)
        NSLog(@"%@",changeText);
        if([key isEqualToString:@"name"]){
            weakself.editUserModel.name = changeText;
        }else if([key isEqualToString:@"about"]){
            weakself.editUserModel.about = changeText;
        }else if([key isEqualToString:@"school"]){
            weakself.editUserModel.school = changeText;
        }else if([key isEqualToString:@"job"]){
            weakself.editUserModel.job = changeText;
        }else if([key isEqualToString:@"belief"]){
            weakself.editUserModel.belief =  changeText;
        }
    };
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMineEditModel *model = self.dataArray[indexPath.section];
    if(model.type == LSMyEditCellType_textView){
        return 130.;
    }else{
      return 55.;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *userView = [[UIView alloc]init];
    UILabel *usernameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#BFBFBF"] font:Font(15) aliment:NSTextAlignmentLeft];
    LSMineEditModel *model = self.dataArray[section];
    usernameLabel.text = model.title;
    [userView addSubview:usernameLabel];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView).offset(16);
        make.bottom.equalTo(userView).offset(-10);
    }];
    return userView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    kXWWeakSelf(weakself);
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            //身高
            [LSChooseHWeightView showHeight:[self.editUserModel.height floatValue] select:^(NSString * _Nonnull title) {
                weakself.editUserModel.height = title;
                [weakself.mainTableView reloadData];
            }];
        }else if(indexPath.row == 1){
            //体重
            [LSChooseWightView showWight:[self.editUserModel.weight floatValue] select:^(NSString * _Nonnull title) {
               weakself.editUserModel.weight = title;
                [weakself.mainTableView reloadData];
            }];
        }else if(indexPath.row == 2){
            //情感关系
            [LSChooseAlertView showWithTileArray:@[@"Unmarried",@"Married",@"Divorced",@"In a relationship",@"Secret"] select:^(NSString * _Nonnull title) {
                weakself.editUserModel.relationship = title;
                [weakself.mainTableView reloadData];
            }];
        }
    }else if(indexPath.section == 3){
        //looking for
        [LSChooseAlertView showWithTileArray:@[@"Short-term",@"Long-term",@"Friends"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.needfor = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 4){
        //年龄区间
        [LSChooseAlertView showWithTileArray:@[@"18-30",@"30+",] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.lookingforage = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 5){
        //兴趣爱好
        [LSChooseAlertView showWithTileArray:@[@"Party",@"Sports",@"Traveling",@"Chat"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.interested = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 8){
        //kids
        [LSChooseAlertView showWithTileArray:@[@"I have no kids",@"I don't want kids",@"I already have kids",@"Not ready for kids",@"Grown up kids",@"I want kids"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.kid = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 9){
        // pets
        [LSChooseAlertView showWithTileArray:@[@"No",@"Cats",@"Dogs",@"Exotic",@"Other"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.pet = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 11){
        // bodytpye
        [LSChooseAlertView showWithTileArray:@[@"Average",@"Fit",@"Curvy",@"Thin",@"Overweight",@"Full-figured",@"A little extra"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.bodyType = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 12){
        //Drinking
        [LSChooseAlertView showWithTileArray:@[@"Never",@"Often",@"Socially",@"Now and then"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.drinking = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 13){
        //smoking
        [LSChooseAlertView showWithTileArray:@[@"Never",@"Often",@"Socially",@"Now and then"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.smoking = title;
            [weakself.mainTableView reloadData];
        }];
    }else if(indexPath.section == 14){
        //diet
        [LSChooseAlertView showWithTileArray:@[@"Omnivore",@"Vegan",@"Vegetarian",@"Kosher",@"Halal",@"No diet"] select:^(NSString * _Nonnull title) {
            weakself.editUserModel.diet = title;
            [weakself.mainTableView reloadData];
        }];
    }
}


#pragma mark - setter & getter1
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headView;
        [_mainTableView registerClass:[LSMyEditCell class] forCellReuseIdentifier:kLSMyEditCellIdentifier];
    }
    return _mainTableView;
}

- (UIView *)headView
{
    if(!_headView){
        CGFloat photoHeight = kSCREEN_WIDTH-32;
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, photoHeight)];
        
        //照片选择器
        self.photoEditView = [[LSPhotoEditView alloc]initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, photoHeight) eventVC:self];
        self.photoEditView.headImagesURL = [kUser.images copy];
//        NSArray *array = [kUser.imageslist componentsSeparatedByString:@","];
        NSArray *array = nil;
        if(kUser.imageslist.length > 10){
            [kUser.imageslist componentsSeparatedByString:@","];
        }
        self.photoEditView.imageUrlArray = [NSMutableArray arrayWithArray:array];
        [_headView addSubview:_photoEditView];
    }
    return _headView;
}


- (NSMutableArray <LSMineEditModel*>*)dataArray
{
    _dataArray = [NSMutableArray array];
    //0.username
    LSMineEditModel *nameModel = [LSMineEditModel createWithType:LSMyEditCellType_textField title:kLanguage(@"Username") content:@[self.editUserModel.name.length == 0?@"":self.editUserModel.name]];
    nameModel.key = @"name";
    //1.about
    LSMineEditModel *aboutModel = [LSMineEditModel createWithType:LSMyEditCellType_textView title:kLanguage(@"About me") content:@[self.editUserModel.about.length == 0?@"":self.editUserModel.about]];
    aboutModel.key = @"about";
    //2.Basic information
    NSString *height = [NSString stringWithFormat:@"%@:%@in",kLanguage(@"Height"),self.editUserModel.height];
    NSString *weight = [NSString stringWithFormat:@"%@:%@lb",kLanguage(@"Weight"),self.editUserModel.weight];
    NSString *relationship = [NSString stringWithFormat:@"%@:%@",kLanguage(@"Relationship"),self.editUserModel.relationship.length == 0?@"Secret":self.editUserModel.relationship];
    LSMineEditModel *basicModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Basic information") content:@[height,weight,relationship]];
    //3.Looking for
    LSMineEditModel *lookingforModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Looking for") content:@[self.editUserModel.needfor.length == 0?kLanguage(@"Please choose"):self.editUserModel.needfor]];
    //4.Target age
    LSMineEditModel *targetAgeModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Target age") content:@[self.editUserModel.lookingforage.length == 0?kLanguage(@"Please choose"):self.editUserModel.lookingforage]];
    //5.Interest In
    LSMineEditModel *interestModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Interest in") content:@[self.editUserModel.interested.length == 0?kLanguage(@"Please choose"):self.editUserModel.interested]];
    //6.Education
    LSMineEditModel *schoolModel = [LSMineEditModel createWithType:LSMyEditCellType_textField title:kLanguage(@"Education") content:@[self.editUserModel.school.length == 0?@"":self.editUserModel.school]];
    schoolModel.key = @"school";
    //7.Occupation
    LSMineEditModel *jobModel = [LSMineEditModel createWithType:LSMyEditCellType_textField title:kLanguage(@"Occupation") content:@[self.editUserModel.job.length == 0?@"":self.editUserModel.job]];
    jobModel.key = @"job";
    //8.Kids
    LSMineEditModel *kidModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Kids") content:@[self.editUserModel.kid.length == 0?kLanguage(@"Please choose"):self.editUserModel.kid]];
    //9.Pet
    LSMineEditModel *pedsModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Pets") content:@[self.editUserModel.pet.length == 0?kLanguage(@"Please choose"):self.editUserModel.pet]];
    //10.belief
    LSMineEditModel *belifModel = [LSMineEditModel createWithType:LSMyEditCellType_textField title:kLanguage(@"Religion") content:@[self.editUserModel.belief.length == 0?@"":self.editUserModel.belief]];
    belifModel.key = @"belief";
    //11.bodyType
    LSMineEditModel *bodytypeModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Body type") content:@[self.editUserModel.bodyType.length == 0?kLanguage(@"Please choose"):self.editUserModel.bodyType]];
    //12.drinking
    LSMineEditModel *drinkModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Alcohol") content:@[self.editUserModel.drinking.length == 0?kLanguage(@"Please choose"):self.editUserModel.drinking]];
    //13.smoking
    LSMineEditModel *smokingModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Smoking") content:@[self.editUserModel.smoking.length == 0?kLanguage(@"Please choose"):self.editUserModel.smoking]];
    //14.diet
    LSMineEditModel *dietModel = [LSMineEditModel createWithType:LSMyEditCellType_Choose title:kLanguage(@"Diet") content:@[self.editUserModel.diet.length == 0?kLanguage(@"Please choose"):self.editUserModel.diet]];
    
    [_dataArray addObject:nameModel];
    [_dataArray addObject:aboutModel];
    [_dataArray addObject:basicModel];
    [_dataArray addObject:lookingforModel];
    [_dataArray addObject:targetAgeModel];
    [_dataArray addObject:interestModel];
    [_dataArray addObject:schoolModel];
    [_dataArray addObject:jobModel];
    [_dataArray addObject:kidModel];
    [_dataArray addObject:pedsModel];
    [_dataArray addObject:belifModel];
    [_dataArray addObject:bodytypeModel];
    [_dataArray addObject:drinkModel];
    [_dataArray addObject:smokingModel];
    [_dataArray addObject:dietModel];
    
    return _dataArray;
}

@end


@implementation LSMineEditModel

+ (LSMineEditModel *)createWithType:(LSMyEditCellType)type title:(NSString *)title content:(NSArray *)content
{
    LSMineEditModel *modle = [[LSMineEditModel alloc]init];
    modle.type = type;
    modle.title = title;
    modle.content = content;
    return modle;
}

@end
