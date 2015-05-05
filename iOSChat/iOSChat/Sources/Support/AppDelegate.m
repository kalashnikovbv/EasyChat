//
//  AppDelegate.m
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize coreDataController = _coreDataController;

+ (AppDelegate *) sharedAppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void) dealloc
{
    [_window release];
    [_coreDataController release];
    
    [super dealloc];
}

- (CoreDataController *) coreDataController
{
    if (nil == _coreDataController)
    {
        _coreDataController = [[CoreDataController alloc] init];
    }
    
    return _coreDataController;
}

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
    UIWindow * window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [self setWindow: window];
    
    MainViewController * mainViewController = [[MainViewController alloc] init];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
    
    [navigationController setNavigationBarHidden: YES animated: NO];
    
    [window setRootViewController: navigationController];
    [window makeKeyAndVisible];
    
    [window release];
    [mainViewController release];
    [navigationController release];
    
    return YES;
}

- (void) applicationWillTerminate: (UIApplication *) application
{
    [[self coreDataController] saveContext];
}

@end
