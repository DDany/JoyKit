//
//  JKSDKAvailability.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKSDKAvailability.h"
#import <sys/utsname.h>

BOOL JKIs4InchDevice(void)
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            return YES;
        } else {
            /*Do iPhone Classic stuff here.*/
            return NO;
        }
    } else {
        /*Do iPad stuff here.*/
        return NO;
    }
}

BOOL JKIsIOS7OrLater(void)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        return YES;
    } else {
        return NO;
    }
}

BOOL JKIsPad(void)
{
    static NSInteger isPad = -1;
    if (isPad < 0) {
        isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0;
    }
    return isPad > 0;
}


BOOL JKIsPhone(void)
{
    static NSInteger isPhone = -1;
    if (isPhone < 0) {
        isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 1 : 0;
    }
    return isPhone > 0;
}

CGFloat JKScreenScale(void)
{
    static int respondsToScale = -1;
    if (respondsToScale == -1) {
        // Avoid calling this anymore than we need to.
        respondsToScale = !!([[UIScreen mainScreen] respondsToSelector:@selector(scale)]);
    }
    
    if (respondsToScale) {
        return [[UIScreen mainScreen] scale];
        
    } else {
        return 1;
    }
}


BOOL JKIsRetina(void)
{
    return JKScreenScale() == 2.f;
}

NSString *JKPlatformString(void)
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
