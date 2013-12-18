//
//  tabBarController.m
//  ShopSNS
//
//  Created by hyl on 13-12-3.
//  Copyright (c) 2013年 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKTabBarController.h"

#import "JKTabBar.h"

typedef NS_OPTIONS(NSUInteger, JKTabBarControllerScrollDirection)
{
    JKTabBarControllerScrollDirectionUp,
    JKTabBarControllerScrollDirectionDown
};

@interface JKTabBarController ()<JKTabBarDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) UIViewController *selectedViewController;

@property (nonatomic, strong) JKTabBar *tabBar;
@property (nonatomic, strong) UIView *contentContainerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isScrollViewObserving;
@property (nonatomic) BOOL tabBarHidden;
@property (nonatomic, assign) BOOL tabBarAnimating;

@end

@implementation JKTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        self.tabBar = [[JKTabBar alloc] initWithFrame:CGRectZero];
        self.viewControllers = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarHidden = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGRect f = CGRectMake(0.0f, self.view.bounds.size.height - self.tabBarHeight, self.view.bounds.size.width, self.tabBarHeight);
    if (!self.tabBar) {
        self.tabBar = [[JKTabBar alloc] initWithFrame:f];
    } else  {
        self.tabBar.frame = f;
    }
	
	self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBar.actionDelegate = self;
	[self.view addSubview:self.tabBar];
    
	self.contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarHeight)];
    self.contentContainerView.backgroundColor = [UIColor clearColor];
	self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.contentContainerView];
    
    [self.view bringSubviewToFront:self.tabBar];
    
    [self reloadTabButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBar.frame = CGRectMake(0.0f, self.view.bounds.size.height - self.tabBarHeight, self.view.bounds.size.width, self.tabBarHeight);
    self.contentContainerView.frame = CGRectMake(0.0f, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarHeight);
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}

#pragma mark - add content & button
- (void)reloadTabButtons
{
    self.tabBar.items = nil;

    NSMutableArray *array = @[].mutableCopy;
    if (!self.items) {
        [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *controller = obj;
            [array addObject:controller.tabBarItem];
        }];
        self.tabBar.items = array;
    } else {
        self.tabBar.items = self.items;
    }
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
    self.tabBar.selectedIndex = lastIndex;
}

#pragma mark - getter & setter

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    if (self.tabBar.selectedIndex != selectedIndex) {
        self.tabBar.selectedIndex = selectedIndex;
        return;
    }
    
    if (![self isViewLoaded]) {
		_selectedIndex = selectedIndex;
        
	} else if (_selectedIndex != selectedIndex) {
        UIViewController *fromViewController;
		UIViewController *toViewController;
        
        //has old selected controller
        if (_selectedIndex != NSNotFound) {
            fromViewController = self.selectedViewController;
        }
        
        NSUInteger oldIndex = _selectedIndex;
        _selectedIndex = selectedIndex;
        
        //has new select controller
        if (_selectedIndex != NSNotFound) {
            toViewController = self.selectedViewController;
        }
        if (!fromViewController || (NSNull *)fromViewController ==[NSNull null]) {
            if (!toViewController || (NSNull *)toViewController == [NSNull null]) {
                [self loadControllerAtIndex:_selectedIndex];
                toViewController = self.viewControllers[_selectedIndex];
            }
            toViewController.view.frame = self.contentContainerView.bounds;
            [self.contentContainerView addSubview:toViewController.view];
            if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectIndex:)]) {
                [self.delegate tabBarController:self didSelectIndex:_selectedIndex];
            }
        } else {
            if (!toViewController || (NSNull *)toViewController ==[NSNull null]) {
                [self loadControllerAtIndex:_selectedIndex];
                toViewController = self.viewControllers[_selectedIndex];
            }
            if (animated) {
                CGRect rect = self.contentContainerView.bounds;
                if (oldIndex < selectedIndex) {
                    rect.origin.x = rect.size.width;
                } else {
                    rect.origin.x = -rect.size.width;
                }
                
                toViewController.view.frame = rect;
                self.tabBar.userInteractionEnabled = NO;
                
                [self transitionFromViewController:fromViewController
                                  toViewController:toViewController
                                          duration:0.3f
                                           options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                        animations:^
                 {
                     CGRect rect = fromViewController.view.frame;
                     if (oldIndex < selectedIndex)
                         rect.origin.x = -rect.size.width;
                     else
                         rect.origin.x = rect.size.width;
                     
                     fromViewController.view.frame = rect;
                     [self loadControllerAtIndex:_selectedIndex];
                     toViewController.view.frame = self.contentContainerView.bounds;
                 }
                                        completion:^(BOOL finished)
                 {
                     self.tabBar.userInteractionEnabled = YES;
                     
                     if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectIndex:)]) {
                         [self.delegate tabBarController:self didSelectIndex:_selectedIndex];
                     }
                 }];
            } else {
                [fromViewController.view removeFromSuperview];
                [self loadControllerAtIndex:_selectedIndex];
                toViewController.view.frame = self.contentContainerView.bounds;
                [self.contentContainerView addSubview:toViewController.view];
                
                if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectIndex:)]) {
                    [self.delegate tabBarController:self didSelectIndex:_selectedIndex];
                }
            }
            
        }
    }

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
    if (index != NSNotFound) {
        [self setSelectedIndex:index animated:NO];
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound && self.selectedIndex < self.viewControllers.count) {
        return self.viewControllers[self.selectedIndex];
    }
    return nil;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    self.tabBar.items = items;
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.viewControllers addObject:[NSNull null]];
    }];
}

- (void)setAutoHideWithScrollView:(UIScrollView *)scrollView
{
    if (self.isScrollViewObserving) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    self.scrollView = scrollView;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    self.isScrollViewObserving = YES;
}

- (void)setBadgeValue:(NSString *)badgeValue forIndex:(NSUInteger)index
{
    [self.tabBar setBadgeValue:badgeValue forIndex:index];
}

#pragma mark
- (void)loadControllerAtIndex:(NSUInteger)index
{
    if (self.viewControllers[index] == [NSNull null]) {
        if ([self.delegate respondsToSelector:@selector(tabBarController:viewControllerForIndex:)]) {
            UIViewController *viewController = [self.delegate tabBarController:self viewControllerForIndex:self.selectedIndex];
            if (viewController) {
                [self.viewControllers replaceObjectAtIndex:index withObject:viewController];
                if (![[self childViewControllers] containsObject:viewController]) {
                    [self addChildViewController:viewController];
                }
            }
        }
    }
}

- (void)removeControllerAtIndex:(NSUInteger)index
{
    // out of bounds.
    if (index >= self.viewControllers.count) {
        return;
    }
    
    // remove current selected controller.
    if (index == self.selectedIndex) {
        _selectedIndex = NSNotFound;
    }
    
    // do remove stuff.
    UIViewController *viewController = self.viewControllers[index];
    if ((NSNull *)viewController != [NSNull null]) {
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        [self.viewControllers replaceObjectAtIndex:index withObject:[NSNull null]];
    }
    
    [self setBadgeValue:@"" forIndex:index];
}

#pragma mark - select&deselect tab buttons

- (CGFloat)tabBarHeight
{
	return 49.0f;
}

#pragma mark - tabBarDelegate
- (void)tabBarDidSelectedAtIndex:(NSUInteger)index
{
    [self setSelectedIndex:index animated:NO];
    
}

- (BOOL)tabBarShouldSelectedAtIndex:(NSUInteger)index
{
    BOOL shouldSelected = YES;
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectIndex:)]) {
        shouldSelected = [self.delegate tabBarController:self shouldSelectIndex:index];
    }
    return shouldSelected;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScrollOldOffset:[[change valueForKey:NSKeyValueChangeOldKey] CGPointValue]];
    }
}

#pragma mark - scroll observe action
- (void)scrollViewDidScrollOldOffset:(CGPoint)oldContentOffset
{
    // Area detect.
    if (self.scrollView.contentOffset.y > self.scrollView.contentSize.height - self.scrollView.bounds.size.height - 100) {
        return;
    }
    
    if (self.scrollView.contentOffset.y < 100) {
        if (self.tabBarHidden) {
            [self hideOrShowWhenScrollWithDirectionY:JKTabBarControllerScrollDirectionDown];
        }
        return;
    }
    
    // Ignore the tiny movement.
    CGFloat offset = fabsf(self.scrollView.contentOffset.y - oldContentOffset.y);
    // You can adjust the number as below -- scroll decelerating velocity.
    if (offset < 3) {
        return;
    }
    
    if (!self.scrollView.dragging) {
        return;
    }
    
    if (self.scrollView.contentOffset.y > oldContentOffset.y) {
        // Scroll up
        [self hideOrShowWhenScrollWithDirectionY:JKTabBarControllerScrollDirectionUp];
    } else {
        // Scroll down.
        [self hideOrShowWhenScrollWithDirectionY:JKTabBarControllerScrollDirectionDown];
    }
}

#pragma mark - hidden or show when scroll
- (void)hideOrShowWhenScrollWithDirectionY:(JKTabBarControllerScrollDirection)dirction
{
    if (dirction == JKTabBarControllerScrollDirectionUp) {
        //hide
        if (!self.tabBarHidden && !self.tabBarAnimating) {
            self.tabBarAnimating = YES;
            self.contentContainerView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tabBar.frame = CGRectMake(0, self.view.bounds.size.height, 320, self.tabBarHeight);
            }   completion:^(BOOL finished) {
                self.tabBarHidden = YES;
                self.tabBarAnimating = NO;
            }];
        }
    } else if (dirction == JKTabBarControllerScrollDirectionDown) {
        //show
        if (self.tabBarHidden && !self.tabBarAnimating) {
            self.tabBarAnimating = YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tabBar.frame = CGRectMake(0, self.view.bounds.size.height - self.tabBarHeight, 320, self.tabBarHeight);
                self.contentContainerView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - self.tabBarHeight);
            }   completion:^(BOOL finished) {
                self.tabBarHidden = NO;
                self.tabBarAnimating = NO;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
