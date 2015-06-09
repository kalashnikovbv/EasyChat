//
//  MultipeerConnectivityController.m
//  iOSChat
//
//  Created by Bogdan on 4/21/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "MultipeerConnectivityManager.h"
#import "AppDelegate.h"

#import "Peer.h"
#import "Message.h"

NSString * const kServiceType = @"iOSChat";
NSString * const kMessageEntityName = @"Message";
NSString * const kPeerEntityName = @"Peer";

@interface MultipeerConnectivityManager()

@property (nonatomic, retain) MCBrowserViewController * browserViewController;
@property (nonatomic, retain) MCAdvertiserAssistant * advertiserAssistant;

@property (nonatomic, retain) MCSession * session;
@property (nonatomic, retain) MCPeerID * peerID;

@property (strong, nonatomic) NSFetchRequest * fetchRequest;
@property (strong, nonatomic) NSEntityDescription * entityDescription;

@end

@implementation MultipeerConnectivityManager

- (NSManagedObjectContext *) mainContext
{
    return [[[AppDelegate sharedAppDelegate] coreDataController] managedObjectContext];
}

- (NSFetchRequest *) fetchRequest
{
    if (nil == _fetchRequest)
    {
        _fetchRequest = [[NSFetchRequest alloc] init];
        [_fetchRequest setEntity: [self entityDescription]];
    }
    
    return  _fetchRequest;
}

- (NSEntityDescription *) entityDescription
{
    if (nil == _entityDescription)
    {
        NSString * entityName = [NSString stringWithFormat: @"Peer"];
        _entityDescription = [NSEntityDescription entityForName: entityName inManagedObjectContext: [self mainContext]];
    }
    
    return _entityDescription;
}

- (instancetype) init
{
    return [self initWithPeerName: [[UIDevice currentDevice] name]];
}

- (instancetype) initWithPeerName: (NSString *) aPeerName;
{
    self = [super init];
    
    if (nil != self)
    {
        _peerID = [[MCPeerID alloc] initWithDisplayName: aPeerName];
        
        _session = [[MCSession alloc] initWithPeer: _peerID];
        _session.delegate = self;
        
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType: kServiceType discoveryInfo: nil session: _session];
        
        _browserViewController = [[MCBrowserViewController alloc] initWithServiceType: kServiceType session: _session];
        
        NSString * backgroundImageName = [NSString stringWithFormat: @"background"];
        _browserViewController.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: backgroundImageName]];
        
        if (! [self fetchPeerWithID: _peerID])
        {
            [self addNewPeerWithID: _peerID andState: [NSNumber numberWithInt: -1]];
        }
    }
    
    return self;
}

- (void) dealloc
{
    [_browserViewController release];
    [_advertiserAssistant release];
    
    [_session release];
    [_peerID release];
    
    if (_fetchRequest)
    {
        [_fetchRequest release];
    }
    
    [super dealloc];
}

- (void) advertise: (BOOL) shouldAdvertise
{
    if (shouldAdvertise)
    {
        [_advertiserAssistant start];
    }
    else
    {
        [_advertiserAssistant stop];
    }
}

- (void) sendMessage: (NSString *) message
{
    NSArray * allPeers = [[self session] connectedPeers];
    
    if ([allPeers count] > 0)
    {
        NSData * dataToSend = [message dataUsingEncoding: NSUTF8StringEncoding];
        NSError * error = nil;
    
        [[self session] sendData: dataToSend toPeers: allPeers withMode: MCSessionSendDataReliable error: &error];
    
        if (nil != error)
        {
            NSLog(@"Error sending data: %@", error.localizedDescription);
        }
        else
        {
            [self addNewMessage: message fromPeerWithID: [self peerID]];
        }
    }
    else
    {
        NSLog(@"Error: no peer to send message");
    }
}

- (void) disconnect
{
    [[self session] disconnect];
}

- (void) addNewMessage: (NSString *) message fromPeerWithID: (MCPeerID *) peerID
{
    Peer * sender = [self fetchPeerWithID: peerID];
    
    Message * newMessage = [NSEntityDescription insertNewObjectForEntityForName: kMessageEntityName inManagedObjectContext: [self mainContext]];
    
    newMessage.text = message;
    newMessage.date = [NSDate date];
    newMessage.sendingPeer = sender;
}

- (void) addNewPeerWithID: (MCPeerID *) peerID andState: (NSNumber *) state
{
    Peer * peer = [NSEntityDescription insertNewObjectForEntityForName: kPeerEntityName inManagedObjectContext: [self mainContext]];
    
    peer.peerID = [peerID displayName];
    peer.state = state;
}

- (Peer *) fetchPeerWithID: (MCPeerID *) peerID
{
    Peer * fetchedPeer = nil;
    
    NSString * predicateFormat = [NSString stringWithFormat: @"peerID==\"%@\"", [peerID displayName]];
    NSPredicate * predicate = [NSPredicate predicateWithFormat: predicateFormat];
    
    [[self fetchRequest] setPredicate: predicate];
    
    NSError * error = nil;
    
    NSArray * fetchedObjects = [[self mainContext] executeFetchRequest: [self fetchRequest] error: &error];
    
    if (nil != error)
    {
        NSLog(@"Error in fetching peer with id: %@", [peerID displayName]);
        NSLog(@"Error: %@", error.debugDescription);
    }
    else if ([fetchedObjects count] == 1)
    {
        fetchedPeer = [fetchedObjects lastObject];
    }

    return fetchedPeer;
}

#pragma mark - Session Delegate

- (void) session: (MCSession *) session peer: (MCPeerID *) peerID didChangeState: (MCSessionState) state
{
    Peer * peer = [self fetchPeerWithID: peerID];
    
    if (nil == peer)
    {
        [self addNewPeerWithID: peerID andState: [NSNumber numberWithInt: state]];
    }
    else
    {
        peer.state = [NSNumber numberWithInt: state];
    }
    
    return;
}

- (void) session: (MCSession *) session didReceiveData: (NSData *) data fromPeer: (MCPeerID *) peerID
{
    NSString * receivedMessage = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    [self addNewMessage: receivedMessage fromPeerWithID: peerID];
    
    [receivedMessage release];
    
    return;
}

- (void) session: (MCSession *) session didReceiveStream: (NSInputStream *) stream
        withName: (NSString *) streamName fromPeer: (MCPeerID *) peerID
{
    
    return;
}

- (void) session: (MCSession *) session didStartReceivingResourceWithName: (NSString *) resourceName
        fromPeer: (MCPeerID *) peerID withProgress: (NSProgress *) progress
{
    
    return;
}

- (void) session: (MCSession *) session didFinishReceivingResourceWithName: (NSString *) resourceName
        fromPeer: (MCPeerID *) peerID atURL: (NSURL *) localURL withError: (NSError *) error
{
    
    return;
}

@end
