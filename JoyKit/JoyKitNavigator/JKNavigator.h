//
//  JKNavigator.h
//  ShopSNS
//
//  Created by Danny on 13-9-2.
//  Copyright (c) 2013年 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/************************************************************************
 * Dependencies: 
    JKSingletonObject,
    JKViewController.
 * Based on: TTNavigator.
 ************************************************************************/

#import "JKSingletonObject.h"

@interface JKNavigator : JKSingletonObject

JK_SINGLETON_INSTANCE_METHOD_INTERFACE(JKNavigator)

/**
 * The window that contains the view controller hierarchy.
 */
@property (nonatomic, readonly) UIWindow *window;

/**
 * The controller that is at the root of the view controller hierarchy.
 */
@property (nonatomic, readonly) UIViewController* rootViewController;

/**
 * Removes all view controllers from the window and releases them.
 */
- (void)removeAllViewControllers;

/**
 * Register class.
 */
- (void)registerNavigationSubclass:(Class)navigationSubclass;

/**
 * Push view controller in global navigator.
 * lightweight API for [Push & Present ViewController].
 * I think it's more suitable than Url-based in Three20 for us. Here are some reasons:
 * => 1. APIs look like official APIs.
 * => 2. Easy to know the Class name without importing the header.
 * => 3. More controllable for us.
 */
- (UIViewController *)pushViewController:(NSString *)classString
                                animated:(BOOL)animated;
- (UIViewController *)pushViewController:(NSString *)classString
                               withQuery:(id)query
                                animated:(BOOL)animated;

- (UIViewController *)pushNibViewController:(NSString *)classString
                                   animated:(BOOL)animated;
- (UIViewController *)pushNibViewController:(NSString *)classString
                                  withQuery:(id)query
                                   animated:(BOOL)animated;

- (UIViewController *)presentViewController:(NSString *)classString
                                   animated:(BOOL)animated;
- (UIViewController *)presentViewController:(NSString *)classString
                                  withQuery:(id)query
                                   animated:(BOOL)animated;
- (UIViewController *)presentViewController:(NSString *)classString
                                  withQuery:(id)query
                                   animated:(BOOL)animated
                                 completion:(void(^)(void))completion;

- (UIViewController *)presentNibViewController:(NSString *)classString
                                      animated:(BOOL)animated;
- (UIViewController *)presentNibViewController:(NSString *)classString
                                     withQuery:(id)query
                                      animated:(BOOL)animated;
- (UIViewController *)presentNibViewController:(NSString *)classString
                                     withQuery:(id)query
                                      animated:(BOOL)animated
                                    completion:(void(^)(void))completion;

@end
