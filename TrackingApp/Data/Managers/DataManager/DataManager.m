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
        
        modelURL = [[NSBundle mainBundle] URLForResource:@"TrackingModel" withExtension:@"momd"];
        [[NSUserDefaults standardUserDefaults] setURL:modelURL forKey:@"ModelURL"];

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

- (Journey *)journeyByIndex:(NSNumber *)journeyIndex {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Journey class])];
    request.fetchLimit = 1;
    request.fetchOffset = journeyIndex.integerValue;

    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];

    Journey *journey = [result firstObject];
    
    return journey;
}

- (NSArray<Journey *> *)allJourneys {
    NSArray<Journey *> *journeys;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Journey class])];
    NSError *error = nil;

    journeys = [managedObjectContext executeFetchRequest:request error:&error];
    
    return journeys;
}

- (NSUInteger)countJourneys {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Journey class])];
    NSError *error = nil;
    
    NSUInteger numberOfJourneys = [managedObjectContext countForFetchRequest:request error:&error];
    
    return numberOfJourneys;
}

- (void)beginJourney {
    NSInteger journeysCount = [DataManager countJourneys];
    [[NSUserDefaults standardUserDefaults] setObject:@(journeysCount) forKey:@"JourneyToPlot"];
    
    currentJourney = [[Journey alloc] initWithContext:managedObjectContext];
    currentJourney.uuid = [NSUUID new].UUIDString;
    currentJourney.begin = [NSDate date];
    
    [managedObjectContext insertObject:currentJourney];
    
    NSError *error;
    [managedObjectContext save:&error];

    if (error) {
        NSLog(@"beginJourney:%@", error);
    }
}

- (void)endJourney {
    currentJourney.end = [NSDate date];

    NSError *error;
    [managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"endJourney:%@", error);
    }
}

- (void)addLocation:(CLLocation *)location {
    Location *newLocation = [[Location alloc] initWithContext:managedObjectContext];
    newLocation.uuid = [NSUUID new].UUIDString;
    newLocation.timestamp = [NSDate date];
    newLocation.speed = location.speed;
    newLocation.latitude = location.coordinate.latitude;
    newLocation.longitude = location.coordinate.longitude;
    
    [currentJourney addLocationsObject:newLocation];

    NSError *error;
    [managedObjectContext save:&error];

    if (error) {
        NSLog(@"createNewJourney:%@", error);
    }
}

- (Journey *)currentJourney {
    return currentJourney;
}

+ (void)initialize {
    if (self == [DataManager self]) {
        if (!sharedInstance) {
            sharedInstance = [[DataManager alloc] init];
        }
    }
}

+ (NSArray<Journey *> *)allJourneys {
    return [sharedInstance allJourneys];
}

+ (Journey *)journeyByIndex:(NSNumber *)journeyIndex {
    return [sharedInstance journeyByIndex:journeyIndex];
}

+ (NSUInteger)countJourneys {
    return [sharedInstance countJourneys];
}

+ (Journey *)currentJourney {
    return [sharedInstance currentJourney];
}

@end
