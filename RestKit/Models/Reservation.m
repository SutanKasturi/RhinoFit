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
    return [self.when compare:otherObject.when];
}

@end
