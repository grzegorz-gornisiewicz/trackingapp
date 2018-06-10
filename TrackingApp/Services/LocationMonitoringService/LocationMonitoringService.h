//
//  LocationMonitoringService.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 09.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString * _Nonnull const kAuthorizationStatus   = @"authorizationStatus";
static NSString * _Nonnull const kLastLocation          = @"lastLocation";
static NSString * _Nonnull const kLastSpeed             = @"lastSpeed";

@interface LocationMonitoringService : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property(nonatomic) CLAuthorizationStatus authorizationStatus;
@property(nonatomic) CLLocation *lastLocation;
@property(nonatomic) CLLocationSpeed lastSpeed;
@property(nonatomic) BOOL isRecording;

- (void)authorizeAccess;
- (void)stopRecording;
- (void)startRecording;

@end
