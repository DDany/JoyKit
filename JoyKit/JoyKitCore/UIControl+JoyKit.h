//
//  UIControl+JoyKit.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (JoyKit)

#pragma mark - Touch area
/**
 * In order to expand the area of hit testing.
 *  UIEdgeInsetsMake(-20, -20, -20, -20):
 *      -20 means enlarge 20 point.
 */
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;


#pragma mark - Block support
- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(void(^)(id sender))block;
- (void)removeHandlerForEvent:(UIControlEvents)event;

@end
