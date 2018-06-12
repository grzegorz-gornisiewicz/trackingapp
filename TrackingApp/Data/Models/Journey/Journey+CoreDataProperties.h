//
//  Journey+CoreDataProperties.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 11.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Journey+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Journey (CoreDataProperties)

+ (NSFetchRequest<Journey *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *begin;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSDate *end;
@property (nullable, nonatomic, copy) NSNumber *no;
@property (nullable, nonatomic, retain) NSSet<Location *> *locations;

@end

@interface Journey (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet<Location *> *)values;
- (void)removeLocations:(NSSet<Location *> *)values;

@end

NS_ASSUME_NONNULL_END
