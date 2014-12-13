//
//  Reservation.m
//  
//
//  Created by Admin on 10/17/14.
//
//

#import "Reservation.h"


@implementation Reservation

//@dynamic reservationId;
//@dynamic title;
//@dynamic when;

- (NSComparisonResult)compare:(Reservation*)otherObject {
    NSDate *date1 = self.when;
    NSDate *date2 = otherObject.when;
    return [date1 compare:date2];
}

@end
