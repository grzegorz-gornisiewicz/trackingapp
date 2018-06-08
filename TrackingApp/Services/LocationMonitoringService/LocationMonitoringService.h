//
//  LocationMonitoringService.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 09.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMonitoringService : NSObject {
    CLLocationManager *locationManager;
}

+ (instancetype)sharedInstance;
+ (void)authorizeAccess;

@end
