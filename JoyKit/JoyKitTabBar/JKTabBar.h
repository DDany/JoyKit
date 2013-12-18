//
//  JKTabBar.h
//  TestDemo
//
//  Created by hyl on 13-11-5.
//  Copyright (c) 2013年 hyl. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: JKBadgeView.
 * Based on: None.
 ************************************************************************/

@protocol JKTabBarDelegate <NSObject>

@optional
- (BOOL)tabBarShouldSelectedAtIndex:(NSUInteger)index;
@required
- (void)tabBarDidSelectedAtIndex:(NSUInteger)index;
@end

@interface JKTabBar : UIView

@property (nonatomic, weak) id<JKTabBarDelegate> actionDelegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeTextColor;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

- (void)setTabBarTitles:(NSArray *)titles subTitles:(NSArray *)subTitles;
- (void)setTabBarSubTitles:(NSArray *)subTitles;
- (void)setTabBarTitles:(NSArray *)titles;
- (void)setBadgeValue:(NSString *)badgeValue forIndex:(NSUInteger)index;

@end
