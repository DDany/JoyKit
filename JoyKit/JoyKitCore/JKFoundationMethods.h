//
//  JKFoundationMethods.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
extern "C" {
#endif


#pragma mark -
#pragma mark CGRect Methods

/**
 * Modifies only the right and bottom edges of a CGRect.
 *
 *      @return a CGRect with dx and dy subtracted from the width and height.
 *
 *      Example result: CGRectMake(x, y, w - dx, h - dy)
 */
CGRect JKRectContract(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * Modifies only the right and bottom edges of a CGRect.
 *
 *      @return a CGRect with dx and dy added to the width and height.
 *
 *      Example result: CGRectMake(x, y, w + dx, h + dy)
 */
CGRect JKRectExpand(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * Modifies only the top and left edges of a CGRect.
 *
 *      @return a CGRect whose origin has been offset by dx, dy, and whose size has been
 *              contracted by dx, dy.
 *
 *      Example result: CGRectMake(x + dx, y + dy, w - dx, h - dy)
 */
CGRect JKRectShift(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * Inverse of UIEdgeInsetsInsetRect.
 *
 *      Example result: CGRectMake(x - left, y - top,
 *                                 w + left + right, h + top + bottom)
 */
CGRect JKEdgeInsetsOutsetRect(CGRect rect, UIEdgeInsets outsets);

/**
 * Returns the x position that will center size within containerSize.
 *
 *      Example result: floorf((containerSize.width - size.width) / 2.f)
 */
CGFloat JKCenterX(CGSize containerSize, CGSize size);

/**
 * Returns the y position that will center size within containerSize.
 *
 *      Example result: floorf((containerSize.height - size.height) / 2.f)
 */
CGFloat JKCenterY(CGSize containerSize, CGSize size);

/**
 * Returns a rect that will center viewToCenter within containerView.
 *
 *      @return a CGPoint that will center viewToCenter within containerView.
 */
CGRect JKFrameOfCenteredViewWithinView(UIView* viewToCenter, UIView* containerView);

/**
 * Returns the size of the string with given UILabel properties.
 */
CGSize JKSizeOfStringWithLabelProperties(NSString *string, CGSize constrainedToSize, UIFont *font, NSLineBreakMode lineBreakMode, NSInteger numberOfLines);



#pragma mark -
#pragma mark Degrees & Radians
CGFloat JKDegreesToRadians(CGFloat degrees);
CGFloat JKRadiansToDegrees(CGFloat radians);
    

#pragma mark -
#pragma mark NSData Methods
    
/**
 * For manipulating NSData.
 *
 * @defgroup NSData-Methods NSData Methods
 * @{
 */

/**
 * Calculates an md5 hash of the data using CC_MD5.
 */
NSString* JKMD5HashFromData(NSData* data);

/**
 * Calculates a sha1 hash of the data using CC_SHA1.
 */
NSString* JKSHA1HashFromData(NSData* data);



    
#pragma mark -
#pragma mark General Purpose Methods
    
/**
 * For general purpose foundation type manipulation.
 *
 * @defgroup General-Purpose-Methods General Purpose Methods
 * @{
 */

/**
 * Bounds a given value within the min and max values.
 *
 * If max < min then value will be min.
 *
 *      @returns min <= result <= max
 */
CGFloat boundf(CGFloat value, CGFloat min, CGFloat max);

/**
 * Bounds a given value within the min and max values.
 *
 * If max < min then value will be min.
 *
 *      @returns min <= result <= max
 */
NSInteger boundi(NSInteger value, NSInteger min, NSInteger max);



    
    

    
#pragma mark - Language
/**
 * Checks whether the device now is chinese language using.
 */
BOOL JKIsChineseLanguage(void);
    
    
    
    
    
#pragma mark - KVO Setter

typedef NS_ENUM(NSUInteger, SET_VALUE_OBJ_TYPE_TYPE) {
    SET_VALUE_OBJ_TYPE_INT,
    SET_VALUE_OBJ_TYPE_LONG,
    SET_VALUE_OBJ_TYPE_FLOAT,
    SET_VALUE_OBJ_TYPE_DOUBLE,
    SET_VALUE_OBJ_TYPE_BOOL,
    SET_VALUE_OBJ_TYPE_STRING,
    SET_VALUE_OBJ_TYPE_DATE,
    SET_VALUE_OBJ_TYPE_DATETIME
};
    
#define IS_NULL(obj)	(nil == obj || (id)obj == [NSNull null])

#define SET_VALUE_INT(from, to, commonKey) SET_VALUE_INT_EX(from, to, commonKey, commonKey)
#define SET_VALUE_INT_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_INT, from, to, fromKey, toKey)
   
#define SET_VALUE_LONG(from, to, commonKey) SET_VALUE_LONG_EX(from, to, commonKey, commonKey)
#define SET_VALUE_LONG_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_LONG, from, to, fromKey, toKey)
    
#define SET_VALUE_FLOAT(from, to, commonKey) SET_VALUE_FLOAT_EX(from, to, commonKey, commonKey)
#define SET_VALUE_FLOAT_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_FLOAT, from, to, fromKey, toKey)
    
#define SET_VALUE_DOUBLE(from, to, commonKey) SET_VALUE_DOUBLE_EX(from, to, commonKey, commonKey)
#define SET_VALUE_DOUBLE_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_DOUBLE, from, to, fromKey, toKey)
    
#define SET_VALUE_BOOL(from, to, commonKey) SET_VALUE_BOOL_EX(from, to, commonKey, commonKey)
#define SET_VALUE_BOOL_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_BOOL, from, to, fromKey, toKey)
    
#define SET_VALUE_STR(from, to, commonKey) SET_VALUE_STR_EX(from, to, commonKey, commonKey)
#define SET_VALUE_STR_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_STRING, from, to, fromKey, toKey)
    
#define SET_VALUE_DATE(from, to, commonKey) SET_VALUE_DATE_EX(from, to, commonKey, commonKey)
#define SET_VALUE_DATE_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_DATE, from, to, fromKey, toKey)
    
#define SET_VALUE_DATETIME(from, to, commonKey) SET_VALUE_DATETIME_EX(from, to, commonKey, commonKey)
#define SET_VALUE_DATETIME_EX(from, to, fromKey, toKey) SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_DATETIME, from, to, fromKey, toKey)
    

/*****************************************************
 * Safety set value from ObjA to ObjB.
 * Generally:
 *  ObjA is NSDictionary from json response of network.
 *  ObjB is NSManagedObject from coredata.
 * You can also use it in any cases (NSObject & NSObject, NSKeyValueCoding comfortable).
 *****************************************************/
void SET_VALUE_BASE(SET_VALUE_OBJ_TYPE_TYPE objType, id from, id to, id fromKey, id toKey);
    
    

    


#if defined __cplusplus
};
#endif