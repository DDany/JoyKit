//
//  UIView+JoyKit.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "UIView+JoyKit.h"

@implementation UIView (JoyKit)

#pragma mark
- (CGFloat)width
{
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.bounds.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark
- (void)addShadowAroundBounds
{
    self.layer.shadowRadius = 8.0;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowPath = path;
    self.layer.shouldRasterize = YES;
    // Don't forget the rasterization scale
    // I spent days trying to figure out why retina display assets weren't working as expected
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)removeShadowAroundBounds
{
    [self.layer setShadowOffset:CGSizeZero];
    [self.layer setShadowOpacity:0];
    [self.layer setShadowColor:nil];
}

#pragma mark
- (void)doShakeAnimation
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(self.center.x - 5.0f, self.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(self.center.x + 5.0f, self.center.y)]];
    [[self layer] addAnimation:animation forKey:@"position"];
}

@end
