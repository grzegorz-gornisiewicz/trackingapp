//
//  Journey+CoreDataProperties.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 10.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//
//

#import "Journey+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Journey (CoreDataProperties)

+ (NSFetchRequest<Journey *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END
