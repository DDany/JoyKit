//
//  JKInvocationMethods.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKInvocationMethods.h"
#import <objc/runtime.h>

NSInvocation *NIInvocationWithInstanceTarget(NSObject *targetObject, SEL selector)
{
    NSMethodSignature* sig = [targetObject methodSignatureForSelector:selector];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:targetObject];
    [inv setSelector:selector];
    return inv;
}

NSInvocation* NIInvocationWithClassTarget(Class targetClass, SEL selector)
{
    Method method = class_getInstanceMethod(targetClass, selector);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}