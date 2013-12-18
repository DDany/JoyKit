//
//  JKSingletonObject.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/************************************************************************
 * Dependencies: None.
 * Base on: None.
 ************************************************************************/

#if DEBUG
    #define JK_SINGLETON_INSTANCE_LOG(x) NSLog(@"Singleton object <%s(%@)> has been created.",#x, [x class])
#else
    #define JK_SINGLETON_INSTANCE_LOG(x)
#endif

#define JK_SINGLETON_INSTANCE_METHOD_INTERFACE(ClassName) + (ClassName *)instance;
#define JK_SINGLETON_INSTANCE_METHOD_IMPL(ClassName) \
        + (ClassName *)instance \
        {   \
            static ClassName *_g_##ClassName##_obj = nil;  \
            static dispatch_once_t onceToken;   \
            dispatch_once(&onceToken, ^{    \
            _g_##ClassName##_obj = [[self singletonAlloc] init];    \
                JK_SINGLETON_INSTANCE_LOG(_g_##ClassName##_obj);   \
            }); \
            return _g_##ClassName##_obj;    \
        }

/**
 *  We suggest:
 *  Singleton class all over this project should be inherit from JKSingletonObject.
 *  Forcing everyone to use +singletonAlloc is good for your team.
 */
@interface JKSingletonObject : NSObject

+ (id)singletonAlloc;

@end
