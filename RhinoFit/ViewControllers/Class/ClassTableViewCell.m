//
//  ClassTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "Constants.h"
#import "NetworkManager.h"

@interface ClassTableViewCell() {
    BOOL isConfirmReservation;
}

@end

@implementation ClassTableViewCell

@synthesize theClass;
@synthesize reservationButton;
@synthesize reservationIndicator;
@synthesize attendanceButton;
@synthesize attendanceIndicator;
@synthesize trackWodButton;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize timeLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onReservation:(id)sender {
    isConfirmReservation = YES;
    theClass.isActionReservation = YES;
    NSString *message = @"";
    if ( [theClass.reservationId intValue] > 0 ) {
        message = kMessageCancelReservation;
    }
    else {
        message = kMessageMakeReservation;
    }
    [self confirmPopup:message];
}
- (IBAction)onAttandance:(id)sender {
    isConfirmReservation = NO;
    theClass.isActionAttendance = YES;
    NSString *message = @"";
    if ( [theClass.aId intValue] > 0 ) {
        message = kMessageCancelAttendance;
    }
    else {
        message = kMessageMarkAttendance;
    }
    [self confirmPopup:message];
}
- (IBAction)onTrackWod:(id)sender {
    [self.delegate onTrackWod:self.theClass];
}

- (void) confirmPopup:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        if ( isConfirmReservation )
        {
            [reservationButton setEnabled:NO];
            [reservationIndicator setHidden:NO];
            [reservationIndicator startAnimating];
            if ([theClass.reservationId intValue] > 0) {
                [self cancelReservation];
            }
            else {
                [self makeReservation];
            }
        }
        else {
            [attendanceButton setEnabled:NO];
            [trackWodButton setEnabled:NO];
            [attendanceIndicator setHidden:NO];
            [attendanceIndicator startAnimating];
            if ( [theClass.aId intValue] > 0 ) {
                [self cancelAttendance];
            }
            else {
                [self markAttended];
            }
        }
    }
}

- (void) makeReservation
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [networkManage makeReservation:theClass.classId
                   reservationDate:[df stringFromDate:[NSDate new]]
                           success:^(NSDictionary *result) {
                               if ( result != nil ) {
                                   theClass.reservationId = [NSNumber numberWithInt:[[result objectForKey:kResponseKeyReservationId] intValue]];
                               }
                               theClass.isActionReservation = NO;
                               [self setClass:theClass];
                           }
                           failure:^(NSString *error) {
                               theClass.isActionReservation = NO;
                               [self setClass:theClass];
                               [[NetworkManager sharedManager] errorMessage:error];
                           }];
}

- (void) cancelReservation
{
    [[NetworkManager sharedManager] deleteReservation:[NSString stringWithFormat:@"%@",theClass.reservationId]
                             success:^(BOOL isSuccess) {
                                 if ( isSuccess ) {
                                     theClass.reservationId = [NSNumber numberWithInt:0];
                                 }
                                 theClass.isActionReservation = NO;
                                 [self setClass:theClass];
                             }
                             failure:^(NSString *error) {
                                 [self setClass:theClass];
                                 theClass.isActionReservation = NO;
                                 [[NetworkManager sharedManager] errorMessage:error];
                             }];
}

- (void) markAttended
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [[NetworkManager sharedManager] makeAttendance:theClass.classId
                   attendanceDate:[df stringFromDate:[NSDate new]]
                          success:^(NSNumber *attendanceId) {
                              if ( attendanceId ) {
                                  theClass.aId = attendanceId;
                              }
                              theClass.isActionAttendance = NO;
                              [self setClass:theClass];
                          }
                          failure:^(NSString *error) {
                              theClass.isActionAttendance = NO;
                              [self setClass:theClass];
                              [[NetworkManager sharedManager] errorMessage:error];
                          }];
}

- (void) cancelAttendance
{
    [[NetworkManager sharedManager] deleteAttendance:[NSString stringWithFormat:@"%@",theClass.aId]
                                             success:^(BOOL isSuccess) {
                                                 if (isSuccess) {
                                                     theClass.aId = [NSNumber numberWithInt:0];
                                                 }
                                                 theClass.isActionAttendance = NO;
                                                 [self setClass:theClass];
                                             }
                                             failure:^(NSString *error) {
                                                 theClass.isActionAttendance = NO;
                                                 [self setClass:theClass];
                                                 [[NetworkManager sharedManager] errorMessage:error];
                                             }];
}

- (void) setClass:(RhinoFitClass*) aClass
{
    theClass = aClass;
    if ( [theClass isActionReservation] == YES ) {
        [reservationButton setEnabled:NO];
        [reservationIndicator setHidden:NO];
        [reservationIndicator startAnimating];
    }
    else {
        [reservationButton setEnabled:YES];
        [reservationIndicator setHidden:YES];
    }
    
    if ( [theClass isActionAttendance] == YES ) {
        [attendanceButton setEnabled:NO];
        [attendanceIndicator setHidden:NO];
        [attendanceIndicator startAnimating];
        [trackWodButton setEnabled:NO];
    }
    else {
        [trackWodButton setEnabled:YES];
        [attendanceButton setEnabled:YES];
        [attendanceIndicator setHidden:YES];
    }
    
    titleLabel.text = theClass.title;
    if ( [theClass.reservationId intValue] > 0 && [theClass.aId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsReservationAndAttended;
        [reservationButton setTitle:kButtonCancelReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonCancelAttendance forState:UIControlStateNormal];
        [trackWodButton setHidden:NO];
    }
    else if ( [theClass.reservationId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsReservation;
        [reservationButton setTitle:kButtonCancelReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonMarkAttended forState:UIControlStateNormal];
        [trackWodButton setHidden:YES];
    }
    else if ( [theClass.aId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsAttended;
        [reservationButton setTitle:kButtonMakeReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonCancelAttendance forState:UIControlStateNormal];
        [trackWodButton setHidden:NO];
    }
    else {
        descriptionLabel.text = @"";
        [reservationButton setTitle:kButtonMakeReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonMarkAttended forState:UIControlStateNormal];
        [trackWodButton setHidden:YES];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm a"];
    timeLabel.text = [df stringFromDate:theClass.startDate];
}

@end
