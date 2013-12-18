//
//  JKCache.m
//  ShopSNS
//
//  Created by Danny on 12/13/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKCache.h"

@implementation JKCache

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end
