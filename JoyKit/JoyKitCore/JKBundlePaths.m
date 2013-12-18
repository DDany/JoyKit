//
//  JKBundlePaths.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKBundlePaths.h"

NSString* JKPathForBundleResource(NSBundle* bundle, NSString* relativePath, BOOL createIfNeeded)
{
    NSString* resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:relativePath];
    
    if (createIfNeeded) {
        JKCheckPathExsit(path, YES);
    }
    
    return path;
}


NSString* JKPathForDocumentsResource(NSString* relativePath, BOOL createIfNeeded)
{
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    NSString *path = [documentsPath stringByAppendingPathComponent:relativePath];
    
    if (createIfNeeded) {
        JKCheckPathExsit(path, YES);
    }
    
    return path;
}


NSString* JKPathForLibraryResource(NSString* relativePath, BOOL createIfNeeded)
{
    static NSString* libraryPath = nil;
    if (nil == libraryPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        libraryPath = [dirs objectAtIndex:0];
    }
    NSString *path = [libraryPath stringByAppendingPathComponent:relativePath];
    
    if (createIfNeeded) {
        JKCheckPathExsit(path, YES);
    }
    
    return path;
}


NSString* JKPathForCachesResource(NSString* relativePath, BOOL createIfNeeded)
{
    static NSString* cachesPath = nil;
    if (nil == cachesPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        cachesPath = [dirs objectAtIndex:0];
    }
    NSString *path = [cachesPath stringByAppendingPathComponent:relativePath];
    
    if (createIfNeeded) {
        JKCheckPathExsit(path, YES);
    }
    
    return path;
}

BOOL JKCheckPathExsit(NSString *path, BOOL createIfNeeded)
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        return YES;
    }
    
    if (createIfNeeded) {
        [manager createDirectoryAtPath:path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    return NO;
}

