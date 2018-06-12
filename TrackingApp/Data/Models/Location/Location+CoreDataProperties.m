//
//  Location+CoreDataProperties.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 11.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Location"];
}

@dynamic latitude;
@dynamic longitude;
@dynamic speed;
@dynamic timestamp;
@dynamic uuid;
@dynamic location;

@end
