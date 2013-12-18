//
//  UINavigationController+JoyKit.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPreprocessorMacros.h"

@interface UINavigationController (JoyKit)

+ (UINavigationController *)controllerWithRootViewController:(UIViewController *)rootViewController __JK_DEPRECATED_METHOD;

@end
