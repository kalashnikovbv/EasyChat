//
//  MultipeerConnectivityController.h
//  iOSChat
//
//  Created by Bogdan on 4/21/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MultipeerConnectivityManager : NSObject <MCSessionDelegate>

@property (readonly, nonatomic, retain) MCBrowserViewController * browserViewController;
@property (readonly, nonatomic, retain) MCAdvertiserAssistant * advertiserAssistant;

@property (readonly, nonatomic, retain) MCSession * session;
@property (readonly, nonatomic, retain) MCPeerID * peerID;

- (instancetype) init;
- (instancetype) initWithPeerName: (NSString *) aPeerName;

- (void) dealloc;

- (void) advertise: (BOOL) shouldAdvertise;

- (void) sendMessage: (NSString *) message;

- (void) disconnect;

@end
