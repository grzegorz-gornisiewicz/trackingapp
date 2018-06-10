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
    CLLocationSpeed speed = userLocation.location.speed;
    if (speed < 0.0) {
        speed = 0.0;
    }
    NSString *speedString = [NSNumberFormatter localizedStringFromNumber:@(speed) numberStyle:NSNumberFormatterDecimalStyle];
    _speedLabel.text = [NSString stringWithFormat:@"%@", speedString];

    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    if (lastLocation) {
        CLLocation *currentLocation = userLocation.location;
        CLLocationCoordinate2D coordinateArray[2];

        coordinateArray[0] = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
        coordinateArray[1] = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        [self.mapView addOverlay:routeLine level:MKOverlayLevelAboveRoads | MKOverlayLevelAboveLabels];

        lastLocation = userLocation.location;
    } else {
        lastLocation = userLocation.location;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor redColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    
    return nil;
}

- (void)showAllJourneys:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JourneysTVC *journeysTVC = [sb instantiateViewControllerWithIdentifier:@"JourneysTVC"];
    [self.navigationController pushViewController:journeysTVC animated:YES];
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
