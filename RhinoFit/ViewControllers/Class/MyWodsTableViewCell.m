//
//  MyWodsTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyWodsTableViewCell.h"

@implementation MyWodsTableViewCell


- (void) setupWodInfo:(WodInfo*)wodInfo {
    self.mWodInfo = wodInfo;
    if ( wodInfo ) {
        self.titleLabel.text = wodInfo.title;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd, yyyy"];
        self.startDateLabel.text = [df stringFromDate:wodInfo.startDate];
        self.resultsLabel.text = wodInfo.results;
    }
}

- (IBAction)onEdit:(id)sender {
    [self.delegate onEditMyWod:self];
}

@end
