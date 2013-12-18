//
//  JKInvocationMethods.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
extern "C" {
#endif
    
/**
 * For filling in gaps in Apple's Foundation framework.
 *
 */
/**
 * NSInvocation extensions to make them easier to construct in concise code for things like button handlers
 * and such.
 */

/**
 * Construct an NSInvocation with an instance of an object and a selector
 *
 *  @return an NSInvocation that will call the given selector on the given target
 */
extern NSInvocation* JKInvocationWithInstanceTarget(NSObject* target, SEL selector);

/**
 * Construct an NSInvocation for a class method given a class object and a selector
 *
 *  @return an NSInvocation that will call the given class method/selector.
 */
extern NSInvocation* JKInvocationWithClassTarget(Class targetClass, SEL selector);
    
#if defined __cplusplus
};
#endif
