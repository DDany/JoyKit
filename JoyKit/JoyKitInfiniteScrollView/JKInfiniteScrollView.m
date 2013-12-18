//
//  JKInfiniteScrollView.m
//  ShopSNS
//
//  Created by Danny on 11/15/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKInfiniteScrollView.h"

typedef NS_OPTIONS(NSUInteger, InfiniteScrollViewScrollDirection) {
    InfiniteScrollViewScrollDirectionBackward,
    InfiniteScrollViewScrollDirectionForward
};

@interface JKInfiniteScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) InfiniteScrollViewDirection direction;
@property (nonatomic, assign) NSUInteger numberOfPages;

// Auto play
@property (nonatomic, assign) BOOL isAutoPlaying;
@property (nonatomic, strong) NSTimer *autoPlayTimer;

// Tap
@property (nonatomic, strong) UITapGestureRecognizer *interalTapGesture;

@end

@implementation JKInfiniteScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame direction:InfiniteScrollViewDirectionHorizontal];
}

- (id)initWithFrame:(CGRect)frame direction:(InfiniteScrollViewDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.direction = direction;
    }
    return self;
}

- (void)commonInit
{
    self.tapEnable = NO;
    self.direction = InfiniteScrollViewDirectionHorizontal;
    self.circularScrollEnabled = YES;
    self.autoPlayDuration = 0.4;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    if (self.direction == InfiniteScrollViewDirectionHorizontal) {
        self.contentSize = CGSizeMake(self.frame.size.width*5.0f, self.contentSize.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height*5.0f);
        
    }
    self.delegate = self;
    
    self.currentPage = NSNotFound;
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.bounces = YES;
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollViewDidEndDragging:)]) {
        [self.actionDelegate infiniteScrollViewDidEndDragging:self];
    }
    [self autoPlayResume];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self autoPlayPause];
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollViewWillBeginDragging:)]) {
        [self.actionDelegate infiniteScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isAutoPlaying) return;
    
    CGFloat offset = (self.direction == InfiniteScrollViewDirectionHorizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y;
    CGFloat size = (self.direction == InfiniteScrollViewDirectionHorizontal) ? self.frame.size.width : self.frame.size.height;
    
    
    // with two pages only scrollview you can only go forward
    // (this prevents us to have a glitch with the next UIView (it can't be placed in two positions at the same time)
    InfiniteScrollViewScrollDirection proposedScroll =
    (offset <= (size*2) ?
     // we're moving back
     InfiniteScrollViewScrollDirectionBackward :
     // we're moving forward
     InfiniteScrollViewScrollDirectionForward);
    
    // you can go back if circular mode is enabled or your current page is not the first page
    BOOL canScrollBackward = (self.circularScrollEnabled || (!self.circularScrollEnabled && self.currentPage != 0));
    // you can go forward if circular mode is enabled and current page is not the last page
    BOOL canScrollForward = (self.circularScrollEnabled || (!self.circularScrollEnabled && self.currentPage < (self.numberOfPages-1)));
    
    NSInteger prevPage = [self pageIndexByAdding:-1 from:self.currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:self.currentPage];
    if (prevPage == nextPage) {
        // This happends when our scrollview have only two and we should have the same prev/next page at left/right
        // A single UIView instance can't be in two different location at the same moment so we need to place it
        // loooking at proposed direction
        [self loadContainerAtIndex:prevPage andPlaceAtIndex:(proposedScroll == InfiniteScrollViewScrollDirectionBackward ? -1 : 1)];
    }
    
    if ((proposedScroll == InfiniteScrollViewScrollDirectionBackward && !canScrollBackward) ||
        (proposedScroll == InfiniteScrollViewScrollDirectionForward && !canScrollForward)) {
        self.bounces = NO;
        [scrollView setContentOffset:[self createPoint:size*2] animated:NO];
        return;
    } else self.bounces = YES;
    
    NSInteger newPageIndex = self.currentPage;
    
    if (offset <= size)
        newPageIndex = [self pageIndexByAdding:-1 from:self.currentPage];
    else if (offset >= (size*3))
        newPageIndex = [self pageIndexByAdding:+1 from:self.currentPage];
    
    [self setPage:newPageIndex];
    
    // alert delegate
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollViewDidScroll:at:)])
        [self.actionDelegate infiniteScrollViewDidScroll:self at:[self visibleRect].origin];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollViewWillBeginDecelerating:)]) {
        [self.actionDelegate infiniteScrollViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollViewDidEndDecelerating:atPageIndex:)]) {
        [self.actionDelegate infiniteScrollViewDidEndDecelerating:self atPageIndex:self.currentPage];
    }
}


#pragma mark - Reload
- (void)reloadData
{
    self.numberOfPages = [self.dataSource numberOfPagesInInfiniteScrollView:self];
    if (self.numberOfPages) {
        self.scrollEnabled = self.numberOfPages > 1;
        [self setPage:0];
        [self autoPlayResume];
    }
}

#pragma mark - Tap
- (void)setTapEnable:(BOOL)tapEnable
{
    _tapEnable = tapEnable;
    if (_tapEnable && !self.interalTapGesture) {
        self.interalTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:self.interalTapGesture];
    }
    self.interalTapGesture.enabled = _tapEnable;
}

#pragma mark - Auto play
- (void)setAutoPlay:(BOOL)autoPlay
{
    _autoPlay = autoPlay;
    [self reloadData];
}

- (void)autoPlayGoToNextPage:(id)timer
{
    NSInteger nextPage = self.currentPage+1;
    if (nextPage >= self.numberOfPages) {
        nextPage = 0;
    }
    [self setPage:nextPage animated:YES];
}

- (void)autoPlayPause
{
    if(self.autoPlayTimer)
    {
        [self.autoPlayTimer invalidate];
        self.autoPlayTimer = nil;
    }
}

- (void)autoPlayResume
{
    if (self.autoPlayTimer) {
        [self.autoPlayTimer invalidate];
        self.autoPlayTimer = nil;
    }
    
    if (self.autoPlay) {
        self.autoPlayTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoPlayDuration
                                                              target:self
                                                            selector:@selector(autoPlayGoToNextPage:)
                                                            userInfo:nil
                                                             repeats:YES];
    }
}

#pragma mark - Tap
- (void)tapHandler:(UITapGestureRecognizer *)tap
{
    if (self.actionDelegate &&
        [self.actionDelegate respondsToSelector:@selector(infiniteScrollView:didTapAtPageIndex:)]) {
        [self.actionDelegate infiniteScrollView:self didTapAtPageIndex:self.currentPage];
    }
}

#pragma mark - Action
- (void)setPage:(NSInteger)index
{
    if (index == self.currentPage) return;
    self.currentPage = index;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger prevPage = [self pageIndexByAdding:-1 from:self.currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:self.currentPage];
    
    [self loadContainerAtIndex:prevPage andPlaceAtIndex:-1];   // load previous page
    [self loadContainerAtIndex:index andPlaceAtIndex:0];       // load current page
    [self loadContainerAtIndex:nextPage andPlaceAtIndex:1];   // load next page
    
    CGFloat size =(self.direction == InfiniteScrollViewDirectionHorizontal) ? self.frame.size.width : self.frame.size.height;
    
    self.contentOffset = [self createPoint:size*2.]; // recenter
    
    if ([self.actionDelegate respondsToSelector:@selector(infiniteScrollView:currentPageChanged:)]) {
        [self.actionDelegate infiniteScrollView:self currentPageChanged:self.currentPage];
    }
}

- (void)setPage:(NSInteger)index animated:(BOOL)animated
{
    [self setPage:index transition:InfiniteScrollViewTransitionForward animated:animated];
}

- (void)setPage:(NSInteger)index transition:(InfiniteScrollViewTransition)transition animated:(BOOL)animated
{
    if (index == self.currentPage) return;
    
    if (animated) {
        CGPoint finalOffset;
        
        if (transition == InfiniteScrollViewTransitionAuto) {
            if (index > self.currentPage) transition = InfiniteScrollViewTransitionForward;
            else if (index < self.currentPage) transition = InfiniteScrollViewTransitionBackward;
        }
        
        CGFloat size =(self.direction == InfiniteScrollViewDirectionHorizontal) ? self.frame.size.width : self.frame.size.height;
        
        if (transition == InfiniteScrollViewTransitionForward) {
            [self loadContainerAtIndex:index andPlaceAtIndex:1];
            finalOffset = [self createPoint:(size*3)];
        } else {
            [self loadContainerAtIndex:index andPlaceAtIndex:-1];
            finalOffset = [self createPoint:(size*1)];
        }
        self.isAutoPlaying = YES;
        [UIView animateWithDuration:self.autoPlayDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.contentOffset = finalOffset;
                         } completion:^(BOOL finished) {
                             if (!finished) return;
                             [self setPage:index];
                             self.isAutoPlaying = NO;
                         }];
    } else {
        [self setPage:index];
    }
}

- (void)moveByPages:(NSInteger)offset animated:(BOOL)animated
{
    NSUInteger finalIndex = [self pageIndexByAdding:offset from:self.currentPage];
    InfiniteScrollViewTransition transition = (offset >= 0 ?  InfiniteScrollViewTransitionForward :
                                               InfiniteScrollViewTransitionBackward);
    [self setPage:finalIndex transition:transition animated:animated];
}

#pragma mark - Private
- (CGRect)visibleRect
{
    CGRect visibleRect;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
    return visibleRect;
}

- (CGPoint)createPoint:(CGFloat)size
{
    if (self.direction == InfiniteScrollViewDirectionHorizontal) {
        return CGPointMake(size, 0);
    } else {
        return CGPointMake(0, size);
    }
}

- (NSInteger)pageIndexByAdding:(NSInteger)offset from:(NSInteger)index
{
    // Complicated stuff with negative modulo
    while (offset<0) offset += self.numberOfPages;
    return (self.numberOfPages+index+offset) % self.numberOfPages;
}

- (void)loadContainerAtIndex:(NSInteger)index andPlaceAtIndex:(NSInteger)destIndex
{
    id container = [self.dataSource infiniteScrollView:self dataAtIndex:index];
    UIView *containerView = nil;
    
    if ([container isKindOfClass:[UIViewController class]]) {
        containerView = ((UIViewController *)container).view;
    } else if ([container isKindOfClass:[UIView class]]) {
        containerView = container;
    } else if ([container isKindOfClass:[UIImage class]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = container;
        containerView = imageView;
    } else {
        containerView = [[UIView alloc] init];
    }
    
    if (self.direction == InfiniteScrollViewDirectionHorizontal) {
        containerView.frame = CGRectMake(self.frame.size.width*(destIndex+2),
                                               0,
                                               self.frame.size.width,
                                               self.frame.size.height);
    } else {
        containerView.frame = CGRectMake(0,
                                               self.frame.size.height*(destIndex+2),
                                               self.frame.size.width,
                                               self.frame.size.height);
        
    }
    [self addSubview:containerView];
}

@end
