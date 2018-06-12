//
//  DataManager.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 10.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

#import "Journey+CoreDataClass.h"
#import "Location+CoreDataClass.h"

@interface DataManager : NSObject {
    NSURL *storeURL;
    NSURL *modelURL;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    Journey *currentJourney;
}

- (instancetype)init;
- (void)beginJourney;
- (void)endJourney;
- (void)addLocation:(nonnull CLLocation *)location;

+ (nullable Journey *)journeyByIndex:(nonnull NSNumber *)journeyIndex;
+ (NSArray<Journey *> *)allJourneys;
+ (NSUInteger)countJourneys;
+ (nullable Journey *)currentJourney;

@end
