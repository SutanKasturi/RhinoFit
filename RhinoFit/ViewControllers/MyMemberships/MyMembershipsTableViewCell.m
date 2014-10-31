//
//  MyMembershipsTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyMembershipsTableViewCell.h"

@implementation MyMembershipsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMyMembership:(MyMembership*)membership
{
    self.mMyMembership = membership;
    self.membershipNameLabel.text = membership.membershipName;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    self.startAndEndDateLabel.text = [NSString stringWithFormat:@"Starts %@\nand ends %@", [df stringFromDate:membership.startDate], [df stringFromDate:membership.endDate]];
    self.renewsLabel.text = membership.renewal;
    self.attendedLabel.text = @"";
    if ( [membership.attendedLimit intValue] > 0 ) {
        self.attendedLabel.text = [NSString stringWithFormat:@"You have attended %@ out of %@ classes", membership.attended, membership.attendedLimit];
    }
    self.limitLabel.text = [NSString stringWithFormat:@"%@ classes", membership.limit];
}

@end
