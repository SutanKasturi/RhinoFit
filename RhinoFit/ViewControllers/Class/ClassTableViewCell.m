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
@synthesize attendanceButton;
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
                   reservationDate:[df stringFromDate:self.currentDate]
                           success:^(NSDictionary *result) {
                               if ( result != nil ) {
                                   theClass.reservationId = [NSNumber numberWithInt:[[result objectForKey:kResponseKeyReservationId] intValue]];
                               }
                               theClass.isActionReservation = NO;
//                               [self setClass:theClass];
                               [self.delegate reloadCell:self];
                           }
                           failure:^(NSString *error) {
                               theClass.isActionReservation = NO;
//                               [self setClass:theClass];
                               [self.delegate reloadCell:self];
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
//                                 [self setClass:theClass];
                                 [self.delegate reloadCell:self];
                             }
                             failure:^(NSString *error) {
//                                 [self setClass:theClass];
                                 [self.delegate reloadCell:self];
                                 theClass.isActionReservation = NO;
                                 [[NetworkManager sharedManager] errorMessage:error];
                             }];
}

- (void) markAttended
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [[NetworkManager sharedManager] makeAttendance:theClass.classId
                   attendanceDate:[df stringFromDate:self.currentDate]
                          success:^(NSNumber *attendanceId) {
                              if ( attendanceId ) {
                                  theClass.aId = attendanceId;
                              }
                              theClass.isActionAttendance = NO;
//                              [self setClass:theClass];
                              [self.delegate reloadCell:self];
                          }
                          failure:^(NSString *error) {
                              theClass.isActionAttendance = NO;
//                              [self setClass:theClass];
                              [self.delegate reloadCell:self];
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
//                                                 [self setClass:theClass];
                                                 [self.delegate reloadCell:self];
                                             }
                                             failure:^(NSString *error) {
                                                 theClass.isActionAttendance = NO;
//                                                 [self setClass:theClass];
                                                 [self.delegate reloadCell:self];
                                                 [[NetworkManager sharedManager] errorMessage:error];
                                             }];
}

- (void) setClass:(RhinoFitClass*) aClass
{
    theClass = aClass;
    if ( [theClass isActionReservation] == YES ) {
        [reservationButton setEnabled:NO];
    }
    else {
        [reservationButton setEnabled:YES];
    }
    
    if ( [theClass isActionAttendance] == YES ) {
        [attendanceButton setEnabled:NO];
        [trackWodButton setEnabled:NO];
    }
    else {
        [trackWodButton setEnabled:YES];
        [attendanceButton setEnabled:YES];
    }
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    titleLabel.text = theClass.title;
    CGFloat titleX = 8;
    CGFloat titleY = 8;
    CGSize titleSize = [ClassTableViewCell findSizeForText:theClass.title havingWidth:[UIScreen mainScreen].bounds.size.width - 40 - 94 - titleX andFont:titleLabel.font];
    titleLabel.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
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
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat descriptionX = 8;
    CGFloat descriptionY = titleY + titleSize.height + 8;
    CGFloat descriptionWidth = [UIScreen mainScreen].bounds.size.width - 40;
    if ( !trackWodButton.isHidden )
        descriptionWidth -= 106;
    CGFloat descriptionHeight = 0;
    if ( ![descriptionLabel.text isEqualToString:@""] ) {
        CGSize descriptionSize = [ClassTableViewCell findSizeForText:descriptionLabel.text havingWidth:descriptionWidth andFont:descriptionLabel.font];
        descriptionWidth = descriptionSize.width;
        descriptionHeight = descriptionSize.height;
    }
    descriptionLabel.frame = CGRectMake(descriptionX, descriptionY, descriptionWidth, descriptionHeight);
    
    if ( !trackWodButton.isHidden ) {
        trackWodButton.translatesAutoresizingMaskIntoConstraints = YES;
        trackWodButton.frame = CGRectMake(descriptionX + descriptionWidth + 8, descriptionY - (21 - descriptionHeight) / 2, 90, 21);
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm a"];
    timeLabel.text = [df stringFromDate:theClass.startDate];
}

+ (CGFloat) getCellHeight:(RhinoFitClass*) aClass
{
    CGFloat titleX = 8;
    CGFloat titleY = 8;
    CGSize titleSize = [ClassTableViewCell findSizeForText:aClass.title havingWidth:[UIScreen mainScreen].bounds.size.width - 40 - 94 - titleX andFont:[UIFont systemFontOfSize:17.0f]];
    
    CGFloat descriptionY = titleY + titleSize.height + 8;
    CGFloat descriptionWidth = [UIScreen mainScreen].bounds.size.width - 40;
    if ( [aClass.aId intValue] > 0 )
        descriptionWidth -= 106;
    
    NSString *description = @"";
    if ( [aClass.reservationId intValue] > 0 && [aClass.aId intValue] > 0 ) {
        description = kMessageIsReservationAndAttended;
    }
    else if ( [aClass.reservationId intValue] > 0 ) {
        description = kMessageIsReservation;
    }
    
    else if ( [aClass.aId intValue] > 0 ) {
        description = kMessageIsAttended;
    }
    else {
        description = @"";
    }
    CGFloat height = descriptionY + 21 + 6 + 16;
    if ( ![description isEqualToString:@""] ) {
        CGSize descriptionSize = [ClassTableViewCell findSizeForText:description havingWidth:descriptionWidth andFont:[UIFont systemFontOfSize:13.0f]];
        height += descriptionSize.height + 8;
    }
    return height;
}

/**
 *  This method is used to calculate height of text given which fits in specific width having    font provided
 *
 *  @param text       Text to calculate height of
 *  @param widthValue Width of container
 *  @param font       Font size of text
 *
 *  @return Height required to fit given text in container
 */

+ (CGSize)findSizeForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat height = font.pointSize+4;
    CGFloat width = widthValue;
    if (text) {
        CGSize textSize = { width, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            //iOS 7
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        else
        {
            //iOS 6.0
            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        height = MAX(size.height, height); //At least one row
        if ( width >= size.width )
            width = size.width;
    }
    return CGSizeMake(width, height);
}

@end
