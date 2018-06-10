//
//  ViewController.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 08.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "MapViewController.h"

#import "LocationMonitoringService.h"

#import "JourneysTVC/JourneysTVC.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (IBAction)onTrackingStatusValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [monitoringService startRecording];
    } else {
        [monitoringService stopRecording];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSString *speedString = [NSNumberFormatter localizedStringFromNumber:@(userLocation.location.speed) numberStyle:NSNumberFormatterDecimalStyle];
    _speedLabel.text = [NSString stringWithFormat:@"%@", speedString];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

- (void)showAllJourneys:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JourneysTVC *journeysTVC = [sb instantiateViewControllerWithIdentifier:@"JourneysTVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Journeys" style:UIBarButtonItemStylePlain target:self action:@selector(showAllJourneys:)];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;

    monitoringService = [[LocationMonitoringService alloc] init];
    [monitoringService authorizeAccess];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
