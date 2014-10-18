//
//  Constants.h
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// App Url
extern NSString *const kAppBaseUrl;

// Menu Items
extern NSString *const kMenuClasses;
extern NSString *const kMenuMyReservations;
extern NSString *const kMenuMyAttendance;
extern NSString *const kMenuLogout;

// Request
extern NSString *const kRequestLogin;
extern NSString *const kRequestGetClassess;
extern NSString *const kRequestGetUserInfo;
extern NSString *const kRequestMakeReservation;
extern NSString *const kRequestListReservations;
extern NSString *const kRequestDeleteReservation;
extern NSString *const kRequestGetAttendance;
extern NSString *const kRequestMakeAttendance;
extern NSString *const kRequestDeleteAttendance;

// Messages
extern NSString *const kMessageInvalidLogin;
extern NSString *const kMessageMakeReservation;
extern NSString *const kMessageCancelReservation;
extern NSString *const kMessageMarkAttendance;
extern NSString *const kMessageCancelAttendance;
extern NSString *const kMessageNoClasses;
extern NSString *const kMessageIsReservation;
extern NSString *const kMessageIsAttended;
extern NSString *const kMessageIsReservationAndAttended;
extern NSString *const kMessageUnkownError;
extern NSString *const kMessageNoReservations;
extern NSString *const kMessageNoAttendance;

// Button Names

extern NSString *const kButtonMakeReservation;
extern NSString *const kButtonCancelReservation;
extern NSString *const kButtonMarkAttended;
extern NSString *const kButtonCancelAttendance;

// Globals
extern NSString *const kRhinoFitUserToken;

// Request Params
extern NSString *const kParamAction;
extern NSString *const kParamEmail;
extern NSString *const kParamPassword;
extern NSString *const kParamToken;
extern NSString *const kParamStartDate;
extern NSString *const kParamEndDate;
extern NSString *const kParamClassTimeId;
extern NSString *const kParamDate;
extern NSString *const kParamResId;
extern NSString *const kParamAId;

// CoreData Tables
extern NSString *const kCoreDataUserInfo;
extern NSString *const kCoreDataClass;
extern NSString *const kCoreDataReservation;
extern NSString *const kCoreDataAttendance;

//////////////////////////////////////////////
//          Response Keys                   //
//////////////////////////////////////////////

// login
extern NSString *const kResponseKeyError;
extern NSString *const kResponseKeyToken;

// getclasses
extern NSString *const kResponseKeyStartDate;
extern NSString *const kResponseKeyEndDate;
extern NSString *const kResponseKeyTitle;
extern NSString *const kResponseKeyAllDay;
extern NSString *const kResponseKeyColor;
extern NSString *const kResponseKeyOrigColor;
extern NSString *const kResponseKeyReservation;
extern NSString *const kResponseKeyInstructorId;
extern NSString *const kResponseKeyInstructorName;
extern NSString *const kResponseKeyClassId;
extern NSString *const kResponseKeyDay;

// getuserinfo
extern NSString *const kResponseKeyUserAddress1;
extern NSString *const kResponseKeyUserAddress2;
extern NSString *const kResponseKeyUserCity;
extern NSString *const kResponseKeyUserCountry;
extern NSString *const kResponseKeyUserFirstName;
extern NSString *const kResponseKeyUserLastName;
extern NSString *const kResponseKeyUserPhone1;
extern NSString *const kResponseKeyUserPhone2;
extern NSString *const kResponseKeyUserState;
extern NSString *const kResponseKeyUserZip;

// reservation
extern NSString *const kResponseKeyReservationId;
extern NSString *const kResponseKeyReservationTitle;
extern NSString *const kResponseKeyReservationWhen;

// attendance
extern NSString *const kResponseKeyAttendanceId;
extern NSString *const kResponseKeyAttendanceTitle;
extern NSString *const kResponseKeyAttendanceWhen;

// result
extern NSString *const kResponseKeyResult;

@interface Constants : NSObject

@end
