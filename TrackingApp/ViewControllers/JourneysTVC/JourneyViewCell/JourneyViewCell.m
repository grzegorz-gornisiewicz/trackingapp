//
//  JourneyViewCell.m
//  TrackingApp
//
//  Created by Grzegorz Górnisiewicz on 12.06.2018.
//  Copyright © 2018 Grzegorz Górnisiewicz. All rights reserved.
//

#import "JourneyViewCell.h"

@implementation JourneyViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
