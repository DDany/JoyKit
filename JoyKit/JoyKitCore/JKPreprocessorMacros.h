//
//  JKPreprocessorMacros.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#pragma mark
/**
 * Mark a method or property as deprecated to the compiler.
 *
 * Any use of a deprecated method or property will flag a warning when compiling.
 *
 * Borrowed from Apple's AvailabiltyInternal.h header.
 *
 * @htmlonly
 * <pre>
 *   __AVAILABILITY_INTERNAL_DEPRECATED         __attribute__((deprecated))
 * </pre>
 * @endhtmlonly
 */
#define __JK_DEPRECATED_METHOD __attribute__((deprecated))

/**
 * Force a category to be loaded when an app starts up.
 *
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */
#define JK_FIX_CATEGORY_BUG(name) @interface JK_FIX_CATEGORY_BUG_##name : NSObject @end \
@implementation JK_FIX_CATEGORY_BUG_##name @end


#pragma mark
/**
 * Creates an opaque UIColor object from a byte-value color definition.
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

/**
 * Creates a UIColor object from a byte-value color definition and alpha transparency.
 */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]




#pragma mark - Block helper
/**
 * Block helper
 *
 * obj should be any subclass of NSObject.
 *s
 * DEFINE_WEAK_PTR(object) can generate a weak refference to the object called w_object.
 *      DEFINE_WEAK_PTR(object); <=> typeof(object) __weak w_object = object;
 * DEFINE_STRONG_PTR(object) can generate a strong refference to the object called s_object.
 *      DEFINE_STRONG_PTR(object); <=> typeof(object) __strong s_object = object;
 *
 */
#define DEFINE_WEAK_PTR(obj) typeof(obj) __weak w_##obj = obj
#define DEFINE_STRONG_PTR(obj) typeof(obj) __strong s_##obj = obj

