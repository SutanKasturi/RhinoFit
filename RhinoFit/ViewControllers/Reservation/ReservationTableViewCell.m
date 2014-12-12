//
//  ReservationTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 10/19/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ReservationTableViewCell.h"
#import "Constants.h"
#import "NetworkManager.h"

@interface ReservationTableViewCell()

@end

@implementation ReservationTableViewCell

@synthesize reservationButton;
@synthesize reservationIndicator;
@synthesize titleLabel;
@synthesize whenLabel;
@synthesize timeLabel;
@synthesize mReservation;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReservation:(id)sender {
    mReservation.isActionReservation = YES;
    [self confirmPopup:kMessageCancelReservation];
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
        [reservationButton setEnabled:NO];
        [reservationIndicator setHidden:NO];
        [reservationIndicator startAnimating];
        [self cancelReservation];
    }
}
- (void) cancelReservation
{
    NetworkManager *networkManage = [NetworkManager sharedManager];
    [networkManage deleteReservation:[NSString stringWithFormat:@"%@",mReservation.reservationId]
                             success:^(BOOL isSuccess) {
                                 if ( isSuccess ) {
                                         mReservation.reservationId = [NSNumber numberWithInt:0];
                                         mReservation.isActionReservation = NO;
                                         [self.delegate didCanceledReservation:self];
                                         return;
                                 }
                                 [self setReservation:mReservation];
                             }
                             failure:^(NSString *error) {
                                 [self setReservation:mReservation];
                             }];
}

- (void) setReservation:(Reservation *)aReservation
{
    mReservation = aReservation;
    if ( [aReservation isActionReservation] == YES ) {
        [reservationButton setEnabled:NO];
        [reservationIndicator setHidden:NO];
        [reservationIndicator startAnimating];
    }
    else {
        [reservationButton setEnabled:YES];
        [reservationIndicator setHidden:YES];
    }
    
    titleLabel.text = mReservation.title;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, MMMM dd, yyyy"];
    whenLabel.text = [df stringFromDate:mReservation.when];
    [df setDateFormat:@"h:mm a"];
    timeLabel.text = [df stringFromDate:mReservation.when];
}

@end
