//
//  AttendanceTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 10/19/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AttendanceTableViewCell.h"
#import "Constants.h"
#import "NetworkManager.h"

@interface AttendanceTableViewCell() <NetworkManagerDelegate>

@end
@implementation AttendanceTableViewCell

@synthesize attendanceButton;
@synthesize attendanceIndicator;
@synthesize titleLabel;
@synthesize whenLabel;
@synthesize timeLabel;
@synthesize mAttendance;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)onReservation:(id)sender {
    mAttendance.isActionAttendance = YES;
    [self confirmPopup:kMessageCancelAttendance];
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
        [attendanceButton setEnabled:NO];
        [attendanceIndicator setHidden:NO];
        [attendanceIndicator startAnimating];
        [self cancelAttendance];
    }
}
- (void) cancelAttendance
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    networkManage.delegate = self;
    [networkManage deleteAttendance:[NSString stringWithFormat:@"%@",mAttendance.attendanceId]];
}

- (void) setAttendance:(Attendance *)aAttendance
{
    mAttendance = aAttendance;
    if ( [mAttendance isActionAttendance] == YES ) {
        [attendanceButton setEnabled:NO];
        [attendanceIndicator setHidden:NO];
        [attendanceIndicator startAnimating];
    }
    else {
        [attendanceButton setEnabled:YES];
        [attendanceIndicator setHidden:YES];
    }
    
    titleLabel.text = mAttendance.title;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, MMMM dd, yyyy"];
    whenLabel.text = [df stringFromDate:mAttendance.when];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    NSLog(@"Success");
    if ( mAttendance == nil )
        return;
    
    if ( [obj isKindOfClass:[NSDictionary class]] ) {
        if ( [[obj objectForKey:kParamAction] isEqualToString:kRequestDeleteAttendance]
            && [[obj objectForKey:kResponseKeyAttendanceId] isEqualToString:[NSString stringWithFormat:@"%@", mAttendance.attendanceId]] ) {
            mAttendance.attendanceId = [NSNumber numberWithInt:0];
            mAttendance.isActionAttendance = NO;
            [self.delegate didCanceledAttendance:self];
            return;
        }
    }
    [self setAttendance:mAttendance];
}

- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    NSLog(@"Failure");
}

@end
