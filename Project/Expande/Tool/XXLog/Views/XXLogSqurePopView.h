//
//  XXLogSqurePopView.h
//  SCGov
//
//  Created by solehe on 2019/10/24.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXLogSqurePopView : UIView

@property (nonatomic, strong) NSArray<NSString *> *itmes;

@end


@interface XXLogSqureInputView : UIView

- (void)show:(void(^)(NSString *url))block;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
