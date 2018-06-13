//
//  JourneyDetailsTVC.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 12.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "JourneyDetailsTVC.h"

#import "DataManager.h"

@interface JourneyDetailsTVC ()

@end

@implementation JourneyDetailsTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    labels = @[@"Name", @"Start date", @"End date", @"Start place", @"End place", @"Avarage speed", @"Distance", @"Locations recorded"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"View on Map" style:UIBarButtonItemStylePlain target:self action:@selector(viewOnMap:)];
}

- (void)viewOnMap:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return labels.count;
}

- (void)findPlacemarkByLocation:(Location*)journeyLocation withCell:(UITableViewCell*)cell {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:journeyLocation.latitude longitude:journeyLocation.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *addressString = [NSString stringWithFormat:@"%@ %@, %@, %@", placemark.thoroughfare ? placemark.thoroughfare : @"", placemark.subThoroughfare ? placemark.subThoroughfare : @"", placemark.locality ? placemark.locality : @"-", placemark.ISOcountryCode ? placemark.ISOcountryCode : @"Unknown country"];
             cell.detailTextLabel.text = addressString;
         }
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailValue" forIndexPath:indexPath];

    cell.textLabel.text = labels[indexPath.row];

    NSArray *sorted = [[[journey locations] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [(Location *)obj1 timestamp].timeIntervalSince1970 < [(Location *)obj2 timestamp].timeIntervalSince1970 ? NSOrderedAscending : NSOrderedDescending;
        return result;
    }];
    
    switch (indexPath.row) {
        case 1: {
            NSString *beginDateString = [NSDateFormatter localizedStringFromDate:journey.begin dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
            cell.detailTextLabel.text = beginDateString;
        } break;

        case 2: {
            NSString *endDateString = [NSDateFormatter localizedStringFromDate:journey.end dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
            cell.detailTextLabel.text = endDateString;
        } break;
        
        case 3: {
            cell.detailTextLabel.text = @"Searching place ...";
            [self findPlacemarkByLocation:[sorted firstObject] withCell:cell];
        } break;
        
        case 4: {
            cell.detailTextLabel.text = @"Searching place ...";
            [self findPlacemarkByLocation:[sorted lastObject] withCell:cell];
        } break;
        
        case 5: {//avg speed
            double avgSpeed = 0.0;
            for (Location *location in journey.locations) {
                avgSpeed += location.speed;
            }
            avgSpeed /= journey.locations.count;
            NSString *avgSpeedString = [NSNumberFormatter localizedStringFromNumber:@(avgSpeed) numberStyle:NSNumberFormatterDecimalStyle];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ mps", avgSpeedString];
        } break;

        case 6: {//distance
            double meters = 0.0;
            if (sorted.count > 0) {
                for (NSUInteger i = 0; i < sorted.count - 1; i += 1) {
                    Location *jLocA = [sorted objectAtIndex:i];
                    Location *jLocB = [sorted objectAtIndex:i + 1];
                    CLLocation *locationA = [[CLLocation alloc] initWithLatitude:jLocA.latitude longitude:jLocA.longitude];
                    CLLocation *locationB = [[CLLocation alloc] initWithLatitude:jLocB.latitude longitude:jLocB.longitude];
                    meters += [locationA distanceFromLocation:locationB];
                }
            }
            NSString *metersString = [NSNumberFormatter localizedStringFromNumber:@(meters) numberStyle:NSNumberFormatterDecimalStyle];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ meters", metersString];
        } break;

        case 7: {
            cell.detailTextLabel.text = @(sorted.count).stringValue;
        } break;

        default:{
            NSString *journeyName = [NSString stringWithFormat:@"Journey #%ld", self.index.integerValue + 1];
            cell.detailTextLabel.text = journeyName;
        } break;
    }
    
    return cell;
}


- (void)setIndex:(NSNumber *)index {
    _index = index;
    [[NSUserDefaults standardUserDefaults] setObject:index forKey:@"JourneyToPlot"];
    journey = [DataManager journeyByIndex:index];
}
@end
