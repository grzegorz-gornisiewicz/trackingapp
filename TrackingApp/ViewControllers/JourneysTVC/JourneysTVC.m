//
//  JourneysTVC.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 10.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "JourneysTVC.h"
#import "JourneyViewCell.h"
#import "DataManager.h"
#import "Journey+CoreDataClass.h"

@interface JourneysTVC ()

@end

@implementation JourneysTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager countJourneys];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JourneyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JourneyViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Journey #%ld", indexPath.row + 1];

    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Journey *journey = [DataManager journeyByIndex:@(indexPath.row)];
    NSString *journeyName = [NSString stringWithFormat:@"Journey #%ld", indexPath.row + 1];
    NSString *beginDateString = [NSDateFormatter localizedStringFromDate:journey.begin dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *endDateString = [NSDateFormatter localizedStringFromDate:journey.end dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *message = [NSString stringWithFormat:@"start time: %@\nend time: %@", beginDateString, endDateString];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:journeyName message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *viewOnMapAction = [UIAlertAction actionWithTitle:@"View on Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"JourneyToPlot"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:viewOnMapAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
