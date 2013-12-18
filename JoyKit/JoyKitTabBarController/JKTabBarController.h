//
//  SSTabBarController.h
//  ShopSNS
//
//  Created by hyl on 13-12-3.
//  Copyright (c) 2013年 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: JKTabBar.
 * Based on: None.
 ************************************************************************/




/**
 * Lazy loading tab bar controller.
 * @see JKTabBarControllerDelegate
 */

@class JKTabBar;
@protocol JKTabBarControllerDelegate;

@interface JKTabBarController : UIViewController

@property (nonatomic, strong, readonly) NSMutableArray *viewControllers;
@property (nonatomic, strong, readonly) JKTabBar *tabBar;

@property (nonatomic, assign) NSUInteger selectedIndex;

// array with UITabBarItem.
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id <JKTabBarControllerDelegate> delegate;

- (void)setBadgeValue:(NSString *)badgeValue forIndex:(NSUInteger)index;
- (void)removeControllerAtIndex:(NSUInteger)index;

- (void)setAutoHideWithScrollView:(UIScrollView *)scrollView;

@end

@protocol JKTabBarControllerDelegate <NSObject>
@required
- (UIViewController *)tabBarController:(JKTabBarController *)tabBarController viewControllerForIndex:(NSUInteger)index;
@optional
- (BOOL)tabBarController:(JKTabBarController *)tabBarController shouldSelectIndex:(NSUInteger)index;
- (void)tabBarController:(JKTabBarController *)tabBarController didSelectIndex:(NSUInteger)index;

@end
