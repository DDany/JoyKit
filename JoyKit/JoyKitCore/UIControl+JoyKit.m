//
//  UIControl+JoyKit.m
//  ShopSNS
//
//  Created by Danny on 12/4/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "UIControl+JoyKit.h"
#import <objc/runtime.h>

@implementation UIControl (JoyKit)

#pragma mark - Touch area
static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero)
       || !self.enabled
       || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}


#pragma mark - Block support
static char OperationKey;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block
{
    NSString *methodName = [UIControl eventName:event];
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(!opreations) {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:block forKey:methodName];
    
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)removeHandlerForEvent:(UIControlEvents)event
{
    NSString *methodName = [UIControl eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(!opreations) {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

#pragma mark - Private
- (void)UIControlEventTouchDown             {[self callActionBlock:UIControlEventTouchDown];}
- (void)UIControlEventTouchDownRepeat       {[self callActionBlock:UIControlEventTouchDownRepeat];}
- (void)UIControlEventTouchDragInside       {[self callActionBlock:UIControlEventTouchDragInside];}
- (void)UIControlEventTouchDragOutside      {[self callActionBlock:UIControlEventTouchDragOutside];}
- (void)UIControlEventTouchDragEnter        {[self callActionBlock:UIControlEventTouchDragEnter];}
- (void)UIControlEventTouchDragExit         {[self callActionBlock:UIControlEventTouchDragExit];}
- (void)UIControlEventTouchUpInside         {[self callActionBlock:UIControlEventTouchUpInside];}
- (void)UIControlEventTouchUpOutside        {[self callActionBlock:UIControlEventTouchUpOutside];}
- (void)UIControlEventTouchCancel           {[self callActionBlock:UIControlEventTouchCancel];}
- (void)UIControlEventValueChanged          {[self callActionBlock:UIControlEventValueChanged];}
- (void)UIControlEventEditingDidBegin       {[self callActionBlock:UIControlEventEditingDidBegin];}
- (void)UIControlEventEditingChanged        {[self callActionBlock:UIControlEventEditingChanged];}
- (void)UIControlEventEditingDidEnd         {[self callActionBlock:UIControlEventEditingDidEnd];}
- (void)UIControlEventEditingDidEndOnExit   {[self callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)UIControlEventAllTouchEvents        {[self callActionBlock:UIControlEventAllTouchEvents];}
- (void)UIControlEventAllEditingEvents      {[self callActionBlock:UIControlEventAllEditingEvents];}
- (void)UIControlEventApplicationReserved   {[self callActionBlock:UIControlEventApplicationReserved];}
- (void)UIControlEventSystemReserved        {[self callActionBlock:UIControlEventSystemReserved];}
- (void)UIControlEventAllEvents             {[self callActionBlock:UIControlEventAllEvents];}

#pragma mark
- (void)callActionBlock:(UIControlEvents)event {
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    
    if(opreations == nil) return;
    void(^block)(id sender) = [opreations objectForKey:[UIControl eventName:event]];
    
    if (block) block(self);
    
}

#pragma mark
+ (NSString *)eventName:(UIControlEvents)event {
    switch (event) {
        case UIControlEventTouchDown:           return @"UIControlEventTouchDown";
        case UIControlEventTouchDownRepeat:     return @"UIControlEventTouchDownRepeat";
        case UIControlEventTouchDragInside:     return @"UIControlEventTouchDragInside";
        case UIControlEventTouchDragOutside:    return @"UIControlEventTouchDragOutside";
        case UIControlEventTouchDragEnter:      return @"UIControlEventTouchDragEnter";
        case UIControlEventTouchDragExit:       return @"UIControlEventTouchDragExit";
        case UIControlEventTouchUpInside:       return @"UIControlEventTouchUpInside";
        case UIControlEventTouchUpOutside:      return @"UIControlEventTouchUpOutside";
        case UIControlEventTouchCancel:         return @"UIControlEventTouchCancel";
        case UIControlEventValueChanged:        return @"UIControlEventValueChanged";
        case UIControlEventEditingDidBegin:     return @"UIControlEventEditingDidBegin";
        case UIControlEventEditingChanged:      return @"UIControlEventEditingChanged";
        case UIControlEventEditingDidEnd:       return @"UIControlEventEditingDidEnd";
        case UIControlEventEditingDidEndOnExit: return @"UIControlEventEditingDidEndOnExit";
        case UIControlEventAllTouchEvents:      return @"UIControlEventAllTouchEvents";
        case UIControlEventAllEditingEvents:    return @"UIControlEventAllEditingEvents";
        case UIControlEventApplicationReserved: return @"UIControlEventApplicationReserved";
        case UIControlEventSystemReserved:      return @"UIControlEventSystemReserved";
        case UIControlEventAllEvents:           return @"UIControlEventAllEvents";
        default:
            return @"description";
    }
    return @"description";
}

+ (UIControlEvents)eventWithName:(NSString *)name {
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventTouchDownRepeat"])     return UIControlEventTouchDownRepeat;
    if([name isEqualToString:@"UIControlEventTouchDragInside"])     return UIControlEventTouchDragInside;
    if([name isEqualToString:@"UIControlEventTouchDragOutside"])    return UIControlEventTouchDragOutside;
    if([name isEqualToString:@"UIControlEventTouchDragEnter"])      return UIControlEventTouchDragEnter;
    if([name isEqualToString:@"UIControlEventTouchDragExit"])       return UIControlEventTouchDragExit;
    if([name isEqualToString:@"UIControlEventTouchUpInside"])       return UIControlEventTouchUpInside;
    if([name isEqualToString:@"UIControlEventTouchUpOutside"])      return UIControlEventTouchUpOutside;
    if([name isEqualToString:@"UIControlEventTouchCancel"])         return UIControlEventTouchCancel;
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventValueChanged"])        return UIControlEventValueChanged;
    if([name isEqualToString:@"UIControlEventEditingDidBegin"])     return UIControlEventEditingDidBegin;
    if([name isEqualToString:@"UIControlEventEditingChanged"])      return UIControlEventEditingChanged;
    if([name isEqualToString:@"UIControlEventEditingDidEnd"])       return UIControlEventEditingDidEnd;
    if([name isEqualToString:@"UIControlEventEditingDidEndOnExit"]) return UIControlEventEditingDidEndOnExit;
    if([name isEqualToString:@"UIControlEventAllTouchEvents"])      return UIControlEventAllTouchEvents;
    if([name isEqualToString:@"UIControlEventAllEditingEvents"])    return UIControlEventAllEditingEvents;
    if([name isEqualToString:@"UIControlEventApplicationReserved"]) return UIControlEventApplicationReserved;
    if([name isEqualToString:@"UIControlEventSystemReserved"])      return UIControlEventSystemReserved;
    if([name isEqualToString:@"UIControlEventAllEvents"])           return UIControlEventAllEvents;
    return UIControlEventAllEvents;
}

@end
