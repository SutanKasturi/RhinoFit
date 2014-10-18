//
//  ClassTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RhinoFitClass.h"

@interface ClassTableViewCell : UITableViewCell

@property (nonatomic, strong) RhinoFitClass *theClass;

@property (weak, nonatomic) IBOutlet UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *reservationIndicator;
@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *attendanceIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void) setClass:(RhinoFitClass*) aClass;

@end
