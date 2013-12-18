//
//  UITabBarItem+JKTabBar.m
//  ShopSNS
//
//  Created by Danny on 12/12/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "UITabBarItem+JKTabBar.h"
#import <objc/runtime.h>

static const NSString *KEY_TABBAR_SUB_TITLE = @"tabbarSubTitle";

@implementation UITabBarItem (JKTabBar)

- (void)setSubTitle:(NSString *)subTitle
{
    objc_setAssociatedObject(self, &KEY_TABBAR_SUB_TITLE, subTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)subTitle
{
    NSString *sub = (NSString *)objc_getAssociatedObject(self, &KEY_TABBAR_SUB_TITLE);
    return sub;
}

@end
