//
//  ChatViewController.m
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "ChatViewController.h"
#import "ConnectionsViewController.h"
#import "AppDelegate.h"
#import "MessageTableViewCell.h"
#import "MessageViewController.h"

#import "Peer.h"
#import "Message.h"

NSString * const kMessageCellID = @"MessageCell";

@interface ChatViewController ()

@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

@property (strong, nonatomic) NSDateFormatter * dateFormatter;

@property (retain, nonatomic) IBOutlet UITextField * messageTextField;
@property (retain, nonatomic) IBOutlet UITableView * messagesTable;

@property (retain, nonatomic) MessageViewController * messageViewController;

@end

@implementation ChatViewController

- (NSFetchedResultsController *) fetchedResultsController
{
    if (nil == _fetchedResultsController)
    {
        NSString * messageEntityName = [NSString stringWithFormat: @"Message"];
        NSString * dateAttributeName = [NSString stringWithFormat: @"date"];
        BOOL isAscending = NO;
        
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: messageEntityName];
        request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey: dateAttributeName  ascending: isAscending]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: request managedObjectContext: [self mainContext] sectionNameKeyPath: nil cacheName: nil];
        
        [_fetchedResultsController setDelegate: self];
        
        NSError * error = nil;
        
        [_fetchedResultsController performFetch: &error];
        
        if (nil != error)
        {
            NSLog(@"ERROR! Error in fetching data: %@", error.debugDescription);
        }
    }
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *) mainContext
{
    return [[[AppDelegate sharedAppDelegate] coreDataController] managedObjectContext];
}

- (NSDateFormatter *) dateFormatter
{
    if (nil == _dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSString * dateFormat = [NSString stringWithFormat: @"dd.MM.yy HH:mm"];
        
        [_dateFormatter setDateFormat: dateFormat];
    }
    
    return _dateFormatter;
}

- (MessageViewController *) messageViewController
{
    if (nil == _messageViewController)
    {
        _messageViewController = [[MessageViewController alloc] init];
        [_messageViewController view];
    }
    
    return _messageViewController;
}

- (void) dealloc
{
    [_fetchedResultsController release];
    
    [_messageTextField release];
    [_messagesTable release];
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString * backgroundImageName = [NSString stringWithFormat: @"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: backgroundImageName]];
    
    NSString * title = [NSString stringWithFormat: @"Chat"];
    [self setTitle: title];
    
    NSString * cellNibName = [NSString stringWithFormat: @"MessageTableViewCell"];
    UINib * cellNib = [UINib nibWithNibName: cellNibName bundle:[NSBundle mainBundle]];
    
    [[self messagesTable] registerNib: cellNib forCellReuseIdentifier: kMessageCellID];
    [[self messagesTable] setRowHeight: 100.0];

    return;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    return;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions

- (IBAction) sendMessageButtonPressed: (id) sender
{
    NSString * message = self.messageTextField.text;
    NSString * emptyString = [NSString stringWithFormat: @""];
    
    if (![message isEqualToString: emptyString])
    {
        [[ConnectionsViewController sharedConnectionsController] sendMessage: message];
    }
}

- (IBAction) cancelButtonPressed: (id) sender
{
    [self.messageTextField resignFirstResponder];
}

- (IBAction) refreshButtonPressed: (id) sender
{
    [self.messagesTable reloadData];
}

- (IBAction) settingsButtonPressed: (id) sender
{
    [self.navigationController pushViewController: [ConnectionsViewController sharedConnectionsController] animated: YES];
}

- (IBAction) BackButtonPressed: (id) sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Table View Delegate

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [[[self fetchedResultsController] fetchedObjects] count];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MessageTableViewCell * cell = [self.messagesTable dequeueReusableCellWithIdentifier: kMessageCellID forIndexPath: indexPath];
    
    [cell setBackgroundColor: [UIColor clearColor]];
    
    Message * message = [[self fetchedResultsController] fetchedObjects][indexPath.section];
    
    cell.messageLabel.text = message.text;
    cell.dateLabel.text = [[self dateFormatter] stringFromDate: message.date];
    cell.senderNameLabel.text = message.sendingPeer.peerID;
    
    [cell.layer setCornerRadius: 8.0];
    [cell.layer setMasksToBounds: YES];
    [cell.layer setBorderWidth: 1.0];
    
    return cell;
}

- (UIView *) tableView: (UITableView *) tableView viewForHeaderInSection: (NSInteger) section
{
    UIView * view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    
    return [view autorelease];
}

-(CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 100.0;
}

- (CGFloat) tableView: (UITableView *) tableView heightForHeaderInSection: (NSInteger) section
{
    return 5.0;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    Message * message = [[self fetchedResultsController] fetchedObjects][indexPath.section];
    
    [self.navigationController pushViewController: [self messageViewController] animated: YES];
    
    [[self messageViewController] setMessageText: message.text
                                          date: [[self dateFormatter] stringFromDate: message.date]
                                     andSender: message.sendingPeer.peerID];
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    return;
}

#pragma mark - Fetched Results Controller Delegate

- (void) controllerDidChangeContent: (NSFetchedResultsController *) controller
{
    [self.messagesTable reloadData];
}


#pragma mark - Text Field Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
