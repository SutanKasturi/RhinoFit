//
//  Reservation.h
//  
//
//  Created by Admin on 10/17/14.
//
//

#import <Foundation/Foundation.h>

@interface Reservation : NSObject

@property (nonatomic, strong) NSNumber * reservationId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * when;
@property (nonatomic, assign) BOOL isActionReservation;

- (NSComparisonResult)compare:(Reservation*)otherObject;

@end
