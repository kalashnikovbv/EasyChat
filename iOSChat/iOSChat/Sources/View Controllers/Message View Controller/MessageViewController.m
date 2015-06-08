//
//  MessageViewController.m
//  iOSChat
//
//  Created by Bogdan on 5/6/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString * backgroundImageName = [NSString stringWithFormat: @"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: backgroundImageName]];

    return;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    return;
}

- (void) dealloc
{
    [_senderNameLabel release];
    [_dateLabel release];
    [_messageTextView release];

    [super dealloc];
}

- (void) setMessageText: (NSString *) text date: (NSString *) date andSender: (NSString *) sender
{
    self.messageTextView.text = text;
    self.senderNameLabel.text = sender;
    self.dateLabel.text = date;
    
    return;
}

- (IBAction) doneButtonPressed: (id) sender
{
//    [self.navigationController popViewControllerAnimated: YES];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
