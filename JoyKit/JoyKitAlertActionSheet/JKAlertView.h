//
//  SSAlertView.h
//  DolphinSharing
//
//  Created by Zheng Wang on 13-1-17.
//  Copyright (c) 2013年 Zheng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: None.
 * Base on: None.
 ************************************************************************/

@interface JKAlertView : UIAlertView

typedef void(^JKAlertViewButtonHandler)(JKAlertView* alert, NSInteger buttonIndex);
@property (nonatomic, copy) JKAlertViewButtonHandler buttonHandler;

/////////////////////////////////////////////////////////////////////////////

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
              cancelButton:(NSString *)cancelButtonTitle
              otherButtons:(NSArray *)otherButtonTitles
            onButtonTapped:(JKAlertViewButtonHandler)handler;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
              cancelButton:(NSString *)cancelButtonTitle
                  okButton:(NSString *)okButton // same as using a 1-item array for otherButtons
            onButtonTapped:(JKAlertViewButtonHandler)handler;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             dismissButton:(NSString *)dismissButtonTitle;

- (id)initWithTitle:(NSString *)title message:(NSString *)message
       cancelButton:(NSString *)cancelButtonTitle
       otherButtons:(NSArray *)otherButtonTitles
     onButtonTapped:(JKAlertViewButtonHandler)handler;

/////////////////////////////////////////////////////////////////////////////

/**
 * Show the AlertView that will dismiss after timeoutInSeconds seconds, by simulating a tap on the timeoutButtonIndex button after this delay.
 *
 * This method uses the @"(Alert dismissed in %lus)" timeout message format by default.
 */
- (void)showWithTimeout:(unsigned long)timeoutInSeconds
     timeoutButtonIndex:(NSInteger)timeoutButtonIndex;

/**
 * Show the AlertView that will dismiss after timeoutInSeconds seconds, by simulating a tap on the timeoutButtonIndex button after this delay.
 *
 * The countDownMessageFormat is a string containing a %lu placeholder to customize the countdown message displayed in the alert.
 * If countDownMessageFormat is nil, no countdown message is added to the alert message.
 */
- (void)showWithTimeout:(unsigned long)timeoutInSeconds
     timeoutButtonIndex:(NSInteger)timeoutButtonIndex
   timeoutMessageFormat:(NSString*)countDownMessageFormat; // use "%lu" for the countdown value placeholder

@end
