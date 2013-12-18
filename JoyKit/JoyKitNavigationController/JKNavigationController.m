//
//  JKNavigationController.m
//  ShopSNS
//
//  Created by Danny on 12/11/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKNavigationController.h"
#import "JoyKitCore.h"

@interface JKNavigationController ()

// Back view.
@property (nonatomic, strong) UIView *backgroundView;

// Save the screenshot here.
@property (nonatomic, strong) NSMutableArray *screenshots;

// Detect whether if it is moving.
@property (nonatomic, assign) BOOL isMoving;

// Start position for back view, default is -200.
@property (nonatomic, assign) CGFloat startPositionForBackView;
// Screenshot view for last view.
@property (nonatomic, strong) UIImageView *lastScreenshotView;

@end

@implementation JKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenshots = @[].mutableCopy;
        self.startPositionForBackView = -200;
        self.draggable = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenshots addObject:self.view.screenshot];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenshots removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Setter

#pragma mark - Utility Methods
- (void)moveViewWithX:(float)x
{
    x = MIN(x, 320);
    x = MAX(x, 0);
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    CGFloat aa = abs(self.startPositionForBackView)/[UIScreen mainScreen].bounds.size.width;
    CGFloat y = x*aa;
    
    CGFloat lastScreenShotViewHeight = [UIScreen mainScreen].bounds.size.height;
    
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
    /**
     *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add
     
     if (!iOS7) {
     lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
     }
     *
     */
    [self.lastScreenshotView setFrame:CGRectMake(self.startPositionForBackView + y, 0, [UIScreen mainScreen].bounds.size.width, lastScreenShotViewHeight)];
    
}

#pragma mark - Gesture Recognizer -

- (void)handlePanGesture:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.draggable) {
        return;
    }
    
    static CGPoint startTouch;
    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        self.isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView) {
            self.backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        }
        self.backgroundView.hidden = NO;
        
        if (self.lastScreenshotView) {
            [self.lastScreenshotView removeFromSuperview];
        }
        self.lastScreenshotView = [[UIImageView alloc] initWithImage:[self.screenshots lastObject]];
        [self.lastScreenshotView setFrame:CGRectMake(self.startPositionForBackView,
                                                self.lastScreenshotView.frame.origin.y,
                                                self.lastScreenshotView.frame.size.height,
                                                self.lastScreenshotView.frame.size.width)];
        [self.backgroundView addSubview:self.lastScreenshotView];
    } else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        
        if (touchPoint.x - startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                self.isMoving = NO;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                self.isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            self.isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    
    if (self.isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end
