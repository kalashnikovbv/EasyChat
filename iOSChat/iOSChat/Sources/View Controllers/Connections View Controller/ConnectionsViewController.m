//
//  ConnectionsViewController.m
//  iOSChat
//
//  Created by Bogdan on 4/21/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "MultipeerConnectivityManager.h"
#import "AppDelegate.h"
#import "ConnectionTableViewCell.h"

#import "Peer.h"

NSString * const kConnectionCellID = @"ConnectionCell";

@interface ConnectionsViewController ()

@property (retain, nonatomic) IBOutlet UITextField * deviceNameTextField;
@property (retain, nonatomic) IBOutlet UISwitch * visibilitySwitch;

@property (retain, nonatomic) IBOutlet UITableView * connectionsTable;
@property (retain, nonatomic) IBOutlet UIButton * editDeviceNameButton;

@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

@end

@implementation ConnectionsViewController
{
    MultipeerConnectivityManager * _connectivityManager;
}

- (MultipeerConnectivityManager *) connectivityManager
{
    if (nil == _connectivityManager)
    {
        NSString * emptyString = [NSString stringWithFormat: @""];
        
        NSString * peerName = ([_deviceNameTextField.text isEqualToString: emptyString]) ? [[UIDevice currentDevice] name] : _deviceNameTextField.text;
        
        _connectivityManager = [[MultipeerConnectivityManager alloc] initWithPeerName: peerName];
    }
    
    return _connectivityManager;
}

- (NSFetchedResultsController *) fetchedResultsController
{
    if (nil == _fetchedResultsController)
    {
        NSString * peerEntityName = [NSString stringWithFormat: @"Peer"];
        NSString * peerIDAttributeName = [NSString stringWithFormat: @"peerID"];
        BOOL isAscending = YES;
        
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: peerEntityName];
        request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey: peerIDAttributeName  ascending: isAscending]];
        
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


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString * backgroundImageName = [NSString stringWithFormat: @"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: backgroundImageName]];
    
    NSString * cellNibName = [NSString stringWithFormat: @"ConnectionTableViewCell"];
    UINib * cellNib = [UINib nibWithNibName: cellNibName bundle: [NSBundle mainBundle]];
    
    [[self connectionsTable] registerNib: cellNib forCellReuseIdentifier: kConnectionCellID];
    
    [_deviceNameTextField setEnabled: NO];
    [_deviceNameTextField setDelegate: self];
    
    NSString * placeHolder = [NSString stringWithFormat: @"My name: %@", [[UIDevice currentDevice] name]];
    
    _deviceNameTextField.attributedPlaceholder = [[[NSAttributedString alloc] initWithString:placeHolder attributes :@{ NSForegroundColorAttributeName: [UIColor whiteColor] } ] autorelease];
}

- (void) dealloc
{
    [_deviceNameTextField release];
    [_visibilitySwitch release];
    [_connectionsTable release];
    [_editDeviceNameButton release];
    
    if (_connectivityManager)
    {
        [_connectivityManager release];
    }
    
    if (_fetchedResultsController)
    {
        [_fetchedResultsController release];
    }

    [super dealloc];
}

- (void) sendMessage: (NSString *) message
{
    [[self connectivityManager] sendMessage: message];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Singleton Methods

+ (id) sharedConnectionsController
{
    static ConnectionsViewController * sharedConnectionsController = nil;
    
    @synchronized (self)
    {
        if (nil == sharedConnectionsController)
        {
            sharedConnectionsController = [[super alloc] init];
        }
    }
    
    return sharedConnectionsController;
}

- (id) allocWithZone: (NSZone *) zone
{
    return [[ConnectionsViewController sharedConnectionsController] retain];
}

- (id) copyWithZone: (NSZone *) zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    // Never release
    return;
}

- (id) autorelease
{
    return self;
}

#pragma mark - IBActions

- (IBAction) editDeviceNameButtonPressed: (id) sender
{
    [_deviceNameTextField setEnabled: YES];
    [_deviceNameTextField becomeFirstResponder];
}

- (IBAction) changeVisibility: (id) sender
{
    [_editDeviceNameButton setEnabled: NO];
    
    [[self connectivityManager] advertise: _visibilitySwitch.isOn];
}

- (IBAction) connectToPeersButtonPressed: (id) sender
{
    [_editDeviceNameButton setEnabled: NO];
    
    [[self connectivityManager] advertise: _visibilitySwitch.isOn];
    
    [[[self connectivityManager] browserViewController] setDelegate: self];
    
    [self presentViewController: [[self connectivityManager] browserViewController] animated: YES completion: nil];
}

- (IBAction) disconnectButtonPressed: (id) sender
{
    [[self connectivityManager] disconnect];
    
    [[self connectionsTable] reloadData];
}

- (IBAction) doneButtonPressed: (id) sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Text Field Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [textField setEnabled: NO];
    
    return YES;
}

#pragma mark - Browser View Delegate

- (void) browserViewControllerDidFinish: (MCBrowserViewController *) browserViewController
{
    [[[self connectivityManager] browserViewController] dismissViewControllerAnimated: YES completion: nil];
}

- (void) browserViewControllerWasCancelled: (MCBrowserViewController *) browserViewController
{
    [[[self connectivityManager] browserViewController] dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Table View Delegate

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    return [[[self fetchedResultsController] fetchedObjects] count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    ConnectionTableViewCell * cell = [[self connectionsTable] dequeueReusableCellWithIdentifier: kConnectionCellID forIndexPath: indexPath];
    
    [cell setBackgroundColor: [UIColor clearColor]];
    
    Peer * peer = [[self fetchedResultsController] objectAtIndexPath: indexPath];
    
    cell.peerNameLabel.text = peer.peerID;
    
    switch ([peer.state integerValue])
    {
        case MCSessionStateNotConnected:
            cell.peerStatusLabel.text = [NSString stringWithFormat: @"Not conected"];
            break;
            
        case MCSessionStateConnecting:
            cell.peerStatusLabel.text = [NSString stringWithFormat: @"Connecting"];
            break;
            
        case MCSessionStateConnected:
            cell.peerStatusLabel.text = [NSString stringWithFormat: @"Connected"];
            break;
            
        case -1:
            cell.peerStatusLabel.text = [NSString stringWithFormat: @"Me"];
            break;
            
        default:
            cell.peerStatusLabel.text = [NSString stringWithFormat: @"Unknown"];
            break;
    }
    
    return cell;
}

#pragma mark - Fetched Results Controller Delegate

- (void) controllerDidChangeContent: (NSFetchedResultsController *) controller
{
    [self.connectionsTable reloadData];
}

@end
