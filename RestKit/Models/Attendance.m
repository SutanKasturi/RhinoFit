//
//  Attendance.m
//  
//
//  Created by Admin on 10/17/14.
//
//

#import "Attendance.h"


@implementation Attendance

//@dynamic attendanceId;
//@dynamic title;
//@dynamic when;

- (NSComparisonResult)compare:(Attendance*)otherObject {
    NSDate *date1 = self.when;
    NSDate *date2 = otherObject.when;
    return [date1 compare:date2];
}

@end
