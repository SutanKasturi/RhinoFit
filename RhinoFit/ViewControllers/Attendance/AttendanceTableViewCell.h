//
//  AttendanceTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/19/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendance.h"

@class AttendanceTableViewCell;

@protocol AttendanceTableViewCellDelegate <NSObject>

@required
- (void) didCanceledAttendance:(AttendanceTableViewCell*)cell;

@end

@interface AttendanceTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AttendanceTableViewCellDelegate> delegate;

@property (nonatomic, strong) Attendance *mAttendance;

@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *attendanceIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void) setAttendance:(Attendance*) aAttendance;

@end
