//
//  CoreDataController.m
//  iOSChat
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import "CoreDataController.h"

@implementation CoreDataController

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *) applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file.
    //This code uses a directory named "Bogdan-Kalashnikov.iOSChat"
    //in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *) managedObjectModel
{
    // The managed object model for the application.
    //It is a fatal error for the application not to be able to find and load its model.
    if (nil == _managedObjectModel)
    {
        NSString * fileName = [NSString stringWithFormat: @"iOSChat"];
        NSString * extension = [NSString stringWithFormat: @"momd"];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource: fileName withExtension: extension];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    // The persistent store coordinator for the application.
    //This implementation creates and return a coordinator,
    //having added the store for the application to it.
    if (nil == _persistentStoreCoordinator)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        
        NSString * pathComponent = [NSString stringWithFormat: @"iOSChat.sqlite"];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: pathComponent];
        
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: storeURL options: nil error: &error])
        {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application
    //(which is already bound to the persistent store coordinator for the application.)
    if (nil == _managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        if (coordinator)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void) saveContext
{
    NSManagedObjectContext * managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext)
    {
        NSError *error = nil;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save: &error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

@end
