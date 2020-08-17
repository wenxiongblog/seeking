//
//  CCDraggableContainer.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//   my

#import "CCDraggableContainer.h"

@interface CCDraggableContainer ()

@property (nonatomic) BOOL moving; ///< 可以用方向替代, 暂时用着
@property (nonatomic) CGRect firstCardFrame; ///< 初始化时第一个Card的frame
@property (nonatomic) CGRect lastCardFrame; ///< 初始化时最后一个Card的frame
@property (nonatomic) CGAffineTransform lastCardTransform; ///< 初始化时最后一个Card的transform
@property (nonatomic) CGPoint cardCenter;
@property (nonatomic) NSMutableArray *currentCards; ///当前的一组卡片
@end
@implementation CCDraggableContainer

- (instancetype)initWithFrame:(CGRect)frame style:(CCDraggableStyle)style {
    self = [self initWithFrame:frame];
    if(self){
        self.style = style;
        self.removeGestureIndex = -1;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.style = CCDraggableStyleUpOverlay;
}

// 每次执行reloadData, UI、数据进行刷新
- (void)reloadData {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self defaultConfig];
    [self installNextItem];
    [self resetVisibleCards];
}

- (void)defaultConfig {
    self.currentCards = [NSMutableArray array];
    self.direction = CCDraggableDirectionDefault;
    self.loadedIndex = 0;
    self.moving = NO;
}

- (CGRect)defaultCardViewFrame {
    CGFloat s_width  = CGRectGetWidth(self.frame);
    CGFloat s_height = CGRectGetHeight(self.frame);
//    return CGRectMake(0, s_height*0.1, s_width, s_height*0.9);
    return CGRectMake(0, 0, s_width, s_height);
}

- (void)installNextItem {
    
    // 最多只显示3个
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)] && [self.dataSource respondsToSelector:@selector(draggableContainer:viewForIndex:)]) {
        
        NSInteger indexs = [self.dataSource numberOfIndexs];
        NSInteger preloadViewCont = indexs <= kVisibleCount ? indexs : kVisibleCount;  //展示的个数，最多3个
        
        /*
        在此需添加当前Card是否移动的状态A
        如果A为YES, 则执行当且仅当一次installNextItem, 用条件限制
        */

        if (self.loadedIndex < indexs) {
            
            for (long int i = self.currentCards.count; i <  (self.moving ? preloadViewCont + 1: preloadViewCont); i++) {
                
                CCDraggableCardView *cardView = [self.dataSource draggableContainer:self viewForIndex:self.loadedIndex];
                cardView.frame = [self defaultCardViewFrame];
                
                if (self.loadedIndex >= 3) {
                    cardView.frame = self.lastCardFrame;
                } else {
                    CGRect frame = cardView.frame;
                    if (CGRectIsEmpty(self.firstCardFrame)) {
                        self.firstCardFrame = frame;
                        self.cardCenter = cardView.center;
                    }
                }
                
                // TAG
                cardView.tag = self.loadedIndex;
                
                [self addSubview:cardView];
                [self sendSubviewToBack:cardView]; // addSubview后添加sendSubviewToBack, 使Card的显示顺序倒置

                // 添加新元素
                [self.currentCards addObject:cardView];
                
                // 添加拖拽手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
                [cardView addGestureRecognizer:pan];
                
                // 添加轻扫手势
                UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureHandle:)];
                swipe.direction = UISwipeGestureRecognizerDirectionUp;
                [cardView addGestureRecognizer:swipe];
                //解决手势冲突
                [pan requireGestureRecognizerToFail:swipe];
                
                // 添加点击手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
                [cardView addGestureRecognizer:tap];
                
                // 总数indexs, 计算以及加载到了第几个index
                self.loadedIndex += 1;
                if (i!=0) {
                    cardView.userInteractionEnabled = NO;
                }
                //移除手势
                if (self.removeGestureIndex>=0) {
                    if (cardView.tag==self.removeGestureIndex) {
                        [cardView removeGestureRecognizer:tap];
                        [cardView removeGestureRecognizer:pan];
                        [cardView removeGestureRecognizer:swipe];
                    }
                }
             
                NSLog(@"loaded %ld card", (long)self.loadedIndex);
            }
            self.dragCardView = self.currentCards[0];
        }
    } else {
        NSAssert(self.dataSource, @"CCDraggableContainerDataSource can't nil");
    }
}

- (void)judgeMovingState:(CGFloat)scale {
    if (!self.moving) {
        self.moving = YES;
        [self installNextItem];
    } else {
        [self movingVisibleCards:scale];
    }
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tap {
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableContainer:cardView:didSelectIndex:)]) {
        [self.delegate draggableContainer:self cardView:(CCDraggableCardView *)tap.view didSelectIndex:tap.view.tag];
    }
}

- (void)swipeGestureHandle:(UISwipeGestureRecognizer *)gesture
{
    [self finishedSwiptGesture:gesture.view];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    CCDraggableCardView *cardView = (CCDraggableCardView *)gesture.view;
    self.dragCardView = cardView;
    CGFloat preyP = 0;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Coding...
        CGPoint point = [gesture locationInView:cardView];
        preyP = point.y;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [gesture translationInView:self]; // translation: 平移 获取相对坐标原点的坐标
//        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, kSCREEN_HEIGHT/2.0);
        cardView.center = movedPoint;
//        cardView.transform = CGAffineTransformRotate(cardView.originalTransform, (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self]; // 设置坐标原点位上次的坐标
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableContainer:draggableDirection:widthRatio:heightRatio:)]) {
    
            /*
            做比例, 总长度(0 ~ self.cardCenter.x), 已知滑动的长度 (gesture.view.center.x - self.cardCenter.x)
            ratio用来判断是否显示图片中的"Like"或"DisLike"状态, 用开发者限定多少比例显示或设置透明度
            */

            float widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
            float heightRatio = (gesture.view.center.y - self.cardCenter.y) / self.cardCenter.y;
            
            // Moving
            [self judgeMovingState: widthRatio];
            
            /*
            左右的判断方法为: 只要 ratio_w > 0 就是Right
            */
            
            if (widthRatio > 0) {
                self.direction = CCDraggableDirectionRight;
            } if (widthRatio < 0) {
                self.direction = CCDraggableDirectionLeft;
            } else if (widthRatio == 0) {
                self.direction = CCDraggableDirectionDefault;
            }
            [self.delegate draggableContainer:self draggableDirection:self.direction widthRatio:widthRatio heightRatio:heightRatio];
        }
    }
   
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {
       
       // [self.delegate draggableContainne:self finishedDraggableCard:cardView];
        /*  --------------------
        随着滑动的方向消失或还原
        */

        float widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
        float moveWidth  = (gesture.view.center.x  - self.cardCenter.x);
        float moveHeight = (gesture.view.center.y - self.cardCenter.y);

        [self finishedPanGesture:gesture.view direction:self.direction scale:(moveWidth / moveHeight) disappear:fabs(widthRatio) > kBoundaryRatio];
        
        //上滑动
        if(moveHeight > 200){
            [self finishedSwiptGesture:gesture.view];
        }
    }
}

- (void)finishedSwiptGesture:(UIView *)cardView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(draggableContainer:swipeCardView:swipeIndex:)]){
        [self.delegate draggableContainer:self swipeCardView:(CCDraggableCardView *)cardView swipeIndex:cardView.tag];
    }
}

- (void)finishedPanGesture:(UIView *)cardView direction:(CCDraggableDirection)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
  
    /*
    1.还原Original坐标
    2.移除最底层Card
    */
    
    if (!disappear) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)]) {
            // 2016.12.15 修复第四个视图没有被移除的BUG
            if (self.moving && self.currentCards.count > kVisibleCount) {
                UIView *lastView = [self.currentCards lastObject];
                [lastView removeFromSuperview];
                [self.currentCards removeObject:lastView];
                self.loadedIndex = lastView.tag;
            }
            [self setMoving:NO];
            [self resetVisibleCards];
        }
    } else {
        
        /*
        移除屏幕后
        1.删除移除屏幕的cardView
        2.重新布局剩下的cardViews
        */
        
        NSInteger flag = direction == CCDraggableDirectionLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
//                             cardView.center = CGPointMake(CCWidth * flag, CCWidth * flag / scale + self.cardCenter.y);
            cardView.center = CGPointMake(CCWidth * flag, CCWidth * flag / scale + self.cardCenter.y);
                         } completion:^(BOOL finished) {
                             [cardView removeFromSuperview];
                             //自己添加的代理
                             if (finished) {
                               
                             }
                             
                         }];
        [self.currentCards removeObject:cardView];
        [self setMoving:NO];
        [self resetVisibleCards];
        if (direction==CCDraggableDirectionLeft) {
            [self.delegate draggableContainner:self removedView:(CCDraggableCardView*)cardView removeFromLeft:YES];
            
        }
        if (direction==CCDraggableDirectionRight) {
            [self.delegate draggableContainner:self removedView:(CCDraggableCardView*)cardView removeFromLeft:NO];
            
        }
    }
}

- (void)removeForDirection:(CCDraggableDirection)direction {
    
    if (self.moving) {
        
        return;
    } else {
         
        CGPoint cardCenter = CGPointZero;
        CGFloat flag = 0;
        
        switch (direction) {
            case CCDraggableDirectionLeft:
                cardCenter = CGPointMake(-CCWidth / 2, self.cardCenter.y);
                flag = -1;
                break;
            case CCDraggableDirectionRight:
                cardCenter = CGPointMake(CCWidth * 1.5, self.cardCenter.y);
                flag = 1;
                break;
            default:
                break;
        }
        
        UIView *firstView = [self.currentCards firstObject];
        
        [UIView animateWithDuration:0.35 animations:^{
            
            CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
            firstView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
            firstView.center = cardCenter;

        } completion:^(BOOL finished) {
            
            [firstView removeFromSuperview];
            [self.currentCards removeObject:firstView];
            [self installNextItem];
            [self resetVisibleCards];
        }];
    }
}

- (void)resetVisibleCards {
    
    __weak CCDraggableContainer *weakself = self;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [weakself originalLayout];
                     } completion:^(BOOL finished) {
                         
                         /*
                         2016-12-08
                         当且仅当动画结束调用，之前错误写在originalLayout方法中，要知道originalLayout方法经常活动在动画里
                         ...写在originalLayout里会出现CardView里面的子视图出现动画效果
                         用户移除最后一个CardView除非的方法
                         */
                         
                         if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(draggableContainer:finishedDraggableLastCard:)]) {
                             if (weakself.currentCards.count == 0) {
                                 [weakself.delegate draggableContainer:self finishedDraggableLastCard:YES];
                             }
                         }
                     }];
}


//拖动视图 大小的变化
// scale: MAX: kBoundaryRatio
- (void)movingVisibleCards:(CGFloat)scale {
    
    scale = fabs(scale) >= kBoundaryRatio ? kBoundaryRatio : fabs(scale);
    CGFloat sPoor = kSecondCardScale - kTherdCardScale; // 相邻两个CardScale差值
    CGFloat tPoor = sPoor / (kBoundaryRatio / scale); // transform x值
    CGFloat yPoor = kCardEdage / (kBoundaryRatio / scale); // frame y差值
    
    for (int i = 1; i < self.currentCards.count; i++) {
        
        CCDraggableCardView *cardView = [self.currentCards objectAtIndex:i];
                
        switch (i) {
            case 1:
            {
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardScale,tPoor + kSecondCardScale);// 改变tran
                CGAffineTransform translate = CGAffineTransformTranslate(scale, -kCardEdageRight, -yPoor); // 改变frame
                cardView.transform = translate;
            }
                break;
            case 2:
            {
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kTherdCardScale, tPoor +kTherdCardScale);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, -kCardEdageRight, -yPoor);
                cardView.transform = translate;
            }
                break;
            case 3:
            {
                cardView.transform = self.lastCardTransform;
            }
                break;
            default:
                break;
        }
    }
}

//这里是三个card的布局
- (void)originalLayout {
    
    // self.delegate所触发方法, 委托对象用来改变一些UI的缩放、透明度等...
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableContainer:draggableDirection:widthRatio:heightRatio:)]) {
        [self.delegate draggableContainer:self draggableDirection:self.direction widthRatio:0 heightRatio:0];
    }
    //拖动结束
    [self.delegate draggableContainne:self finishedDraggableCard:self.dragCardView];
    
    for (int i = 0; i < self.currentCards.count; i++) {
        
        CCDraggableCardView *cardView = [self.currentCards objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = self.firstCardFrame;
        if (i==0) {
            cardView.userInteractionEnabled = YES;
        }
        
        switch (i) {
            case 0:
            {
                cardView.frame = frame;
                NSLog(@"第一个Card的Y：%f", CGRectGetMinY(cardView.frame));
            }
                break;
            case 1:
            {
                frame.origin.y = frame.origin.y + kCardEdage;
//                frame.origin.x = frame.origin.x + kCardEdageRight;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardScale, kSecondCardScale);
            }
                break;
            case 2:
            {
                frame.origin.y = frame.origin.y + kCardEdage * 2;
//                frame.origin.x = frame.origin.x + kCardEdageRight * 2;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kTherdCardScale, kTherdCardScale);

                NSLog(@"第三个Card距容器视图底部：%f", CGRectGetHeight(self.frame) - CGRectGetMaxY(cardView.frame));

                if (CGRectIsEmpty(self.lastCardFrame)) {
                    self.lastCardFrame = frame;
                    self.lastCardTransform = cardView.transform;
                }
            }
                break;
            default:
                break;
        }
        
        cardView.originalTransform = cardView.transform;
    }
    
}

@end
