//
//  Attendance.h
//  
//
//  Created by Admin on 10/17/14.
//
//

#import <Foundation/Foundation.h>

@interface Attendance : NSObject

@property (nonatomic, strong) NSNumber * attendanceId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * when;
@property (nonatomic, assign) BOOL isActionAttendance;

- (NSComparisonResult)compare:(Attendance*)otherObject;

@end
