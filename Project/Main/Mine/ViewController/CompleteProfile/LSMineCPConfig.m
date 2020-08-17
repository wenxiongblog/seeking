//
//  LSMineCPConfig.m
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMineCPConfig.h"
#import "LSMineCPFinishVC.h"

@interface LSMineCPConfig()
@property (nonatomic,strong) LSMineCPBaseVC *cp_01_aboutVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_02_schoolVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_03_workVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_04_lookforVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_05_kidsVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_06_petsVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_07_beliefVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_08_bodyVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_09_drinkVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_10_smokeVC;
@property (nonatomic,strong) LSMineCPBaseVC *cp_11_dietVC;

@property (nonatomic,strong) LSMineCPFinishVC *finishVC;

@property (nonatomic,strong) NSMutableArray *vcArray;
@property (nonatomic,strong,readwrite) LSMineCPBaseVC *vc;

//临时数据
@property (nonatomic,strong) NSMutableDictionary *paramDict;

@end

@implementation LSMineCPConfig

//埋点
- (void)MDProfile_1{}
- (void)MDProfile_2{}
- (void)MDProfile_3{}
- (void)MDProfile_4{}
- (void)MDProfile_5{}
- (void)MDProfile_6{}
- (void)MDProfile_7{}
- (void)MDProfile_8{}
- (void)MDProfile_9{}
- (void)MDProfile_10{}
- (void)MDProfile_11{}

- (instancetype)init
{
    self = [super init];
    if(self){
//        self.vcArray = [NSMutableArray arrayWithArray:@[self.cp_01_aboutVC,self.cp_02_schoolVC,self.cp_03_workVC,self.cp_04_lookforVC,self.cp_05_kidsVC,self.cp_06_petsVC,self.cp_07_beliefVC,self.cp_08_bodyVC,self.cp_09_drinkVC,self.cp_10_smokeVC,self.cp_11_dietVC]];
        self.vcArray = [NSMutableArray array];
        
        if(kUser.about.length == 0){
            [self.vcArray addObject:self.cp_01_aboutVC];
        }
        if(kUser.school.length == 0){
            [self.vcArray addObject:self.cp_02_schoolVC];
        }
        if(kUser.job.length == 0){
            [self.vcArray addObject:self.cp_03_workVC];
        }
        if([kUser.needfor isEqualToString:@"Secrete"]||[kUser.needfor isEqualToString:@"保密"]){
            [self.vcArray addObject:self.cp_04_lookforVC];
        }
        if(kUser.kid.length == 0){
            [self.vcArray addObject:self.cp_05_kidsVC];
        }
        if(kUser.pet.length == 0){
            [self.vcArray addObject:self.cp_06_petsVC];
        }
        if(kUser.belief.length == 0){
            [self.vcArray addObject:self.cp_07_beliefVC];
        }
        if(kUser.bodyType.length == 0){
            [self.vcArray addObject:self.cp_08_bodyVC];
        }
        if(kUser.drinking.length == 0){
            [self.vcArray addObject:self.cp_09_drinkVC];
        }
        if(kUser.smoking.length == 0){
            [self.vcArray addObject:self.cp_10_smokeVC];
        }
        if(kUser.diet.length == 0){
            [self.vcArray addObject:self.cp_11_dietVC];
        }
        
        self.vc = self.vcArray.firstObject;
        [self MDNext:self.vc.key];
        //标号
        self.vc.number = [NSString stringWithFormat:@"1/%ld",self.vcArray.count];
        //第一个要隐藏back按钮
        self.vc.hiddenBack = YES;
    }
    return self;
}

- (void)nextVC
{
    NSInteger index = [self.vcArray indexOfObject:self.vc];
    if(index+1 < self.vcArray.count){
        LSMineCPBaseVC *vc = self.vcArray[index+1];
        vc.number = [NSString stringWithFormat:@"%ld/%ld",index+1+1,self.vcArray.count];
        [self.vc.navigationController pushViewController:vc animated:YES];
        self.vc = vc;
        [self MDNext:self.vc.key];
    }else{
        [self.vc.navigationController pushViewController:self.finishVC animated:YES];
    }
}

- (void)MDNext:(NSString *)key
{
    NSArray *array = @[@"about",@"school",@"job",@"needfor",@"kid",@"pet",@"belief",@"bodyType",@"drinking",@"smoking",@"diet"];
    NSUInteger index = [array indexOfObject:key];
    switch (index+1) {
        case 1:{[self MDProfile_1];}break;
        case 2:{[self MDProfile_2];}break;
        case 3:{[self MDProfile_3];}break;
        case 4:{[self MDProfile_4];}break;
        case 5:{[self MDProfile_5];}break;
        case 6:{[self MDProfile_6];}break;
        case 7:{[self MDProfile_7];}break;
        case 8:{[self MDProfile_8];}break;
        case 9:{[self MDProfile_9];}break;
        case 10:{[self MDProfile_10];}break;
        case 11:{[self MDProfile_11];}break;
        default:{}break;
    }
}

//点击back
- (void)preVC
{
    NSInteger index = [self.vcArray indexOfObject:self.vc];
    if(index-1>=0){
        [self.vc.navigationController popViewControllerAnimated:YES];
        LSMineCPBaseVC *vc = self.vcArray[index-1];
        self.vc = vc;
    }
}

- (LSMineCPBaseVC *)createVC
{
    LSMineCPBaseVC *vc = [[LSMineCPBaseVC alloc]init];
    kXWWeakSelf(weakself);
    vc.nextBlock = ^(BOOL isSkip, NSString *key, NSString *value) {
        //不是跳过就要存储信息
        if(!isSkip){
            [weakself.paramDict setValue:value forKey:key];
        }
        NSLog(@"%@",weakself.paramDict);
        [self nextVC];
    };
    vc.backBlock = ^(BOOL isBack, NSString *key) {
        if(isBack){
            [weakself.paramDict removeObjectForKey:key];
        }
        NSLog(@"%@",weakself.paramDict);
        [self preVC];
    };
    kXWWeak(vc, weakvc);
    vc.closeBlock = ^(BOOL isClose) {
        if(isClose){
            //存储信息，然后关闭
            NSLog(@"保存信息%@",weakself.paramDict);
            [weakself dataSave:weakvc];
        }
    };
    return vc;
}

#pragma mark - data
- (void)dataSave:(UIViewController *)vc
{
    //如果没有信息就直接关闭
    if(self.paramDict.allKeys.count == 0){
        [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //有信息,需要保存
    [self.paramDict setValue:kUser.id forKey:@"id"];
    
    [AlertView showLoading:@"saving..." inView:[self getCurrentVC].view];
    kXWWeakSelf(weakself);
    kXWWeak(vc, weakvc);
    [self post:kURL_UpdateUserInfo params:self.paramDict success:^(Response * _Nonnull response) {
        [AlertView hiddenLoadingInView:[weakself getCurrentVC].view];
        if(response.isSuccess){
            NSDictionary *dict = [response.content objectForKey:@"outuser"];
            [kUser mj_setKeyValues:dict];
            [kUser synchronize];
            [weakvc.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [AlertView toast:response.message inView:[weakself getCurrentVC].view];
            [weakvc.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } fail:^(NSError * _Nonnull error) {
        [AlertView hiddenLoadingInView:[weakself getCurrentVC].view];
    }];
}



#pragma mark - setter & getter1
- (LSMineCPBaseVC *)cp_01_aboutVC
{
    if(!_cp_01_aboutVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeInput;
        vc.profileTitle = kLanguage(@"Tell us a little about yourself");
        vc.placeholder = @"For example: I play football and golf,love alternative rock and night clubs...";
        vc.key = @"about";
        vc.value = kUser.about;
        _cp_01_aboutVC = vc;
    }
    return _cp_01_aboutVC;
}

- (LSMineCPBaseVC *)cp_02_schoolVC
{
    if(!_cp_02_schoolVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeInput;
        vc.profileTitle = kLanguage(@"What school you study at?");
        vc.placeholder = @"For example: University of Michigan";
        vc.key = @"school";
        vc.value = kUser.school;
        _cp_02_schoolVC = vc;
    }
    return _cp_02_schoolVC;
}

- (LSMineCPBaseVC *)cp_03_workVC
{
    if(!_cp_03_workVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeInput;
        vc.profileTitle = kLanguage(@"What do you do?");
        vc.placeholder = @"For example:Teacher, doctor, carpenter, etc.";
        vc.key = @"job";
        vc.value = kUser.job;
        _cp_03_workVC = vc;
    }
    return _cp_03_workVC;
}

- (LSMineCPBaseVC *)cp_04_lookforVC
{
    if(!_cp_04_lookforVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"What are you looking for?");
        vc.isSingleLine = YES; //单行显示
        vc.titleArray = @[@"Long-term relationship",@"Short-term relationship",@"New friends"];
        vc.key = @"needfor";
        vc.value = kUser.needfor;
        _cp_04_lookforVC = vc;
    }
    return _cp_04_lookforVC;
}

- (LSMineCPBaseVC *)cp_05_kidsVC
{
    if(!_cp_05_kidsVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"Do you have kids?");
        vc.titleArray = @[@"I have no kids",@"I don't want kids",@"I already have kids",@"Not ready for kids",@"Grown up kids",@"I want kids"];
        vc.key = @"kid";
        vc.value = kUser.kid;
        _cp_05_kidsVC = vc;
    }
    return _cp_05_kidsVC;
}

- (LSMineCPBaseVC *)cp_06_petsVC
{
    if(!_cp_06_petsVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"Do you have pets?");
        vc.titleArray = @[@"No",@"Cats",@"Dogs",@"Exotic",@"Other"];
        vc.key = @"pet";
        vc.value = kUser.pet;
        _cp_06_petsVC = vc;
    }
    return _cp_06_petsVC;
}

- (LSMineCPBaseVC *)cp_07_beliefVC
{
    if(!_cp_07_beliefVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeInput;
        vc.profileTitle = kLanguage(@"What is your belief");
        vc.placeholder = @"For example: Christianity, Islam,Nonreligious, Hinduism, Buddhism,etc.";
        vc.key = @"belief";
        vc.value = kUser.belief;
        _cp_07_beliefVC = vc;
    }
    return _cp_07_beliefVC;
}

- (LSMineCPBaseVC *)cp_08_bodyVC
{
    if(!_cp_08_bodyVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"What is your body type?");
        vc.titleArray = @[@"Average",@"Fit",@"Curvy",@"Thin",@"Overweight",@"Full-figured",@"A little extra",@"Not specified"];
        vc.key = @"bodyType";
        vc.value = kUser.bodyType;
        _cp_08_bodyVC = vc;
    }
    return _cp_08_bodyVC;
}

- (LSMineCPBaseVC *)cp_09_drinkVC
{
    if(!_cp_09_drinkVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"Drinking?");
        vc.titleArray = @[@"Never",@"Often",@"Socially",@"Now and then"];
        vc.key = @"drinking";
        vc.value = kUser.drinking;
        _cp_09_drinkVC = vc;
    }
    return _cp_09_drinkVC;
}

- (LSMineCPBaseVC *)cp_10_smokeVC
{
    if(!_cp_10_smokeVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage(@"Smoking?");
        vc.titleArray = @[@"Never",@"Often",@"Socially",@"Now and then"];
        vc.key = @"smoking";
        vc.value = kUser.smoking;
        _cp_10_smokeVC = vc;
    }
    return _cp_10_smokeVC;
}

- (LSMineCPBaseVC *)cp_11_dietVC
{
    if(!_cp_11_dietVC){
        LSMineCPBaseVC *vc = [self createVC];
        vc.type = LSMineProfieTypeChoose;
        vc.profileTitle = kLanguage( @"Do you follow a diet?");
        vc.titleArray = @[@"Omnivore",@"Vegan",@"Vegetarian",@"Kosher",@"Halal",@"No diet"];
        vc.key = @"diet";
        vc.value = kUser.diet;
        _cp_11_dietVC = vc;
    }
    return _cp_11_dietVC;
}

- (LSMineCPFinishVC *)finishVC
{
    if(!_finishVC){
        _finishVC = [[LSMineCPFinishVC alloc]init];
        kXWWeakSelf(weakself);
        _finishVC.closeBlock = ^(BOOL isClose) {
            if(isClose){
                //存储信息，然后关闭
                NSLog(@"保存信息%@",weakself.paramDict);
                [weakself dataSave:weakself.finishVC];
            }
        };
    }
    return _finishVC;
}

- (NSMutableDictionary *)paramDict
{
    if(!_paramDict){
        _paramDict = [NSMutableDictionary dictionary];
    }
    return _paramDict;
}

@end
