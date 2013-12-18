//
//  NSString+JoyKit.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "NSString+JoyKit.h"
#import "JKFoundationMethods.h"

@implementation NSString (JoyKit)

/**
 * Calculates the height of this text given the font, max width, and line break mode.
 *
 * A convenience wrapper for sizeWithFont:constrainedToSize:lineBreakMode:
 */
// COV_NF_START
- (CGFloat)heightWithFont:(UIFont*)font
       constrainedToWidth:(CGFloat)width
            lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                lineBreakMode:lineBreakMode].height;
}
// COV_NF_END

#pragma mark 
/**
 * Parses a URL query string into a dictionary where the values are arrays.
 *
 * A query string is one that looks like &param1=value1&param2=value2...
 *
 * The resulting NSDictionary will contain keys for each parameter name present in the query.
 * The value for each key will be an NSArray which may be empty if the key is simply present
 * in the query. Otherwise each object in the array with be an NSString corresponding to a value
 * in the query for that parameter.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}


/**
 * Returns a string that has been escaped for use as a URL parameter.
 */
- (NSString *)stringByAddingPercentEscapesForURLParameter
{
    
    CFStringRef buffer =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)self,
                                            NULL,
                                            (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    
    NSString *result = [NSString stringWithString:(__bridge NSString *)buffer];
    
    CFRelease(buffer);
    
    return result;
}


/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query
{
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [[query objectForKey:key] stringByAddingPercentEscapesForURLParameter];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

#pragma mark
/**
 * Calculate the md5 hash using CC_MD5.
 *
 * @returns md5 hash of this string.
 */
- (NSString*)md5Hash
{
    return JKMD5HashFromData([self dataUsingEncoding:NSUTF8StringEncoding]);
}


/**
 * Calculate the SHA1 hash using CommonCrypto CC_SHA1.
 *
 * @returns SHA1 hash of this string.
 */
- (NSString*)sha1Hash
{
    return JKSHA1HashFromData([self dataUsingEncoding:NSUTF8StringEncoding]);
}


#pragma mark
- (BOOL)isValidEmailAddress
{
    if (self.length == 0) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
