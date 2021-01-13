//
//  SEEKING_Customer.m
//  Project
//  
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//  

#import "SEEKING_Customer.h"

@implementation SEEKING_Customer

- (NSString *)conversationId
{
    return [NSString stringWithFormat:@"Meet_%@",self.id];
}

- (NSString *)relationship
{
    if(_relationship == nil){
        return kLanguage(@"Secrete");
    }else{
        if([_relationship isEqualToString:@"Secrete"]||[_relationship isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return _relationship;
    }
}


- (NSString *)weight
{
    if(_weight){
        return _weight;
    }else{
        if([_weight isEqualToString:@"Secrete"]||[_weight isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return kLanguage(@"Secrete");
    }
}

- (NSString *)address
{
    if(_address){
        return _address;
    }else{
        if([_address isEqualToString:@"Secrete"]||[_address isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return kLanguage(@"Secrete");
    }
}

- (NSString *)lookingforage
{
    if(_lookingforage == nil){
        return kLanguage(@"Secrete");
    }else{
        if([_lookingforage isEqualToString:@"Secrete"]||[_lookingforage isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return _lookingforage;
    }
}

- (NSString *)needfor
{
    if(_needfor == nil){
        return kLanguage(@"Secrete");
    }else{
        if([_needfor isEqualToString:@"Secrete"]||[_needfor isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return _needfor;
    }
}

- (NSString *)interested
{
    if(_interested == nil){
        return kLanguage(@"Secrete");
    }else{
        if([_interested isEqualToString:@"Secrete"]||[_interested isEqualToString:@"保密"]){
            return kLanguage(@"Secrete");
        }
        return _interested;
    }
}

//用户的标签
- (NSArray *)tags
{
    NSMutableArray *array = [NSMutableArray array];
    if(self.school.length > 0){
        [array addObject:self.school];
    }
    if(self.job.length > 0){
        [array addObject:self.job];
    }
    if(self.needfor.length > 0){
        [array addObject:self.needfor];
    }
    if(self.kid.length > 0){
        [array addObject:self.kid];
    }
    if(self.pet.length > 0){
        if([self.pet isEqualToString:@"NO"]){
            
        }else if([self.pet isEqualToString:@"Other"]){
            [array addObject:@"Other Pets"];
        }else{
            [array addObject:self.pet];
        }
    }
    if(self.belief.length > 0){
        [array addObject:self.belief];
    }
    if(self.bodyType.length > 0){
        if(![self.bodyType isEqualToString:@"Not specified"]){
            [array addObject:self.bodyType];
        }
        
    }
    if(self.drinking.length > 0){
        [array addObject:[NSString stringWithFormat:@"Drink %@",self.drinking]];
    }
    if(self.smoking.length > 0){
        [array addObject:[NSString stringWithFormat:@"Smoke %@",self.smoking]];
    }
    if(self.diet.length > 0){
        if([self.diet isEqualToString:@"No diet"]){
            
        }else{
            [array addObject:self.diet];
        }
    }
    return array;
}

- (NSString *)rongYunExtra
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isVIP"] = @([self isVIPCustomer]);
    dict[@"sex"]= @(_sex);
    
    NSDictionary *d = [NSDictionary dictionaryWithDictionary:dict];
    NSString *rong = [d DataTOjsonString];
    return rong;
}

//打招呼的额外字段
- (NSString *)rongYunExtraWithZhaoHu
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isVIP"] = @([self isVIPCustomer]);
    dict[@"sex"]= @(_sex);
    dict[@"zhaohu"]= @"zhaohu"; //标记是打招呼
    NSDictionary *d = [NSDictionary dictionaryWithDictionary:dict];
    NSString *rong = [d DataTOjsonString];
    return rong;
}

- (BOOL)isVIPCustomer
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    long currentTime = [datenow timeIntervalSince1970];
    NSLog(@"当前时间戳：%ld,时间:%@",currentTime,[formatter stringFromDate:datenow]);
    NSString *expireTimeStr = self.effectiveTime;
    long expireTime = [expireTimeStr integerValue];
    NSDate *expireData = [NSDate dateWithTimeIntervalSince1970:expireTime];
    NSLog(@"VIP时间戳：%ld,时间%@:",expireTime,[formatter stringFromDate:expireData]);
    
    return currentTime < expireTime;
}

@end
