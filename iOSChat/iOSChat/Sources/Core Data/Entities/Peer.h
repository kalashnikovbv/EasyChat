//
//  Peer.h
//  iOSChat
//
//  Created by Bogdan on 4/24/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Peer : NSManagedObject

@property (nonatomic, retain) NSString * peerID;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSSet * messages;
@end

@interface Peer (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
