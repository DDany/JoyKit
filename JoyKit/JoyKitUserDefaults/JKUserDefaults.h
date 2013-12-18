//
//  JKUserDefaults.h
//  ShopSNS
//
//  Created by Danny on 12/5/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/************************************************************************
 * Dependencies: JKSingletonObject.
 * Based on: GVUserDefaults. (https://github.com/gangverk/GVUserDefaults)
 ************************************************************************/

#import "JKSingletonObject.h"

@interface JKUserDefaults : JKSingletonObject

JK_SINGLETON_INSTANCE_METHOD_INTERFACE(JKUserDefaults)

@end
