//
//  JKTabBar.m
//  TestDemo
//
//  Created by hyl on 13-11-5.
//  Copyright (c) 2013年 hyl. All rights reserved.
//

#import "JKTabBar.h"
#import "JKBadgeView.h"
#import "UITabBarItem+JKTabBar.h"

static NSUInteger ButtonTagSpace;
static NSUInteger LabelTagSpace;
static NSUInteger BadgeTagSpace;

@interface JKTabBar()
//@property (nonatomic) CGContextRef context;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

typedef NS_OPTIONS(NSUInteger, SSTabBarType)
{
    SSTabBarTypeTitle,
    SSTabBarTypeTitleAndSubtitle,
    SSTabBarTypeImage,
    SSTabBarTypeTitleAndImage
};

@implementation JKTabBar

+ (void)initialize
{
    // Initialize the static variable here.
    ButtonTagSpace = 100;
    LabelTagSpace = 200;
    BadgeTagSpace = 300;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [self initWithFrame:frame];
    if (self) {
        [self addTabButtonsWithItems:items tabbarType:SSTabBarTypeTitleAndImage];
    }
    return self;
}

- (void)initialize
{
    self.items = @[].mutableCopy;
    _selectedIndex = NSNotFound;
    if (!self.tintColor) {
        self.tintColor = [UIColor redColor];
        self.normalColor = [UIColor blackColor];
    }
    
    //background picture
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.backgroundImageView.hidden = YES;
    [self addSubview:self.backgroundImageView];
}

- (void)addTabButtonsWithItems:(NSArray *)items tabbarType:(SSTabBarType)type
{
     [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         UITabBarItem *item = obj;
         UIButton *button = (UIButton *)[self viewWithTag:(ButtonTagSpace + idx)];
         if (!button) {
             button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.tag = ButtonTagSpace + idx;
             button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:(14)];
             if (type == SSTabBarTypeImage || type == SSTabBarTypeTitleAndImage) {
                 button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.0f, 0.0f);
             }
             [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
             [self addSubview:button];
             
             JKBadgeView *badgeView = [[JKBadgeView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
             badgeView.widthMode = JKBadgeViewWidthModeSmall;
             badgeView.textColor = self.badgeTextColor ? self.badgeTextColor : [UIColor whiteColor];
             badgeView.badgeColor = self.badgeColor ? self.badgeColor : [UIColor redColor];
             badgeView.tag = BadgeTagSpace + idx;
             [button addSubview:badgeView];
         }
         [button setTitle:item.title forState:UIControlStateNormal];
         [button setImage:item.image forState:UIControlStateNormal];
         [button setImage:item.selectedImage forState:UIControlStateHighlighted|UIControlStateSelected];
         
         if (item.subTitle) {
             UILabel *subLabel = (UILabel *)[button viewWithTag:(LabelTagSpace + idx)];
             if (!subLabel) {
                 subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*3/7, button.frame.size.width, self.bounds.size.height*4/7)];
                 subLabel.textColor = button.titleLabel.textColor;
                 subLabel.backgroundColor = [UIColor clearColor];
                 [subLabel setTextAlignment:NSTextAlignmentCenter];
                 subLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:(12)];
                 subLabel.tag = LabelTagSpace + idx;
                 [button addSubview:subLabel];
             }
             subLabel.text = item.subTitle;
         }
         
         if (idx == self.selectedIndex) {
             [self selectTabButton:button];
         } else {
             [self deselectTabButton:button];
         }
     }];
}

- (void)removeTabButtons
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }];
}

- (void)layoutTabButtons
{
    if (self.backgroundImage) {
        self.backgroundImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.backgroundImageView.image = self.backgroundImage;
    } else {
        if (!self.barTintColor) {
            self.backgroundColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = self.barTintColor;
        }
    }
    
	NSUInteger count = self.items.count > 0 ? self.items.count : 0;
    
	__block CGRect rect = CGRectMake(0.0f, 0.0f, floorf(self.bounds.size.width / count), self.bounds.size.height);
    
    NSArray *buttons = [self.subviews subarrayWithRange:NSMakeRange(1, self.subviews.count-1)];
    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        if (idx == count - 1)
			rect.size.width = self.bounds.size.width - rect.origin.x;
        button.frame = rect;
        JKBadgeView *badgeView = (JKBadgeView *)[button viewWithTag:(idx + BadgeTagSpace)];
        if (badgeView) {
            badgeView.frame = CGRectMake(button.bounds.size.width-40, self.bounds.size.height/2-18, 40, 20);
        }
        
        if (button.titleLabel.text && ![button.titleLabel.text isEqualToString:@""]) {
            CGSize rect2 = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(button.bounds.size.width, 2000) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat xx = rect2.width/2 + 5;
            CGFloat xxx = button.bounds.size.width/2 - xx > 40 ? xx : button.bounds.size.width/2 - 40;
            badgeView.frame = CGRectMake(button.bounds.size.width/2 + xxx, button.bounds.size.height/2 - 10, 40, 20);
        }
        
        UILabel *label = (UILabel *)[button viewWithTag:(idx + LabelTagSpace)];
        if (label) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,self.bounds.size.height/3,0)];
            label.frame = CGRectMake(0, self.bounds.size.height*3/7, button.frame.size.width, self.bounds.size.height*4/7);
        }
		rect.origin.x += rect.size.width;
    }];
}

#pragma mark - select&deselect tab buttons

- (void)selectTabButton:(UIButton *)button
{
    UITabBarItem *item = self.items[button.tag - ButtonTagSpace];
	//image
    if (item.image) {
        UIImage *image = [self image:item.image filledWithColor:self.tintColor];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateSelected];
    }
    //text
    [button setTitleColor:_tintColor forState:UIControlStateNormal];
    UILabel *la = (UILabel *)[button viewWithTag:button.tag + LabelTagSpace - ButtonTagSpace];
    if (la) {
        la.textColor = _tintColor;
    }
}

- (void)deselectTabButton:(UIButton *)button
{
    UITabBarItem *item = self.items[button.tag - ButtonTagSpace];
	//image
    if (item.image) {
        [button setImage:item.image forState:UIControlStateNormal];
        [button setImage:item.image forState:UIControlStateSelected];
    }
    
    //text
    [button setTitleColor:self.normalColor forState:UIControlStateNormal];
    UILabel *la = (UILabel *)[button viewWithTag:button.tag + LabelTagSpace - ButtonTagSpace];
    if (la) {
        la.textColor = self.normalColor;
    }
    button.backgroundColor = [UIColor clearColor];
}

- (UIImage *)image:(UIImage *)image filledWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, .0);
    [self.tintColor set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectZero;
    bounds.size = image.size;
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, bounds, image.CGImage);
    CGContextFillRect(context, bounds);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - getter & setter
- (void)setItems:(NSArray *)items
{
    _items = items;
    if (items && items.count > 0) {
        [self addTabButtonsWithItems:items tabbarType:SSTabBarTypeTitleAndImage];
    }
}

- (void)setTabBarTitles:(NSArray *)titles
{
    [self setTabBarTitles:titles subTitles:nil];
}

- (void)setTabBarSubTitles:(NSArray *)subTitles
{
    [self setTabBarTitles:nil subTitles:subTitles];
}

- (void)setTabBarTitles:(NSArray *)titles subTitles:(NSArray *)subTitles
{
    NSMutableArray *arr = @[].mutableCopy;
    if (titles && titles.count > 0) {
        [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *subTitle = nil;
            if (subTitles && subTitles.count > 0) {
                if ([subTitles[idx] isKindOfClass:[NSString class]]) {
                    subTitle = subTitles[idx];
                } else if ([subTitles[idx] isKindOfClass:[NSNumber class]]) {
                    NSNumber *sub = subTitles[idx];
                    subTitle = [NSString stringWithFormat:@"%d",[sub intValue]];
                }
            }
            if (self.items && self.items.count == titles.count) {
                UITabBarItem *item = self.items[idx];
                item.title = obj;
                if (subTitle) {
                    item.subTitle = subTitle;
                }
            } else {
                UITabBarItem *item = [[UITabBarItem alloc] init];
                item.title = obj;
                item.subTitle = subTitle;
                [arr addObject:item];
            }
        }];
    } else {
        [subTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *subStr = nil;
            if ([obj isKindOfClass:[NSString class]]) {
                subStr = obj;
            } else if ([subTitles[idx] isKindOfClass:[NSNumber class]]) {
                NSNumber *sub = subTitles[idx];
                subStr = [NSString stringWithFormat:@"%d",[sub intValue]];
            }
            if (self.items && self.items.count == subTitles.count) {
                UITabBarItem *item = self.items[idx];
                item.subTitle = subStr;
            } else {
                UITabBarItem *item = [[UITabBarItem alloc] init];
                item.subTitle = subStr;
                [arr addObject:item];
            }
        }];
    }
    if (arr.count > 0) {
        _items = arr;
    }
    [self addTabButtonsWithItems:self.items tabbarType:SSTabBarTypeTitleAndSubtitle];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (_selectedIndex == NSNotFound) {
        _selectedIndex = 0;
    }

    if (index != NSNotFound) {
        BOOL shouldSelect = YES;
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(tabBarShouldSelectedAtIndex:)]) {
            shouldSelect = [self.actionDelegate tabBarShouldSelectedAtIndex:index];
        }
        if (shouldSelect) {
            UIButton *oldbtn = (UIButton *)[self viewWithTag:_selectedIndex+ButtonTagSpace];
            if (oldbtn && [oldbtn isKindOfClass:[UIButton class]]) {
                [self deselectTabButton:oldbtn];
            }
            _selectedIndex = index;
            UIButton *newbtn = (UIButton *)[self viewWithTag:_selectedIndex+ButtonTagSpace];
            if (newbtn && [newbtn isKindOfClass:[UIButton class]]) {
                [self selectTabButton:newbtn];
            }
            
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(tabBarDidSelectedAtIndex:)]) {
                [self.actionDelegate tabBarDidSelectedAtIndex:(_selectedIndex)];
            }
        }
    } else {
        BOOL shouldSelect = YES;
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(tabBarShouldSelectedAtIndex:)]) {
            shouldSelect = [self.actionDelegate tabBarShouldSelectedAtIndex:_selectedIndex];
        }
        if (shouldSelect) {
            UIButton *newbtn = (UIButton *)[self viewWithTag:_selectedIndex+ButtonTagSpace];
            if (newbtn && [newbtn isKindOfClass:[UIButton class]]) {
                [self selectTabButton:newbtn];
            }
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(tabBarDidSelectedAtIndex:)]) {
                [self.actionDelegate tabBarDidSelectedAtIndex:(_selectedIndex)];
            }
        }
    }
}

- (void)setBadgeValue:(NSString *)badgeValue forIndex:(NSUInteger)index
{
    UIButton *button = (UIButton *)[self viewWithTag:(index + ButtonTagSpace)];
    JKBadgeView *badgeView = (JKBadgeView *)[button viewWithTag:(index + BadgeTagSpace)];
    if (badgeValue) {
        if ([badgeValue isEqualToString:@""] || [badgeValue isEqualToString:@"0"] ) {
            badgeView.hidden = YES;
        } else {
            badgeView.hidden = NO;
            if ([badgeValue intValue] == 0) {
                badgeView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } else {
                badgeView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            }
            badgeView.text = badgeValue;
        }
    } else {
        badgeView.hidden = YES;
    }
}

#pragma mark - color & view setter
- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    NSArray *buttons = [self.subviews subarrayWithRange:NSMakeRange(1, self.subviews.count-1)];
    if (buttons && buttons.count > 0) {
        [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            JKBadgeView *badgeView = (JKBadgeView *)[button viewWithTag:(idx + BadgeTagSpace)];
            if (badgeView) {
                badgeView.textColor = badgeTextColor;
            }
        }];
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _badgeColor = badgeColor;
    NSArray *buttons = [self.subviews subarrayWithRange:NSMakeRange(1, self.subviews.count-1)];
    if (buttons && buttons.count > 0) {
        [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            JKBadgeView *badgeView = (JKBadgeView *)[button viewWithTag:(idx + BadgeTagSpace)];
            if (badgeView) {
                badgeView.badgeColor = badgeColor;
            }
        }];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    if (self.subviews.count > 1) {
        NSArray *buttons = [self.subviews subarrayWithRange:NSMakeRange(1, self.subviews.count-1)];
        if (buttons && buttons.count > 0) {
            [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx == self.selectedIndex) {
                    [self selectTabButton:obj];
                }
            }];
        }
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    if (self.subviews.count > 1) {
        NSArray *buttons = [self.subviews subarrayWithRange:NSMakeRange(1, self.subviews.count-1)];
        if (buttons && buttons.count > 0) {
            [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx != self.selectedIndex) {
                    [self deselectTabButton:obj];
                }
            }];
        }
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    self.backgroundColor = barTintColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.hidden = (backgroundImage == nil);
}

#pragma mark - select bar action
- (void)tabButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.selectedIndex = button.tag-ButtonTagSpace;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTabButtons];
}

@end
