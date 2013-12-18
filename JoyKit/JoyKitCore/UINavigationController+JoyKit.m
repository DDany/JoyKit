//
//  UINavigationController+JoyKit.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "UINavigationController+JoyKit.h"

@implementation UINavigationController (JoyKit)

+ (UINavigationController *)controllerWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    return navigation;
}

@end
