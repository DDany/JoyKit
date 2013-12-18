//
//  JKFoundationMethods.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKFoundationMethods.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark -
#pragma mark CGRect Methods



CGRect JKRectContract(CGRect rect, CGFloat dx, CGFloat dy)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}



CGRect JKRectExpand(CGRect rect, CGFloat dx, CGFloat dy)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + dx, rect.size.height + dy);
}



CGRect JKRectShift(CGRect rect, CGFloat dx, CGFloat dy)
{
    return CGRectOffset(JKRectContract(rect, dx, dy), dx, dy);
}



CGRect JKEdgeInsetsOutsetRect(CGRect rect, UIEdgeInsets outsets)
{
    return CGRectMake(rect.origin.x - outsets.left,
                      rect.origin.y - outsets.top,
                      rect.size.width + outsets.left + outsets.right,
                      rect.size.height + outsets.top + outsets.bottom);
}



CGFloat JKCenterX(CGSize containerSize, CGSize size)
{
    return floorf((containerSize.width - size.width) / 2.f);
}



CGFloat JKCenterY(CGSize containerSize, CGSize size)
{
    return floorf((containerSize.height - size.height) / 2.f);
}


/////////////////////////////////////////////////////////////////////////////////////////////
CGRect JKFrameOfCenteredViewWithinView(UIView* viewToCenter, UIView* containerView)
{
    CGPoint origin;
    CGSize containerViewSize = containerView.bounds.size;
    CGSize viewSize = viewToCenter.frame.size;
    origin.x = JKCenterX(containerViewSize, viewSize);
    origin.y = JKCenterY(containerViewSize, viewSize);
    return CGRectMake(origin.x, origin.y, viewSize.width, viewSize.height);
}


/////////////////////////////////////////////////////////////////////////////////////////////
CGSize NISizeOfStringWithLabelProperties(NSString *string, CGSize constrainedToSize, UIFont *font, NSLineBreakMode lineBreakMode, NSInteger numberOfLines)
{
    if (string.length == 0) {
        return CGSizeZero;
    }
    
    CGFloat lineHeight = font.lineHeight;
    CGSize size = CGSizeZero;
    
    if (numberOfLines == 1) {
        size = [string sizeWithFont:font forWidth:constrainedToSize.width lineBreakMode:lineBreakMode];
        
    } else {
        size = [string sizeWithFont:font constrainedToSize:constrainedToSize lineBreakMode:lineBreakMode];
        if (numberOfLines > 0) {
            size.height = MIN(size.height, numberOfLines * lineHeight);
        }
    }
    
    return size;
}


#pragma mark -
#pragma mark Degrees & Radians
CGFloat JKDegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

CGFloat JKRadiansToDegrees(CGFloat radians)
{
    return radians * 180/M_PI;
}


#pragma mark -
#pragma mark NSData Methods



NSString* JKMD5HashFromData(NSData* data)
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, data.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15]
            ];
}



NSString* JKSHA1HashFromData(NSData* data)
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15], result[16], result[17], result[18], result[19]
            ];
}




#pragma mark -
#pragma mark General Purpose Methods


CGFloat boundf(CGFloat value, CGFloat min, CGFloat max)
{
    if (max < min) {
        max = min;
    }
    CGFloat bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}


NSInteger boundi(NSInteger value, NSInteger min, NSInteger max)
{
    if (max < min) {
        max = min;
    }
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

#pragma mark -
#pragma mark Language
BOOL JKIsChineseLanguage(void)
{
    NSString *language = [NSLocale preferredLanguages][0];
    if ([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hant"]) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark KVO Setter
void SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_TYPE objType, id from, id to, id fromKey, id toKey)
{
    if (!IS_NULL(from) && !IS_NULL(to) && !IS_NULL(fromKey) && !IS_NULL(toKey) && !IS_NULL([from valueForKey:fromKey])) {
        id fromValue = [from valueForKey:fromKey];
        if (![fromValue isKindOfClass:[NSDictionary class]] && ![fromValue isKindOfClass:[NSArray class]]) {
            BOOL fromValueIsNumber = [fromValue isKindOfClass:[NSNumber class]];
            switch (objType) {
                case SET_VALUE_OBJ_TYPE_STRING:
                {
                    [to setValue:(fromValueIsNumber ? [fromValue stringValue] : fromValue) forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_DATETIME:
                {
                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date = [inputFormatter dateFromString:(fromValueIsNumber ? [fromValue stringValue] : fromValue)];
                    [to setValue:date forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_DATE:
                {
                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [inputFormatter dateFromString:(fromValueIsNumber ? [fromValue stringValue] : fromValue)];
                    [to setValue:date forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_BOOL:
                {
                    [to setValue:(fromValueIsNumber ? fromValue : @([fromValue boolValue])) forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_DOUBLE:
                {
                    [to setValue:(fromValueIsNumber ? fromValue : @([fromValue doubleValue])) forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_FLOAT:
                {
                    [to setValue:(fromValueIsNumber ? fromValue : @([fromValue floatValue])) forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_INT:
                {
                    [to setValue:(fromValueIsNumber ? fromValue : @([fromValue intValue])) forKey:toKey];
                }
                    break;
                case SET_VALUE_OBJ_TYPE_LONG:
                {
                    [to setValue:(fromValueIsNumber ? fromValue : @([fromValue longValue])) forKey:toKey];
                }
                    break;
                default:break;
            }
        }
    }
}
