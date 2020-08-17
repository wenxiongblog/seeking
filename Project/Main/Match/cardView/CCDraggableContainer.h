//
//  CCDraggableContainer.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDraggableConfig.h"
#import "CCDraggableCardView.h"
@class CCDraggableContainer;


/**
 Delegate
 */
@protocol CCDraggableContainerDelegate <NSObject>

//左右滑动
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
        draggableDirection:(CCDraggableDirection)draggableDirection
                widthRatio:(CGFloat)widthRatio
               heightRatio:(CGFloat)heightRatio;

//点击卡片
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
            didSelectIndex:(NSInteger)didSelectIndex;

//向上轻扫
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
      swipeCardView:(CCDraggableCardView *)cardView
swipeIndex:(NSInteger)didSelectIndex;

//完成最后一张卡片的拖动
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
 finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;

//停止拖动
-(void)draggableContainne:(CCDraggableContainer*)draggableContainner
    finishedDraggableCard:(CCDraggableCardView*)finishCard;
//做拖动删除
-(void)draggableContainner:(CCDraggableContainer*)draggableContainner removedView:(CCDraggableCardView*)removedView removeFromLeft:(BOOL)removeFromLeft;

@end

/**
 DataSource
 */
@protocol CCDraggableContainerDataSource <NSObject>

@required
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer
                               viewForIndex:(NSInteger)index;

- (NSInteger)numberOfIndexs;

@end

/**
 CCDraggableContainer
 */
@interface CCDraggableContainer : UIView

@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDataSource>dataSource;

@property (nonatomic) CCDraggableStyle     style;
@property (nonatomic) CCDraggableDirection direction;
//我添加的属性
@property(nonatomic,strong) CCDraggableCardView * dragCardView;
@property(nonatomic) NSInteger removeGestureIndex;
@property (nonatomic) NSInteger loadedIndex; //加载到第几个card

- (instancetype)initWithFrame:(CGRect)frame style:(CCDraggableStyle)style;
- (void)removeForDirection:(CCDraggableDirection)direction;
- (void)reloadData;

@end
