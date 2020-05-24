//
//  JXNavigationControllerStack.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXNavigationControllerStack.h"
#import "JXViewModelServices.h"
#import "JXRouter.h"
#import "JXViewControllerAnimatedTransition.h"
#import "JXTabBarController.h"

@interface JXNavigationControllerStack () <UINavigationControllerDelegate>
@property (nonatomic, strong) id<JXViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;
@end

@implementation JXNavigationControllerStack
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    JXNavigationControllerStack *navigationControllerStack = [super allocWithZone:zone];
    
    @weakify(navigationControllerStack)
    [[navigationControllerStack
      rac_signalForSelector:@selector(initWithServices:)]
    	subscribeNext:^(id x) {
            @strongify(navigationControllerStack)
            [navigationControllerStack registerNavigationHooks];
        }];
    
    return navigationControllerStack;
}

- (instancetype)initWithServices:(id<JXViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        _navigationControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) {
        return;
    }
    
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    @weakify(self)
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         JXViewController *topViewController = (JXViewController *)[self.navigationControllers.lastObject topViewController];
         if (topViewController.snapshot == nil) {
             topViewController.snapshot = [[self.navigationControllers.lastObject view] snapshotViewAfterScreenUpdates:NO];
         }
         
         UIViewController *viewController = (UIViewController *)[JXRouter.sharedInstance viewControllerForViewModel:tuple.first];
         viewController.hidesBottomBarWhenPushed = YES;
         [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         UIViewController *viewController = (UIViewController *)[JXRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[JXNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
         
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers removeAllObjects];
         
         UIViewController *viewController = (UIViewController *)[JXRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         // YJX_TODO 通过param来决定是否使用导航控制器
         if (![viewController isKindOfClass:[UINavigationController class]] && ![viewController isKindOfClass:[JXTabBarController class]]) {
             viewController = [[JXNavigationController alloc] initWithRootViewController:viewController];
             ((UINavigationController *)viewController).delegate = self;
             [self pushNavigationController:(UINavigationController *)viewController];
         }
         
         JXAppDelegate.window.rootViewController = viewController;
     }];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(JXViewControllerAnimatedTransition *)animationController {
    return animationController.fromViewController.interactivePopTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(JXViewController *)fromVC
                                                 toViewController:(JXViewController *)toVC {
    if (fromVC.interactivePopTransition != nil) {
        return [[JXViewControllerAnimatedTransition alloc] initWithNavigationControllerOperation:operation
                                                                               fromViewController:fromVC
                                                                                 toViewController:toVC];
    }
    return nil;
}

@end
