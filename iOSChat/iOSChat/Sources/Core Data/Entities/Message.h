//
//  Message.h
//  iOSChat
//
//  Created by Bogdan on 4/24/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Peer;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Peer * sendingPeer;

@end
