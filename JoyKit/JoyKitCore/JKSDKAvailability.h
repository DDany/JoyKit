//
//  JKSDKAvailability.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - SDK availibility
/**
 * For checking SDK feature availibility.
 *
 * JKIOS macros are defined in parallel to their __IPHONE_ counterparts as a consistently-defined
 * means of checking __IPHONE_OS_VERSION_MAX_ALLOWED.
 *
 * For example:
 *
 * @htmlonly
 * <pre>
 *     #if __IPHONE_OS_VERSION_MAX_ALLOWED >= JKIOS_3_2
 *       // This code will only compile on versions >= iOS 3.2
 *     #endif
 * </pre>
 * @endhtmlonly
 */

/**
 * Released on July 11, 2008
 */
#define JKIOS_2_0     20000

/**
 * Released on September 9, 2008
 */
#define JKIOS_2_1     20100

/**
 * Released on November 21, 2008
 */
#define JKIOS_2_2     20200

/**
 * Released on June 17, 2009
 */
#define JKIOS_3_0     30000

/**
 * Released on September 9, 2009
 */
#define JKIOS_3_1     30100

/**
 * Released on April 3, 2010
 */
#define JKIOS_3_2     30200

/**
 * Released on June 21, 2010
 */
#define JKIOS_4_0     40000

/**
 * Released on September 8, 2010
 */
#define JKIOS_4_1     40100

/**
 * Released on November 22, 2010
 */
#define JKIOS_4_2     40200

/**
 * Released on March 9, 2011
 */
#define JKIOS_4_3     40300

/**
 * Released on October 12, 2011.
 */
#define JKIOS_5_0     50000

/**
 * Released on March 7, 2012.
 */
#define JKIOS_5_1     50100

/**
 * Released on September 19, 2012.
 */
#define JKIOS_6_0     60000

/**
 * Released on January 28, 2013.
 */
#define JKIOS_6_1     60100

/**
 * Release unknown
 */
#define JKIOS_7_0     70000


/**
 * Checks whether the device is 4 inch.
 */
BOOL JKIs4InchDevice(void);

/**
 * Checks whether the device's iOS system version is 7.0 or later.
 */
BOOL JKIsIOS7OrLater(void);

/**
 * Checks whether the device the app is currently running on is an iPad or not.
 *
 *      @returns YES if the device is an iPad.
 */
BOOL JKIsPad(void);

/**
 * Checks whether the device the app is currently running on is an
 * iPhone/iPod touch or not.
 *
 *      @returns YES if the device is an iPhone or iPod touch.
 */
BOOL JKIsPhone(void);

/**
 * Fetch the screen's scale in an SDK-agnostic way. This will work on any pre-iOS 4.0 SDK.
 *
 * Pre-iOS 4.0: will always return 1.
 *     iOS 4.0: returns the device's screen scale.
 */
CGFloat JKScreenScale(void);

/**
 * Returns YES if the screen is a retina display, NO otherwise.
 */
BOOL JKIsRetina(void);

/**
 Get platform info in NSString.
 http://stackoverflow.com/questions/11197509/ios-iphone-get-device-model-and-make
 @"i386"        on the simulator
 @"iPod1,1"     on iPod Touch
 @"iPod2,1"     on iPod Touch Second Generation
 @"iPod3,1"     on iPod Touch Third Generation
 @"iPod4,1"     on iPod Touch Fourth Generation
 @"iPhone1,1"   on iPhone
 @"iPhone1,2"   on iPhone 3G
 @"iPhone2,1"   on iPhone 3GS
 @"iPad1,1"     on iPad
 @"iPad2,1"     on iPad 2
 @"iPad3,1"     on 3rd Generation iPad
 @"iPhone3,1"   on iPhone 4
 @"iPhone4,1"   on iPhone 4S
 @"iPhone5,1"   on iPhone 5 (model A1428, AT&T/Canada)
 @"iPhone5,2"   on iPhone 5 (model A1429, everything else)
 @"iPad3,4"     on 4th Generation iPad
 @"iPad2,5"     on iPad Mini
 */
NSString *JKPlatformString(void);
