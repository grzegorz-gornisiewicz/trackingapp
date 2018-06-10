//
//  DataManager.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 10.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager *sharedInstance;

- (instancetype)init {
    if (sharedInstance) {
        return sharedInstance;
    }

    self = [super init];
    
    if (self) {
        storeURL = [[NSUserDefaults standardUserDefaults] URLForKey:@"StoreURL"];
        
        if (!storeURL) {
            NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
            storeURL = [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
            [[NSUserDefaults standardUserDefaults] setURL:storeURL forKey:@"StoreURL"];
        }
        
        modelURL = [[NSUserDefaults standardUserDefaults] URLForKey:@"ModelURL"];
        
        if (!modelURL) {
            modelURL = [[NSBundle mainBundle] URLForResource:@"TrackingModel" withExtension:@"momd"];
            [[NSUserDefaults standardUserDefaults] setURL:storeURL forKey:@"ModelURL"];
        }

        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSError* error;
        [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    
    return self;
}

+ (void)initialize {
    if (self == [DataManager self]) {
        if (!sharedInstance) {
            sharedInstance = [[DataManager alloc] init];
        }
    }
}

@end
