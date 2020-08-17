//
//  CCDraggableConfig.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#ifndef CCDraggableConfig_h
#define CCDraggableConfig_h


/**
 拽到方向枚举
 */
typedef NS_OPTIONS(NSInteger, CCDraggableDirection) {
    CCDraggableDirectionDefault     = 0,
    CCDraggableDirectionLeft        = 1 << 0,
    CCDraggableDirectionRight       = 1 << 1
};

typedef NS_OPTIONS(NSInteger, CCDraggableStyle) {
    CCDraggableStyleUpOverlay   = 0,
    CCDraggableStyleDownOverlay = 1
};

#define CCWidth  [UIScreen mainScreen].bounds.size.width
#define CCHeight [UIScreen mainScreen].bounds.size.height

//static const CGFloat kBoundaryRatio   = 0.8f;
//static const CGFloat kSecondCardScale = 0.95f;
//static const CGFloat kTherdCardScale  = 0.9f;
//
//static const CGFloat kCardEdage        = 25.0f;//这是向下偏移的量
//static const CGFloat kCardEdageRight   = 0.0f;//这是想右边偏移的量
//static const CGFloat kContainerEdage   = 20.0f; //宽度剪

static const CGFloat kBoundaryRatio   = 1.0f;
static const CGFloat kSecondCardScale = 1.0f;
static const CGFloat kTherdCardScale  = 1.0f;

static const CGFloat kCardEdage        = 0.0f;//这是向下偏移的量
static const CGFloat kCardEdageRight   = 0.0f;//这是想右边偏移的量
static const CGFloat kContainerEdage   = 0.0f; //宽度剪

static const CGFloat kVisibleCount     = 3;

#endif /* CCDraggableConfig_h */
