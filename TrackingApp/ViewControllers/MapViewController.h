//
//  MapViewController.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 08.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class LocationMonitoringService;

@interface MapViewController : UIViewController<MKMapViewDelegate> {
    LocationMonitoringService *monitoringService;
    CLLocation *lastLocation;
    BOOL autotrackingEnabled;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UISwitch *trackingStatusSwitch;

@property (nonatomic, retain) MKPolylineView *routeLineView;

@end

