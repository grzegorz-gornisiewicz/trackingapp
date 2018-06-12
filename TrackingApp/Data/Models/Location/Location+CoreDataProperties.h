//
//  Location+CoreDataProperties.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 11.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double speed;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, retain) Journey *location;

@end

NS_ASSUME_NONNULL_END
