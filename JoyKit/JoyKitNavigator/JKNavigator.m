//
//  JKNavigator.m
//  ShopSNS
//
//  Created by Danny on 13-9-2.
//  Copyright (c) 2013年 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "JKNavigator.h"
#import "JKViewController.h"

@interface JKNavigator ()

@property (nonatomic, strong) Class navigationSubclass;

@end

@implementation JKNavigator

@synthesize navigationSubclass = _navigationSubclass;
JK_SINGLETON_INSTANCE_METHOD_IMPL(JKNavigator)

#pragma mark - Getter & Setter

- (Class)navigationSubclass
{
    if (!_navigationSubclass) {
        _navigationSubclass = [UINavigationController class];
    }
    
    return _navigationSubclass;
}

- (void)setNavigationSubclass:(Class)navigationSubclass
{
    if ([navigationSubclass isSubclassOfClass:[UINavigationController class]]) {
        _navigationSubclass = navigationSubclass;
    } else {
        @throw [NSException exceptionWithName:@"Incorrect Class" reason:@"You can only set UINavigationController subclass here." userInfo:@{}];
    }
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)rootViewController
{
    return self.window.rootViewController;
}

- (UINavigationController *)topNavigationController
{
    UINavigationController *root = (UINavigationController *)self.rootViewController;
    
    while (root) {
        UINavigationController *child = (UINavigationController *)root.presentedViewController;
        if (child && [child isKindOfClass:[UINavigationController class]]) {
            root = child;
        } else {
            return root;
        }
    }
    
    return nil;
}

#pragma mark - Remove all.
- (void)removeAllViewControllers
{
    UINavigationController *rootNavigator = (UINavigationController *)self.rootViewController;
    UINavigationController *root = (UINavigationController *)self.rootViewController;
    while (root) {
        if (root && [root isKindOfClass:[UINavigationController class]]) {
            [root dismissViewControllerAnimated:NO completion:NULL];
        }
        
        root = (UINavigationController *)root.presentedViewController;;
    }
    
    [rootNavigator popToRootViewControllerAnimated:NO];
}

#pragma mark - Private methods
- (UIViewController *)pushViewController:(NSString *)classString
                                 withNib:(BOOL)witNib
                               withQuery:(id)query
                                animated:(BOOL)animated
{
    return [self showViewControllerWithAction:@"Push"
                                  classString:classString
                                      withNib:witNib
                                    withQuery:query
                                     animated:animated
                                   completion:NULL];
}

- (UIViewController *)presentViewController:(NSString *)classString
                                    withNib:(BOOL)witNib
                                  withQuery:(id)query
                                   animated:(BOOL)animated
                                 completion:(void(^)(void))completion
{
    return [self showViewControllerWithAction:@"Present"
                                  classString:classString
                                      withNib:witNib
                                    withQuery:query
                                     animated:animated
                                   completion:completion];
}

- (UIViewController *)showViewControllerWithAction:(NSString *)action
                                       classString:(NSString *)classString
                                           withNib:(BOOL)witNib
                                         withQuery:(id)query
                                          animated:(BOOL)animated
                                        completion:(void(^)(void))completion
{
    UIViewController *controller = nil;
    UINavigationController *topNavigationController = [self topNavigationController];
    
    // Generate UIViewController from classString.
    Class class = NSClassFromString(classString);
    if ([class isSubclassOfClass:[JKViewController class]]) {
        controller = witNib ? [[class alloc] initWithNibAndQuery:query] : [[class alloc] initWithQuery:query];
    } else if ([class isSubclassOfClass:[UIViewController class]]) {
        controller = witNib ? [[class alloc] initWithNibName:classString bundle:nil] : [[class alloc] init];
    }
    
    // Show controller.
    if (controller && topNavigationController) {
        if ([action isEqualToString:@"Push"]) {
            [topNavigationController pushViewController:controller animated:animated];
        } else if ([action isEqualToString:@"Present"]) {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                [topNavigationController presentViewController:controller animated:animated completion:completion];
            } else {
                UINavigationController *navigation = [[self.navigationSubclass alloc] initWithRootViewController:controller];
                [topNavigationController presentViewController:navigation animated:animated completion:completion];
            }
        }
    }
    
    return controller;
}

#pragma mark - Push methods
- (void)registerNavigationSubclass:(Class)navigationSubclass;
{
    self.navigationSubclass = navigationSubclass;
}

#pragma mark
- (UIViewController *)pushViewController:(NSString *)classString animated:(BOOL)animated
{
    return [self pushViewController:classString withNib:NO withQuery:nil animated:animated];
}

- (UIViewController *)pushViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated
{
    return [self pushViewController:classString withNib:NO withQuery:query animated:animated];
}

- (UIViewController *)pushNibViewController:(NSString *)classString animated:(BOOL)animated
{
    return [self pushViewController:classString withNib:YES withQuery:nil animated:animated];
}

- (UIViewController *)pushNibViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated
{
    return [self pushViewController:classString withNib:YES withQuery:query animated:animated];
}

#pragma mark

- (UIViewController *)presentViewController:(NSString *)classString animated:(BOOL)animated
{
    return [self presentViewController:classString withNib:NO withQuery:nil animated:animated completion:NULL];
}

- (UIViewController *)presentViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated
{
    return [self presentViewController:classString withNib:NO withQuery:query animated:animated completion:NULL];
}

- (UIViewController *)presentViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated completion:(void(^)(void))completion
{
    return [self presentViewController:classString withNib:NO withQuery:query animated:animated completion:completion];
}

- (UIViewController *)presentNibViewController:(NSString *)classString animated:(BOOL)animated
{
    return [self presentViewController:classString withNib:YES withQuery:nil animated:animated completion:NULL];
}

- (UIViewController *)presentNibViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated
{
    return [self presentViewController:classString withNib:YES withQuery:query animated:animated completion:NULL];
}

- (UIViewController *)presentNibViewController:(NSString *)classString withQuery:(id)query animated:(BOOL)animated completion:(void(^)(void))completion
{
    return [self presentViewController:classString withNib:YES withQuery:query animated:animated completion:completion];
}

@end
