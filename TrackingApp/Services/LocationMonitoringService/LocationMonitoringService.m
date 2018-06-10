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
        _authorizationStatus = [CLLocationManager authorizationStatus];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.pausesLocationUpdatesAutomatically = NO;
        locationManager.allowsBackgroundLocationUpdates = YES;
    }

    return self;
}

- (void)dealloc {
    [self stopRecording];
    locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.lastLocation = [locations lastObject];
    if (_lastLocation) {
        NSLog(@"lastLocation:%@", _lastLocation);
        self.lastSpeed = _lastLocation.speed;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    self.authorizationStatus = status;
}

- (void)authorizeAccess {
    if (_authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)startRecording {
    if (locationManager && !_isRecording) {
        _isRecording = YES;
        [locationManager startUpdatingLocation];
    }
}

- (void)stopRecording {
    if (locationManager && _isRecording) {
        _isRecording = NO;
        [locationManager stopUpdatingLocation];
    }
}

+ (void)initialize {
    if (self == [LocationMonitoringService self]) {
        if (!sharedInstance) {
            sharedInstance = [[LocationMonitoringService alloc] init];
        }
    }
}

@end
