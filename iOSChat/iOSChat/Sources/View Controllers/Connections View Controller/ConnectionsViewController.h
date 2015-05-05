//
//  ConnectionsViewController.h
//  iOSChat
//
//  Created by Bogdan on 4/21/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipeerConnectivityManager.h"
#import "CoreDataController.h"

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

+ (id) sharedConnectionsController;

- (id) copyWithZone: (NSZone *) zone;

- (id) retain;
- (NSUInteger) retainCount;
- (oneway void) release;
- (id) autorelease;

- (void) sendMessage: (NSString *) message;

@end
