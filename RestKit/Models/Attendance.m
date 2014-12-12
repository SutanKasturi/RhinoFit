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
    return [self.when compare:otherObject.when];
}

@end
