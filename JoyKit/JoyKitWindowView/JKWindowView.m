//
//  JKWindowView.m
//  ShopSNS
//
//  Created by Danny on 12/13/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKWindowView.h"
#import "JoyKitCore.h"

@interface JKWindowView ()
@property (nonatomic, strong) UIWindow *baseWindow;
@property (nonatomic, weak) UIWindow *originalWindow;
@end

@implementation JKWindowView

#pragma mark - View life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];

        self.baseWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.baseWindow.windowLevel = UIWindowLevelStatusBar;
        self.baseWindow.backgroundColor = [UIColor clearColor];
        [self.baseWindow makeKeyAndVisible];
        [self.baseWindow addSubview:self];
        self.frame = CGRectMake(-self.width, 0, self.width, self.height);
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self.baseWindow addGestureRecognizer:gesture];
    }
    return self;
}

#pragma mark - Gesture
- (void)panGesture:(UIPanGestureRecognizer *)recognizer
{
    // Get the location of the gesture
    static CGPoint startLocation;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            startLocation = [recognizer locationInView:self.baseWindow];
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentLocation = [recognizer locationInView:self.baseWindow];
            CGFloat distance = startLocation.x - currentLocation.x;
            if (distance > 0) {
                self.origin = CGPointMake(-distance, self.origin.y);
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        {
            if (self.origin.x < -120) {
                [self hide:YES];
            } else {
                [UIView animateWithDuration:0.15 animations:^{
                    self.frame = CGRectMake(0, 0, self.width, self.height);
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action
- (void)hide:(BOOL)animated
{
    [self windowViewWillHide:animated];

    void(^block)(BOOL finished) = ^(BOOL finished){
        [self removeFromSuperview];
        self.baseWindow = nil;
        [self.originalWindow makeKeyAndVisible];
        [self windowViewDidHide:animated];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = CGRectMake(-self.width, 0, self.width, self.height);
        } completion:block];
    } else {
        block(YES);
    }
}

- (void)show:(BOOL)animated
{
    [self windowViewWillShow:animated];
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = CGRectMake(0, 0, self.width, self.height);
        } completion:^(BOOL finished) {
            [self windowViewDidShow:animated];
        }];
    } else {
        self.frame = CGRectMake(0, 0, self.width, self.height);
        [self windowViewDidShow:animated];
    }
}

#pragma mark - Class method
+ (void)showOnWindow:(UIWindow *)originalWindow animated:(BOOL)animated
{
    if (!originalWindow) {
        return;
    }
    
    JKWindowView *windowView = [[JKWindowView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    windowView.originalWindow = originalWindow;
    [windowView show:YES];
}

#pragma mark - Route
- (void)windowViewWillShow:(BOOL)animated
{
    // override
}

- (void)windowViewDidShow:(BOOL)animated
{
    // override
}

- (void)windowViewWillHide:(BOOL)animated
{
    // override
}

- (void)windowViewDidHide:(BOOL)animated
{
    // override
}


@end
