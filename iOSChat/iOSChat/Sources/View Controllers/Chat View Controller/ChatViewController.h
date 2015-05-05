//
//  ChatViewController.h
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "CoreDataController.h"

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate>

- (void) dealloc;

@end
