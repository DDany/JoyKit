//
//  JKInfiniteScrollView.h
//  ShopSNS
//
//  Created by Danny on 11/15/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


/************************************************************************
 * Dependencies: None.
 * Base on: DMLazyScrollView. ( https://github.com/malcommac/DMLazyScrollView )
 ************************************************************************/


typedef NS_OPTIONS(NSUInteger, InfiniteScrollViewDirection) {
    InfiniteScrollViewDirectionHorizontal,
    InfiniteScrollViewDirectionVertical
};

typedef NS_OPTIONS(NSUInteger, InfiniteScrollViewTransition) {
    InfiniteScrollViewTransitionAuto,
    InfiniteScrollViewTransitionForward,
    InfiniteScrollViewTransitionBackward
};

@class JKInfiniteScrollView;

@protocol InfiniteScrollViewDataSource <NSObject>
@required
- (id)infiniteScrollView:(JKInfiniteScrollView *)pagingView dataAtIndex:(NSUInteger)index;
- (NSInteger)numberOfPagesInInfiniteScrollView:(JKInfiniteScrollView *)pagingView;
@end

@protocol InfiniteScrollViewDelegate <NSObject>
@optional
- (void)infiniteScrollViewWillBeginDragging:(JKInfiniteScrollView *)pagingView;
- (void)infiniteScrollViewDidScroll:(JKInfiniteScrollView *)pagingView at:(CGPoint)visibleOffset;
- (void)infiniteScrollViewDidEndDragging:(JKInfiniteScrollView *)pagingView;
- (void)infiniteScrollViewWillBeginDecelerating:(JKInfiniteScrollView *)pagingView;
- (void)infiniteScrollViewDidEndDecelerating:(JKInfiniteScrollView *)pagingView atPageIndex:(NSInteger)pageIndex;
- (void)infiniteScrollView:(JKInfiniteScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex;
- (void)infiniteScrollView:(JKInfiniteScrollView *)pagingView didTapAtPageIndex:(NSInteger)currentPageIndex;

@end

@interface JKInfiniteScrollView : UIScrollView

/**
 *  Init with direction
 *
 *  @param frame     frame
 *  @param direction scroll direction
 *
 *  @return object
 */
- (id)initWithFrame:(CGRect)frame direction:(InfiniteScrollViewDirection)direction;

/**
 *  Current state.
 */
@property (nonatomic, readonly) NSUInteger currentPage;
@property (nonatomic, readonly) InfiniteScrollViewDirection direction;

/**
 *  Circular scroll enable.
 *  Default is YES.
 */
@property (nonatomic, assign) BOOL circularScrollEnabled;

/**
 *  Whether if scrollView can handle tap gesture.
 *  Setting YES will cause: 
 *      Tap gesture is exclusive to scrollView instead of subViews.
 *  So Use it especially when:
 *      Tap gesture isn't required by subViews.
 */
@property (nonatomic, assign) BOOL tapEnable;

/**
 *  Auto play supported.
 */
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) CGFloat autoPlayDuration; //default 3.0

/**
 *  Delegate & Data source
 */
@property (nonatomic, weak) id<InfiniteScrollViewDelegate> actionDelegate;
@property (nonatomic, weak) id<InfiniteScrollViewDataSource> dataSource;

/**
 *  Set page programmatically.
 *
 *  @param index    page index.
 *  @param animated animatable.
 */
- (void)setPage:(NSInteger)index animated:(BOOL)animated;
- (void)setPage:(NSInteger)index
     transition:(InfiniteScrollViewTransition)transition
       animated:(BOOL)animated;
- (void)moveByPages:(NSInteger)offset
           animated:(BOOL)animated;

/**
 *  You must set dataSource before invoke -reloadData.
 */
- (void)reloadData;

@end
