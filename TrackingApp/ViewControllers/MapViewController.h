//
//  MapViewController.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 08.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController {
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UISwitch *trackingStatusSwitch;

@end

