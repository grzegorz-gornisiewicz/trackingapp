//
//  JourneyDetailsTVC.h
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 12.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Journey;

@interface JourneyDetailsTVC : UITableViewController {
    Journey *journey;
    NSArray *labels;
}

@property(nonatomic, readwrite) NSNumber *index;

@end
