//
//  AppDelegate.h
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (strong, readonly, nonatomic) CoreDataController * coreDataController;

+ (AppDelegate *) sharedAppDelegate;

@end

