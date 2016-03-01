//
//  AppDelegate.m
//  CollectionViewTestAppCode
//
//  Created by David Clark on 14/01/2016.
//  Copyright (c) 2016 David Clark. All rights reserved.
//


#import "AppDelegate.h"
#import "ViewController.h"
#import "NSDate+Helper.h"


@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    ViewController *viewController = [[ViewController alloc] init];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];

    /*
    NSDate *today = [[NSDate new] truncateTo:NSCalendarUnitDay];
    NSDate *another = [today addUnit:NSCalendarUnitDay value:10];
    [viewController setStartDate:today];
    [viewController setEndDate:another];
     */

    return YES;
}

@end
