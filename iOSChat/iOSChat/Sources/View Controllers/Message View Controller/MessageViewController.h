//
//  MessageViewController.h
//  iOSChat
//
//  Created by Bogdan on 5/6/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"
#import "Peer.h"

@interface MessageViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel * senderNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * dateLabel;
@property (retain, nonatomic) IBOutlet UITextView * messageTextView;

- (void) setMessageText: (NSString *) text date: (NSString *) date andSender: (NSString *) sender;

@end
