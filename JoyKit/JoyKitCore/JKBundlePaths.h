//
//  JKBundlePaths.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
extern "C" {
#endif
    
/**
 * For creating standard system paths.
 *
 * Create a path with the given bundle and the relative path appended.
 *
 *      @param bundle        The bundle to append relativePath to. If nil, [NSBundle mainBundle]
 *                           will be used.
 *      @param relativePath  The relative path to append to the bundle's path.
 *
 *      @returns The bundle path concatenated with the given relative path.
 */
NSString* JKPathForBundleResource(NSBundle* bundle, NSString* relativePath, BOOL createIfNeeded);

/**
 * Create a path with the documents directory and the relative path appended.
 *
 *      @returns The documents path concatenated with the given relative path.
 */
NSString* JKPathForDocumentsResource(NSString* relativePath, BOOL createIfNeeded);

/**
 * Create a path with the Library directory and the relative path appended.
 *
 *      @returns The Library path concatenated with the given relative path.
 */
NSString* JKPathForLibraryResource(NSString* relativePath, BOOL createIfNeeded);

/**
 * Create a path with the caches directory and the relative path appended.
 *
 *      @returns The caches path concatenated with the given relative path.
 */
NSString* JKPathForCachesResource(NSString* relativePath, BOOL createIfNeeded);
    
/**
 * Check whether if path exsit.
 *
 *      @param path             path to be checked
 *      @param createIfNeeded   create path if flag is YES.
 */
BOOL JKCheckPathExsit(NSString *path, BOOL createIfNeeded);
    
#if defined __cplusplus
};
#endif
