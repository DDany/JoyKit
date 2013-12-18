//
//  SSActionSheet.m
//  DolphinSharing
//
//  Created by Zheng Wang on 13-1-17.
//  Copyright (c) 2013年 Zheng Wang. All rights reserved.
//

#import "JKActionSheet.h"

@interface JKActionSheet () <UIActionSheetDelegate>
@end

@implementation JKActionSheet

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Constructors

+ (void)showSheetInView:(UIView*)view
                  title:(NSString*)title
      cancelButtonTitle:(NSString *)cancelButtonTitle
 destructiveButtonTitle:(NSString *)destructiveButtonTitle
      otherButtonTitles:(NSArray *)otherButtonTitles
             completion:(JKActionSheetButtonHandler)completionBlock
{
	JKActionSheet* sheet = [[self alloc] initWithTitle:title
                                     cancelButtonTitle:cancelButtonTitle
                                destructiveButtonTitle:destructiveButtonTitle
                                     otherButtonTitles:otherButtonTitles
                                            completion:completionBlock];
    [sheet showInView:view];
#if ! __has_feature(objc_arc)
	[sheet autorelease];
#endif
}

- (id)initWithTitle:(NSString*)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles
		 completion:(JKActionSheetButtonHandler)completionBlock;
{
	// Note: need to send at least the first button because if the otherButtonTitles parameter is nil, self.firstOtherButtonIndex will be -1
	NSString* firstOther = (otherButtonTitles && ([otherButtonTitles count]>0)) ? [otherButtonTitles objectAtIndex:0] : nil;
	self = [super initWithTitle:title delegate:self
			  cancelButtonTitle:nil
		 destructiveButtonTitle:destructiveButtonTitle
			  otherButtonTitles:firstOther,nil];
	if (self != nil) {
		for(NSInteger idx = 1; idx<[otherButtonTitles count];++idx) {
			[self addButtonWithTitle: [otherButtonTitles objectAtIndex:idx] ];
		}
		[self addButtonWithTitle:cancelButtonTitle];
		self.cancelButtonIndex = self.numberOfButtons - 1;
		
		self.buttonHandler = completionBlock;
	}
	return self;
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (self.buttonHandler) {
		self.buttonHandler(self,buttonIndex);
	}
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)showInView:(UIView *)view
{
    if ([view isKindOfClass:[UITabBar class]]) {
		[self showFromTabBar:(UITabBar*)view];
	} else if ([view isKindOfClass:[UIToolbar class]]) {
		[self showFromToolbar:(UIToolbar*)view];
	} else {
		[super showInView:view];
	}
}

- (void)showInView:(UIView*)view
       withTimeout:(unsigned long)timeoutInSeconds
timeoutButtonIndex:(NSInteger)timeoutButtonIndex
{
    [self showInView:view
         withTimeout:timeoutInSeconds
  timeoutButtonIndex:timeoutButtonIndex
timeoutMessageFormat:@"(Dismissed in %lus)"];
}

- (void)showInView:(UIView*)view
       withTimeout:(unsigned long)timeoutInSeconds
    timeoutButtonIndex:(NSInteger)timeoutButtonIndex
    timeoutMessageFormat:(NSString*)countDownMessageFormat
{
    __block dispatch_source_t timer = nil;
    __block unsigned long countDown = timeoutInSeconds;
    
    // Add some timer sugar to the completion handler
    JKActionSheetButtonHandler finalHandler = [self.buttonHandler copy];
    self.buttonHandler = ^(JKActionSheet* bhSheet, NSInteger bhButtonIndex) {
        // Cancel and release timer
        dispatch_source_cancel(timer);
#if ! __has_feature(objc_arc)
        dispatch_release(timer);
#endif
        timer = nil;
        
        // Execute final handler
        finalHandler(bhSheet, bhButtonIndex);
    };
#if ! __has_feature(objc_arc)
    [finalHandler release];
#endif
    
    NSString* baseMessage = self.title;
    dispatch_block_t updateMessage = countDownMessageFormat ? ^{
        self.title = [NSString stringWithFormat:@"%@\n\n%@", baseMessage, [NSString stringWithFormat:countDownMessageFormat, countDown]];
    } : ^{ /* NOOP */ };
    updateMessage();
    
    // Schedule timer every second to update message. When timer reach zero, dismiss the alert
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), 1*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        --countDown;
        updateMessage();
        if (countDown <= 0) {
            [self dismissWithClickedButtonIndex:timeoutButtonIndex animated:YES];
        }
    });
    
    // Show the alert and start the timer now
    [self showInView:view];
    
    dispatch_resume(timer);
}

// add by Danny 2013.3.27
- (void)setButtonHandler:(JKActionSheetButtonHandler)buttonHandler
{
    _buttonHandler = buttonHandler;
    super.delegate = self; // 解决在外面设置buttonHandler却无法被调用到的问题
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Memory Mgmt


#if ! __has_feature(objc_arc)
- (void)dealloc {
	[_buttonHandler release];
    [super dealloc];
}
#endif


@end
