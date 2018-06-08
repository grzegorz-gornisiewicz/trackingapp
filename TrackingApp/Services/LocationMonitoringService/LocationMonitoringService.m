//
//  LocationMonitoringService.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 09.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "LocationMonitoringService.h"

@implementation LocationMonitoringService

static LocationMonitoringService *sharedInstance;

- (instancetype)init {
    if (sharedInstance) {
        return sharedInstance;
    }
    
    self = [super init];
    
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return self;
}

- (void)authorizeAccess {
    [locationManager requestAlwaysAuthorization];
}

- (CLAuthorizationStatus)currentAuthorizationStatus {
    return [CLLocationManager authorizationStatus];
}

+ (void)initialize {
    if (self == [LocationMonitoringService self]) {
        if (!sharedInstance) {
            sharedInstance = [[LocationMonitoringService alloc] init];
        }
    }
}

+ (instancetype)sharedInstance {
    return sharedInstance;
}

+ (CLAuthorizationStatus)currentAuthorizationStatus {
    return [[LocationMonitoringService sharedInstance] currentAuthorizationStatus];
}

+ (void)authorizeAccess {
    [[LocationMonitoringService sharedInstance] authorizeAccess];
}

@end
