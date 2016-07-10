//
//  Constants.h
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// App Url
extern NSString *const kAppBaseUrl;

// Menu Items
extern NSString *const kMenuClasses;
extern NSString *const kMenuMyReservations;
extern NSString *const kMenuMyAttendance;
extern NSString *const kMenuMyBenchmarks;
extern NSString *const kMenuMyMemberships;
extern NSString *const kMenuWall;
extern NSString *const kMenuMyProfile;
extern NSString *const kMenuLogout;
extern NSString *const kMenuMyWods;

// Request
extern NSString *const kRequestLogin;
extern NSString *const kRequestEula;
extern NSString *const kAcceptEula;
extern NSString *const kRequestGetClassess;
//extern NSString *const kRequestGetUserInfo;
extern NSString *const kRequestMakeReservation;
extern NSString *const kRequestListReservations;
extern NSString *const kRequestDeleteReservation;
extern NSString *const kRequestGetAttendance;
extern NSString *const kRequestMakeAttendance;
extern NSString *const kRequestDeleteAttendance;
extern NSString *const kRequestMyBenchmarks;
extern NSString *const kRequestAvailableBenchmarks;
extern NSString *const kRequestNewBenchmark;
extern NSString *const kRequestMyMemberships;
extern NSString *const kRequestMyBenchmarkData;
extern NSString *const kRequestDeleteBenchmarkData;
extern NSString *const kRequestGetWallPosts;
extern NSString *const kRequestAddWallPost;
extern NSString *const kRequestGetUserInfo;
extern NSString *const kRequestUpdateUserInfo;
extern NSString *const kRequestGetWodInfo;
extern NSString *const kRequestTrackWod;
extern NSString *const kRequestGetMyWods;
extern NSString *const kRequestGetCountries;
extern NSString *const kRequestGetStates;
extern NSString *const kRequestDeletePost;
extern NSString *const kRequestReportPost;

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
extern NSString *const kMessageNoMyBenchmarks;
extern NSString *const kMessageDeleteBenchmark;
extern NSString *const kMessageNoMyMemberships;
extern NSString *const kMessageNoAvailableBenchmarks;
extern NSString *const kMessageNoMyBenchmarkHistories;
extern NSString *const kMessageNoWalls;
extern NSString *const kMessageNoMyWods;

// Button Names

extern NSString *const kButtonMakeReservation;
extern NSString *const kButtonCancelReservation;
extern NSString *const kButtonMarkAttended;
extern NSString *const kButtonCancelAttendance;

// Globals
extern NSString *const kRhinoFitUserToken;
extern NSString *const kRhinoFitUserEmail;
extern NSString *const kIsFirstUser;

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
extern NSString *const kParamEulaVersionId;

extern NSString *const kParamBId;
extern NSString *const kParamBDesc;
extern NSString *const kParamBType;
extern NSString *const kParamBBestDate;
extern NSString *const kParamBBestResults;
extern NSString *const kParamBLastDate;
extern NSString *const kParamBLastResults;
extern NSString *const kParamBFormat;
extern NSString *const kParamId;
extern NSString *const kParamValue;

extern NSString *const kParamMId;
extern NSString *const kParamMName;
extern NSString *const kParamMStartDate;
extern NSString *const kParamMEndDate;
extern NSString *const kParamMRenewal;
extern NSString *const kParamMAttended;
extern NSString *const kParamMAttendedLimit;
extern NSString *const kParamMLimit;

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

// getwodinfo
extern NSString *const kResponseKeyWodCanEdit;
extern NSString *const kResponseKeyWodId;
extern NSString *const kResponseKeyWodName;
extern NSString *const kResponseKeyWodResults;
extern NSString *const kResponseKeyWodStart;
extern NSString *const kResponseKeyWodTitle;
extern NSString *const kResponseKeyWodWod;
extern NSString *const kResponseKeyWodWodId;

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
extern NSString *const kResponseKeyUserEmail;
extern NSString *const kResponseKeyUserName;
extern NSString *const kResponseKeyUserPicture;

// reservation
extern NSString *const kResponseKeyReservationId;
extern NSString *const kResponseKeyReservationTitle;
extern NSString *const kResponseKeyReservationWhen;

// attendance
extern NSString *const kResponseKeyAttendanceId;
extern NSString *const kResponseKeyAttendanceTitle;
extern NSString *const kResponseKeyAttendanceWhen;

// wall
extern NSString *const kResponseKeyWallId;
extern NSString *const kResponseKeyWallMessage;
extern NSString *const kResponseKeyWallUserName;
extern NSString *const kResponseKeyWallPic;
extern NSString *const kResponseKeyWallUserPicture;
extern NSString *const kResponseKeyWallYours;
extern NSString *const kResponseKeyWallFlaggable;

// result
extern NSString *const kResponseKeyResult;


// Notification

extern NSString *const kNotificationGetUserInfo;
extern NSString *const kNotificationUpdateProfile;
extern NSString *const kNotificationMyWods;

@interface Constants : NSObject

@end
