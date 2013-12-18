//
//  SSTextView.h
//  ShopSNS
//
//  Created by Danny on 11/27/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************************************************************
 * Dependencies: None.
 * Base on: None.
 ************************************************************************/

@interface JKTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (NSRange)insertTextAtCurrentSelectedRange:(NSString *)text;

@end
