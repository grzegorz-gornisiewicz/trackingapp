//
//  ViewController.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 08.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "MapViewController.h"

#import "LocationMonitoringService.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (IBAction)onTrackingStatusValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [LocationMonitoringService authorizeAccess];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
