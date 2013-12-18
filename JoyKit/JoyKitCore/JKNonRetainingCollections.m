//
//  JKNonRetainingCollections.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKNonRetainingCollections.h"


NSMutableArray* JKCreateNonRetainingMutableArray(void)
{
    return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
}


NSMutableDictionary* JKCreateNonRetainingMutableDictionary(void)
{
    return (__bridge_transfer NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, nil, nil);
}


NSMutableSet* JKCreateNonRetainingMutableSet(void)
{
    return (__bridge_transfer NSMutableSet *)CFSetCreateMutable(nil, 0, nil);
}
