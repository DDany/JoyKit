//
//  JKSingletonObject.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKSingletonObject.h"

@implementation JKSingletonObject

/**
 * Override this method is to prevent other coders from coding "[[Singleton alloc] init]".
 * You should never use alloc yourself. Please write +instance in your own sub-class.
 * Please refer to class method +instance in Singleton.h.
 */
+ (id)alloc
{
    @throw [NSException exceptionWithName:@"Singleton Mode Rules"
                                   reason:@"Forbid using -alloc to create this object yourself, please use +singletonAlloc instead."
                                 userInfo:@{}];
    return nil;
}

+ (id)singletonAlloc
{
    return [super alloc];
}

@end
