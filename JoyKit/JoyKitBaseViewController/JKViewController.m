//
//  JKViewController.m
//  ShopSNS
//
//  Created by Danny on 12/12/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKViewController.h"
#import "JoyKitCore.h"

@interface JKViewController ()

@end

@implementation JKViewController

#pragma mark - Init
- (id)initWithNib
{
    return [self initWithNibAndQuery:nil];
}

- (id)initWithQuery:(id)query
{
    self = [super init];
    if (self) {
        _query = query;
    }
    return self;
}

- (id)initWithNibAndQuery:(id)query
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        // Custom initialization
        _query = query;
    }
    return self;
}

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isViewAppearedFirstTime = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.navigatorBarHandleType) {
        case NavigatorBarHandleType_Ignore:
            // do nothing. Let Subclass handle itself.
            break;
        case NavigatorBarHandleType_AutoHide:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
        case NavigatorBarHandleType_AutoShow:
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    BOOL isFirstTime = self.isViewAppearedFirstTime;
    
    [super viewDidAppear:animated];
    
    _isViewAppearing = YES;
    _isViewAppearedFirstTime = NO;
    
    if (isFirstTime) {
        [self viewDidAppearForTheFirstTime:animated];
    }
}

- (void)viewDidAppearForTheFirstTime:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _isViewAppearing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // FIXME: We should handle global memory wanrnigs here.
    /**
     Unfinished code.
     */
}

- (void)dealloc
{
    // Removes keyboard notification observers.
    self.observerForKeyboard = NO;
    _query = nil;
}

#pragma mark - Getter & Setter
- (BOOL)isPresentedAsModal
{
    // Detect if JKNavigator is available in project.
    BOOL SSNavigator_Exsit = (NSClassFromString(@"JKNavigator") != nil);
    
    if (SSNavigator_Exsit) {
        
        BOOL isModal = (!!self.presentingViewController);
        
        // root -> present -> push -> push me. => now i'm not presented.
        if (self.navigationController &&
            // here can determine whether if self is the root view controller.
            self.navigationController.viewControllers.count > 1 &&
            [self.navigationController.viewControllers lastObject] == self) {
            isModal = NO;
        }
        
        return isModal;
        
    } else {
        
        BOOL isModal = ((self.parentViewController && self.parentViewController.presentedViewController == self) ||
                        //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                        ( self.navigationController && self.navigationController.parentViewController && self.navigationController.parentViewController.presentedViewController == self.navigationController) ||
                        //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                        [[[self tabBarController] parentViewController] isKindOfClass:[UITabBarController class]]);
        
        //iOS 5+
        if (!isModal && [self respondsToSelector:@selector(presentingViewController)]) {
            isModal = ((self.presentingViewController && self.presentingViewController.presentedViewController == self) ||
                       //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                       (self.navigationController && self.navigationController.presentingViewController && self.navigationController.presentingViewController.presentedViewController == self.navigationController) ||
                       //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                       [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]]);
            
        }
        
        return isModal;
    }
}

#pragma mark - Keyboard
- (void)setObserverForKeyboard:(BOOL)observerForKeyboard
{
    if (_observerForKeyboard != observerForKeyboard) {
        _observerForKeyboard = observerForKeyboard;
        
        if (_observerForKeyboard) {
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillShow:)
                                                         name: UIKeyboardWillShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillHide:)
                                                         name: UIKeyboardWillHideNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidShow:)
                                                         name: UIKeyboardDidShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidHide:)
                                                         name: UIKeyboardDidHideNotification
                                                       object: nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillHideNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidHideNotification
                                                          object: nil];
        }
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardBounds;
    //[[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [self keyboardWillAppear:YES withBounds:keyboardBounds];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardBounds;
    //[[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [self keyboardDidAppear:YES withBounds:keyboardBounds];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect keyboardBounds;
    //[[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [self keyboardWillDisappear:YES withBounds:keyboardBounds];
}

- (void)keyboardDidHide:(NSNotification*)notification {
    CGRect keyboardBounds;
    //[[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [self keyboardDidDisappear:YES withBounds:keyboardBounds];
}

- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}

#pragma mark
- (BOOL)resignFirstResponder
{
    return [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.hideKeyboardWhileTouch) {
        [self resignFirstResponder];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark - Dismiss
- (void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated
{
    [self dismiss:animated afterDelay:0];
}

- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self dismiss:animated afterDelay:delay completion:NULL];
}

- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay completion:(void (^)(void))completion
{
    DEFINE_WEAK_PTR(self);
    void (^block)(void) = ^{
        if (w_self) {
            if (w_self.isPresentedAsModal) {
                [w_self dismissViewControllerAnimated:animated completion:completion];
            } else {
                [w_self.navigationController popViewControllerAnimated:animated];
            }
        }
    };
    
    if (delay > 0.0) {
        double delayInSeconds = delay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

@end
