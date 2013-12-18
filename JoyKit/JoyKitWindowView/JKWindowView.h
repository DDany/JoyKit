//
//  JKWindowView.h
//  ShopSNS
//
//  Created by Danny on 12/13/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: JoyKitCore.
 * Based on: None.
 ************************************************************************/

/**
 *  Window based view. This view should be showed on top of both originalWindow and status bar.
 */
@interface JKWindowView : UIView

+ (void)showOnWindow:(UIWindow *)originalWindow animated:(BOOL)animated;

- (void)windowViewWillShow:(BOOL)animated;
- (void)windowViewDidShow:(BOOL)animated;
- (void)windowViewWillHide:(BOOL)animated;
- (void)windowViewDidHide:(BOOL)animated;

@end
