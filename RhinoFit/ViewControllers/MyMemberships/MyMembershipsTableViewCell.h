//
//  MyMembershipsTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMembership.h"

@interface MyMembershipsTableViewCell : UITableViewCell

@property (nonatomic, strong) MyMembership *mMyMembership;

@property (weak, nonatomic) IBOutlet UILabel *membershipNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAndEndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *renewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

- (void) setMyMembership:(MyMembership*)membership;

@end
