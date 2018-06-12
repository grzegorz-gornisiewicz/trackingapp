//
//  Journey+CoreDataProperties.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 11.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Journey+CoreDataProperties.h"

@implementation Journey (CoreDataProperties)

+ (NSFetchRequest<Journey *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Journey"];
}

@dynamic begin;
@dynamic uuid;
@dynamic end;
@dynamic locations;

@end
