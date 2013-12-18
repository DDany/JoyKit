//
//  UIView+JoyKit.h
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JoyKit)

#pragma mark - Properties
/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Screenshot for self.
 */
@property (nonatomic, readonly) UIImage *screenshot;


#pragma mark - Subviews
/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

#pragma mark - Shadow
- (void)addShadowAroundBounds;
- (void)removeShadowAroundBounds;

#pragma mark - Animation
- (void)doShakeAnimation;

@end
