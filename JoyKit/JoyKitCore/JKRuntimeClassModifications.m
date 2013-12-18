//
//  JKRuntimeClassModifications.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKRuntimeClassModifications.h"
#import <objc/runtime.h>

void NISwapInstanceMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}


void NISwapClassMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}
