//
//  MainViewController.m
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "MainViewController.h"
#import "ChatViewController.h"
#import "ConnectionsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    ChatViewController * _chatViewController;
}

- (void) dealloc
{
    if (_chatViewController)
    {
        [_chatViewController release];
    }
    
    [super dealloc];
}

- (ChatViewController *) chatViewControler
{
    if (nil == _chatViewController)
    {
        _chatViewController = [[ChatViewController alloc] init];
    }
    
    return _chatViewController;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString * backgroundImageName = [NSString stringWithFormat: @"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: backgroundImageName]];

    return;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    return;
}

- (IBAction) startChattingButtonPressed: (id) sender
{
    [[self navigationController] pushViewController: [self chatViewControler] animated: YES];
}

- (IBAction) sttingsButtonPressed: (id) sender
{
    [self.navigationController pushViewController: [ConnectionsViewController sharedConnectionsController] animated: YES];
}

@end
