//
//  AppDelegate.m
//  timecoco
//
//  Created by Hong Xie on 9/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "AppDelegate.h"
#import "TCDatabaseManager.h"
#import "TCHomepageVC.h"
#import "TCSettingVC.h"
#import "TCMenuVC.h"
#import "REFrostedViewController.h"

@interface AppDelegate () <REFrostedViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) REFrostedViewController *frostedViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[TCHomepageVC alloc] init]];
    TCMenuVC *menuController = [[TCMenuVC alloc] initWithStyle:UITableViewStyleGrouped];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    frostedViewController.panGestureEnabled = YES;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [frostedViewController.view addGestureRecognizer:gesture];

    self.frostedViewController = frostedViewController;

    self.window.rootViewController = self.frostedViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    if ([[(UINavigationController *) self.frostedViewController.contentViewController topViewController] isKindOfClass:[TCHomepageVC class]] ||
        [[(UINavigationController *) self.frostedViewController.contentViewController topViewController] isKindOfClass:[TCSettingVC class]]) {
        [self.frostedViewController panGestureRecognized:recognizer];
    }
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer {
    //    NSLog(@"didRecongnize");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController {
    //    NSLog(@"didHideMenuViewController");
}

@end
