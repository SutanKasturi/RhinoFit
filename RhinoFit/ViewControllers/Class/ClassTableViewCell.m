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

@interface ClassTableViewCell()<NetworkManagerDelegate> {
    BOOL isConfirmReservation;
}

@end

@implementation ClassTableViewCell

@synthesize theClass;
@synthesize reservationButton;
@synthesize reservationIndicator;
@synthesize attendanceButton;
@synthesize attendanceIndicator;
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
    networkManage.delegate = self;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [networkManage makeReservation:theClass.classId reservationDate:[df stringFromDate:[NSDate new]]];
}

- (void) cancelReservation
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    networkManage.delegate = self;
    [networkManage deleteReservation:[NSString stringWithFormat:@"%@",theClass.reservationId]];
}

- (void) markAttended
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    networkManage.delegate = self;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [networkManage makeAttendance:theClass.classId attendanceDate:[df stringFromDate:[NSDate new]]];
}

- (void) cancelAttendance
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    networkManage.delegate = self;
    [networkManage deleteAttendance:[NSString stringWithFormat:@"%@",theClass.aId]];
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
    }
    else {
        [attendanceButton setEnabled:YES];
        [attendanceIndicator setHidden:YES];
    }
    
    titleLabel.text = theClass.title;
    if ( [theClass.reservationId intValue] > 0 && [theClass.aId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsReservationAndAttended;
        [reservationButton setTitle:kButtonCancelReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonCancelAttendance forState:UIControlStateNormal];
    }
    else if ( [theClass.reservationId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsReservation;
        [reservationButton setTitle:kButtonCancelReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonMarkAttended forState:UIControlStateNormal];
    }
    else if ( [theClass.aId intValue] > 0 ) {
        descriptionLabel.text = kMessageIsAttended;
        [reservationButton setTitle:kButtonMakeReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonCancelAttendance forState:UIControlStateNormal];
    }
    else {
        descriptionLabel.text = @"";
        [reservationButton setTitle:kButtonMakeReservation forState:UIControlStateNormal];
        [attendanceButton setTitle:kButtonMarkAttended forState:UIControlStateNormal];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    timeLabel.text = [df stringFromDate:theClass.startDate];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    NSLog(@"Success");
    if ( theClass == nil )
        return;
    
    if ( [obj isKindOfClass:[NSDictionary class]] ) {
        if ( [[obj objectForKey:kParamAction] isEqualToString:kRequestMakeReservation]
            && [[obj objectForKey:kResponseKeyClassId] isEqualToString:theClass.classId] ) {
            theClass.reservationId = [NSNumber numberWithInt:[[obj objectForKey:kResponseKeyReservationId] intValue]];
            theClass.isActionReservation = NO;
        }
        else if ( [[obj objectForKey:kParamAction] isEqualToString:kRequestDeleteReservation]
                 && [[obj objectForKey:kResponseKeyReservationId] isEqualToString:[NSString stringWithFormat:@"%@", theClass.reservationId]] ) {
            theClass.reservationId = [NSNumber numberWithInt:0];
            theClass.isActionReservation = NO;
        }
        else if ( [[obj objectForKey:kParamAction] isEqualToString:kRequestMakeAttendance]
                 && [[obj objectForKey:kResponseKeyClassId] isEqualToString:theClass.classId] ) {
            theClass.aId = [NSNumber numberWithInt:[[obj objectForKey:kResponseKeyAttendanceId] intValue]];
            theClass.isActionAttendance = NO;
        }
        else if ( [[obj objectForKey:kParamAction] isEqualToString:kRequestDeleteAttendance]
                 && [[obj objectForKey:kResponseKeyAttendanceId] isEqualToString:[NSString stringWithFormat:@"%@", theClass.aId]] ) {
            theClass.aId = [NSNumber numberWithInt:0];
            theClass.isActionAttendance = NO;
        }
    }
    [self setClass:theClass];
}
- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    NSLog(@"Failure");
}

@end
