//
//  JKViewController.h
//  ShopSNS
//
//  Created by Danny on 12/12/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: JoyKitCore.
 * Based on: None.
 ************************************************************************/

typedef NS_OPTIONS(NSUInteger, NavigatorBarHandleType) {
    NavigatorBarHandleType_Ignore = 0,  // default. Subclass handle navigatorBar itself.
    NavigatorBarHandleType_AutoHide,    // Automatically hide the navigatorBar.
    NavigatorBarHandleType_AutoShow     // Automatically show the navigatorBar.
};

@interface JKViewController : UIViewController
{
    id      _query;
}

#pragma mark - Init.
/**
 * Convenience init with nib file and without query.
 * Default : nib file name = class name.
 */
- (id)initWithNib;

/**
 * Convenience init without nib file and apply query data.
 */
- (id)initWithQuery:(id)query;

/**
 * Convenience init with nib file and apply query data.
 * Default : nib file name = class name.
 */
- (id)initWithNibAndQuery:(id)query;

#pragma mark - Dismiss
/**
 * Dismiss method.
 */
- (void)dismiss;
- (void)dismiss:(BOOL)animated;
- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay;
- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay completion:(void (^)(void))completion;

#pragma mark - Life cycle
- (void)viewDidAppearForTheFirstTime:(BOOL)animated;

#pragma mark - Keyboard
/**
 * Sent to the controller before the keyboard slides in.
 */
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller before the keyboard slides out.
 */
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid in.
 */
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid out.
 */
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;



#pragma mark - Properties
@property (nonatomic, assign) NavigatorBarHandleType navigatorBarHandleType;

/**
 * Determines if the view controller is presented as a modal.
 */
@property (nonatomic, assign, readonly) BOOL isPresentedAsModal;

/**
 * The view has appeared.
 */
@property (nonatomic, assign, readonly) BOOL isViewAppearing;

/**
 * The view is the first time to appear and has appeared.
 */
@property (nonatomic, assign, readonly) BOOL isViewAppearedFirstTime;

/**
 * Determines if the view controller will observer notification for the keyboard.
 */
@property (nonatomic, assign) BOOL observerForKeyboard;

/**
 * Hide keyboard by touching view. Default is NO.
 */
@property (nonatomic, assign) BOOL hideKeyboardWhileTouch;

@end
