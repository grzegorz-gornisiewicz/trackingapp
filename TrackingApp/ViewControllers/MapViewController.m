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
#import "DataManager.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (IBAction)onTrackingStatusValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [self clearRoutePath];
        lastLocation = nil;
        [monitoringService startRecording];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    } else {
        [monitoringService stopRecording];
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = MKUserTrackingModeNone;
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
    
    if (monitoringService.isRecording) {
        if (lastLocation) {
            CLLocation *currentLocation = userLocation.location;
            CLLocationCoordinate2D coordinateArray[2];

            coordinateArray[0] = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
            coordinateArray[1] = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
            
            MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
            [self.mapView addOverlay:routeLine level:MKOverlayLevelAboveRoads];

            lastLocation = userLocation.location;
        } else {
            lastLocation = userLocation.location;
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    
    return nil;
}

- (void)showAllJourneys:(UIBarButtonItem *)sender {
    if ([DataManager countJourneys] > 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JourneysTVC *journeysTVC = [sb instantiateViewControllerWithIdentifier:@"JourneysTVC"];
        [self.navigationController pushViewController:journeysTVC animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No journeys" message:@"It seems that you haven't yet recorder any journey." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Journeys" style:UIBarButtonItemStylePlain target:self action:@selector(showAllJourneys:)];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MKUserTrackingModeNone;

    monitoringService = [[LocationMonitoringService alloc] init];
    [monitoringService authorizeAccess];
}

- (void)clearRoutePath {
    NSArray *overlays = [self.mapView overlays];
    [self.mapView removeOverlays:overlays];
}

- (void)plotJourney:(Journey *)journey {
    [self clearRoutePath];

    NSArray *sorted = [[[journey locations] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //
        NSComparisonResult result = [(Location *)obj1 timestamp].timeIntervalSince1970 < [(Location *)obj2 timestamp].timeIntervalSince1970 ? NSOrderedAscending : NSOrderedDescending;
        return result;
    }];

    for (NSUInteger index = 0; index < sorted.count - 1; index += 1) {
        CLLocationCoordinate2D coordinateArray[2];
        Location *journeyLocationA = [sorted objectAtIndex:index];
        Location *journeyLocationB = [sorted objectAtIndex:index + 1];
        coordinateArray[0] = CLLocationCoordinate2DMake(journeyLocationA.latitude, journeyLocationA.longitude);
        coordinateArray[1] = CLLocationCoordinate2DMake(journeyLocationB.latitude, journeyLocationB.longitude);
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        [self.mapView addOverlay:routeLine level:MKOverlayLevelAboveRoads];
    }
   
    Location *journeyStartLocation = [sorted firstObject];
    Location *journeyEndLocation = [sorted lastObject];
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:journeyStartLocation.latitude longitude:journeyStartLocation.longitude];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:journeyEndLocation.latitude longitude:journeyEndLocation.longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((journeyStartLocation.latitude + journeyEndLocation.latitude) / 2.0f, (journeyStartLocation.longitude + journeyEndLocation.longitude) / 2.0f);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, distance, distance);

    [self.mapView setRegion:region animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSNumber *journeyIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"JourneyToPlot"];
    
    if (journeyIndex) {
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = MKUserTrackingModeNone;
        [self plotJourney:[DataManager journeyByIndex:journeyIndex]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
