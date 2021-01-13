//
//  VESTSaveMessageTool.h
//  Project
//
//  Created by XuWen on 2020/9/10.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VESTMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VESTSaveMessageTool : NSObject
+ (void)saveMessage:(VESTMessageModel *)message WithKey:(NSString *)key;
+ (NSArray <VESTMessageModel *>*)getMessageWithKey:(NSString *)key;
+ (NSArray <VESTMessageModel *>*)getAllConversation;
@end

NS_ASSUME_NONNULL_END
