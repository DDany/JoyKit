//
//  SSTextView.m
//  ShopSNS
//
//  Created by Danny on 11/27/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKTextView.h"

@interface JKTextView ()
@property (nonatomic, retain) UILabel *placeHolderLabel;
@end

@implementation JKTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

#pragma mark - Insert
- (NSRange)insertTextAtCurrentSelectedRange:(NSString *)text
{
    NSRange range = self.selectedRange;
    NSRange resultRange = NSMakeRange(range.location, range.length);
    NSString * firstHalfString = [self.text substringToIndex:range.location];
    NSString * secondHalfString = [self.text substringFromIndex: range.location];
    
    // turn off scrolling or you'll get dizzy ... I promise
    self.scrollEnabled = NO;
    
    self.text = [NSString stringWithFormat: @"%@%@%@",
                            firstHalfString,
                            text,
                            secondHalfString];
    range.location += [text length];
    self.selectedRange = range;
    // turn scrolling back on.
    self.scrollEnabled = YES;
    
    resultRange.length = text.length;
    return resultRange;
}

@end
