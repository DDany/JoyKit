//
//  NSString+JoyKit.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JoyKit)

#pragma mark Display

- (CGFloat)heightWithFont:(UIFont*)font
       constrainedToWidth:(CGFloat)width
            lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark URL queries

- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringByAddingPercentEscapesForURLParameter;
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

#pragma mark Hashing

@property (nonatomic, readonly) NSString* md5Hash;
@property (nonatomic, readonly) NSString* sha1Hash;

#pragma mark Formatted string
@property (nonatomic, readonly) BOOL isValidEmailAddress;

@end
