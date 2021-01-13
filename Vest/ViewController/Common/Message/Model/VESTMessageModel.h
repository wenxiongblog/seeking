//
//  VESTMessageModel.h
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VESTUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VESTMessageModel : NSObject <NSCoding,NSCopying>

//@property (nonatomic,strong) VESTUserModel *sendUser; //发送者
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *headUrl;

@property (nonatomic,assign)BOOL direction; //YES= SEND  NO= RECEIVE
@property (nonatomic,strong) NSString *text;  //消息内容
@property (nonatomic,strong) NSString *time;

+ (VESTMessageModel *)createMsgWithUser:(VESTUserModel *)user direction:(BOOL)direction text:(NSString *)text;

-(NSDictionary*)toJson;//对象转json
@end

NS_ASSUME_NONNULL_END
