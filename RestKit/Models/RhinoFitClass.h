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

@property (nonatomic, assign) NSNumber * aId;
@property (nonatomic, assign) NSNumber * allDay;
@property (nonatomic, strong) NSString * classId;
@property (nonatomic, strong) NSString * color;
@property (nonatomic, assign) NSNumber * day;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, assign) NSNumber * instructorId;
@property (nonatomic, strong) NSString * instructorName;
@property (nonatomic, strong) NSString * origColor;
@property (nonatomic, assign) NSNumber * reservationId;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign) BOOL isActionReservation;
@property (nonatomic, assign) BOOL isActionAttendance;

- (NSComparisonResult)compare:(RhinoFitClass*)otherObject;

@end
