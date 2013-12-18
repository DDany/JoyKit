//
//  SSActionSheet.h
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

@interface JKActionSheet : UIActionSheet
typedef void (^JKActionSheetButtonHandler)(JKActionSheet* sheet,NSInteger buttonIndex);
@property (nonatomic, copy) JKActionSheetButtonHandler buttonHandler;

/////////////////////////////////////////////////////////////////////////////

+ (void)showSheetInView:(UIView*)view
                  title:(NSString*)title
      cancelButtonTitle:(NSString *)cancelButtonTitle
 destructiveButtonTitle:(NSString *)destructiveButtonTitle
      otherButtonTitles:(NSArray *)otherButtonTitles
             completion:(JKActionSheetButtonHandler)completionBlock;

- (id)initWithTitle:(NSString*)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles
		 completion:(JKActionSheetButtonHandler)completionBlock;

/////////////////////////////////////////////////////////////////////////////

- (void)showInView:(UIView*)view;

/**
 * Show the ActionSheet that will dismiss after timeoutInSeconds seconds, by simulating a tap on the timeoutButtonIndex button after this delay.
 *
 * This method uses the @"(Dismissed in %lus)" timeout message format by default.
 */
- (void)showInView:(UIView*)view
       withTimeout:(unsigned long)timeoutInSeconds
timeoutButtonIndex:(NSInteger)timeoutButtonIndex;

/**
 * Show the ActionSheet that will dismiss after timeoutInSeconds seconds, by simulating a tap on the timeoutButtonIndex button after this delay.
 *
 * The countDownMessageFormat is a string containing a %lu placeholder to customize the countdown message displayed in the ActionSheet.
 * If countDownMessageFormat is nil, no countdown message is added to the sheet title.
 */
- (void)showInView:(UIView*)view
       withTimeout:(unsigned long)timeoutInSeconds
timeoutButtonIndex:(NSInteger)timeoutButtonIndex
timeoutMessageFormat:(NSString*)countDownMessageFormat;


@end
