//
//  RhinoFitClass.h
//  
//
//  Created by Admin on 10/17/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RhinoFitClass : NSObject

@property (nonatomic, strong) NSNumber * aId;
@property (nonatomic, strong) NSNumber * allDay;
@property (nonatomic, strong) NSString * classId;
@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSNumber * day;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSNumber * instructorId;
@property (nonatomic, strong) NSString * instructorName;
@property (nonatomic, strong) NSString * origColor;
@property (nonatomic, strong) NSNumber * reservationId;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign) BOOL isActionReservation;
@property (nonatomic, assign) BOOL isActionAttendance;

- (NSComparisonResult)compare:(RhinoFitClass*)otherObject;

@end
