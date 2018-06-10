//
//  Journey+CoreDataProperties.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 10.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Journey+CoreDataProperties.h"

@implementation Journey (CoreDataProperties)

+ (NSFetchRequest<Journey *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Journey"];
}

@dynamic timestamp;
@dynamic uuid;
@dynamic location;

@end
