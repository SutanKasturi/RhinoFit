//
//  RhinoFitClass.m
//  
//
//  Created by Admin on 10/17/14.
//
//

#import "RhinoFitClass.h"


@implementation RhinoFitClass

//@dynamic aId;
//@dynamic allDay;
//@dynamic classId;
//@dynamic color;
//@dynamic day;
//@dynamic endDate;
//@dynamic instructorId;
//@dynamic instructorName;
//@dynamic origColor;
//@dynamic reservation;
//@dynamic startDate;
//@dynamic title;

- (NSComparisonResult)compare:(RhinoFitClass*)otherObject {
    NSDate *date1 = self.startDate;
    NSDate *date2 = otherObject.startDate;
    return [date1 compare:date2];
}

@end
