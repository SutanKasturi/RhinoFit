//
//  Constants.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "Constants.h"

// App Url
NSString *const kAppBaseUrl = @"https://my.rhinofit.ca/";

// Menu Items
NSString *const kMenuClasses = @"My Classes";
NSString *const kMenuMyReservations = @"My Reservations";
NSString *const kMenuMyAttendance = @"My Attendance";
NSString *const kMenuMyBenchmarks = @"My Benchmarks";
NSString *const kMenuMyMemberships = @"My Memberships";
NSString *const kMenuWall = @"The Wall";
NSString *const kMenuMyProfile = @"My Profile";
NSString *const kMenuLogout = @"Log out";
NSString *const kMenuMyWods = @"My WODS";

// Request
NSString *const kRequestLogin = @"login";
NSString *const kRequestGetClassess = @"getclasses";
//NSString *const kRequestGetUserInfo = @"getuserinfo";
NSString *const kRequestMakeReservation = @"makereservation";
NSString *const kRequestListReservations = @"listreservations";
NSString *const kRequestDeleteReservation = @"deletereservation";
NSString *const kRequestGetAttendance = @"getattendance";
NSString *const kRequestMakeAttendance = @"makeattendance";
NSString *const kRequestDeleteAttendance = @"deleteattendance";
NSString *const kRequestMyBenchmarks = @"listmybenchmarks";
NSString *const kRequestAvailableBenchmarks = @"listavailablebenchmarks";
NSString *const kRequestNewBenchmark = @"addbenchmark";
NSString *const kRequestMyMemberships = @"listmemberships";
NSString *const kRequestMyBenchmarkData = @"listmybenchmarkdata";
NSString *const kRequestDeleteBenchmarkData = @"deletebenchmarkdata";
NSString *const kRequestGetWallPosts = @"getwallposts";
NSString *const kRequestAddWallPost = @"addwallpost";
NSString *const kRequestGetUserInfo = @"getuserinfo";
NSString *const kRequestUpdateUserInfo = @"updateuserinfo";
NSString *const kRequestGetWodInfo = @"getwodinfo";
NSString *const kRequestTrackWod = @"trackwod";
NSString *const kRequestGetMyWods = @"getmywods";
NSString *const kRequestGetCountries = @"getcountries";
NSString *const kRequestGetStates = @"getstates";

// Messages
NSString* const kMessageInvalidLogin = @"Invalid Login";
NSString *const kMessageMakeReservation = @"Make a reservation for this class?";
NSString *const kMessageCancelReservation = @"Are you sure you want to cancel this reservation?";
NSString *const kMessageMarkAttendance = @"Are you sure you want to mark this class as attended?";
NSString *const kMessageCancelAttendance = @"Are you sure you want to cancel this attendance?";
NSString *const kMessageNoClasses = @"There are no classes scheduled for this day";
NSString *const kMessageIsReservation = @"You are reserved in this class";
NSString *const kMessageIsAttended = @"You have attended this class";
NSString *const kMessageIsReservationAndAttended = @"You have reserved and attended this class";
NSString *const kMessageUnkownError = @"Unkown Error";
NSString *const kMessageNoReservations = @"You currently have no upcoming reservations.";
NSString *const kMessageNoAttendance = @"You have not attended any classes in this month.";
NSString *const kMessageNoMyBenchmarks = @"You currently have no benchmarks";
NSString *const kMessageDeleteBenchmark = @"Are you sure you want to delete this entry?";
NSString *const kMessageNoMyMemberships = @"You currently have no memberships";
NSString *const kMessageNoAvailableBenchmarks = @"There are no available benchmarks";
NSString *const kMessageNoMyBenchmarkHistories = @"There are no benchmark histories";
NSString *const kMessageNoWalls = @"There are no walls";
NSString *const kMessageNoMyWods = @"There are no wods";

// Button Names

NSString *const kButtonMakeReservation = @"Make Reservation";
NSString *const kButtonCancelReservation = @"Cancel Reservation";
NSString *const kButtonMarkAttended = @"Mark Attended";
NSString *const kButtonCancelAttendance = @"Cancel Attendance";

// Globals
NSString *const kRhinoFitUserToken = @"com.travis.rhinofit.token";
NSString *const kRhinoFitUserEmail = @"com.travis.rhinofit.email";

// Request Params
NSString *const kParamAction = @"action";
NSString *const kParamEmail = @"email";
NSString *const kParamPassword = @"password";
NSString *const kParamToken = @"token";
NSString *const kParamStartDate = @"startdate";
NSString *const kParamEndDate = @"enddate";
NSString *const kParamClassTimeId = @"classtimeid";
NSString *const kParamDate = @"date";
NSString *const kParamResId = @"resid";
NSString *const kParamAId = @"aid";

NSString *const kParamBId = @"bid";
NSString *const kParamBDesc = @"bdesc";
NSString *const kParamBType = @"btype";
NSString *const kParamBBestDate = @"bbestdate";
NSString *const kParamBBestResults = @"bbestresults";
NSString *const kParamBLastDate = @"blastdate";
NSString *const kParamBLastResults = @"blastresults";
NSString *const kParamBFormat = @"bformat";
NSString *const kParamId = @"id";
NSString *const kParamValue = @"value";

NSString *const kParamMId = @"mid";
NSString *const kParamMName = @"mname";
NSString *const kParamMStartDate = @"mstart";
NSString *const kParamMEndDate = @"mend";
NSString *const kParamMRenewal = @"mrenewal";
NSString *const kParamMAttended = @"mattended";
NSString *const kParamMAttendedLimit = @"mattendedlimit";
NSString *const kParamMLimit = @"mlimit";

// CoreData Tables
NSString *const kCoreDataUserInfo = @"UserInfo";
NSString *const kCoreDataClass = @"RhinoFitClass";
NSString *const kCoreDataReservation = @"Reservation";
NSString *const kCoreDataAttendance = @"Attendance";

//////////////////////////////////////////////
//          Response Keys                   //
//////////////////////////////////////////////

// login
NSString *const kResponseKeyError = @"error";
NSString *const kResponseKeyToken = @"token";

// getclasses
NSString *const kResponseKeyStartDate = @"start";
NSString *const kResponseKeyEndDate = @"end";
NSString *const kResponseKeyTitle = @"title";
NSString *const kResponseKeyAllDay = @"allDay";
NSString *const kResponseKeyColor = @"color";
NSString *const kResponseKeyOrigColor = @"origcolor";
NSString *const kResponseKeyReservation = @"reservation";
NSString *const kResponseKeyInstructorId = @"instructorid";
NSString *const kResponseKeyInstructorName = @"instructorname";
NSString *const kResponseKeyClassId = @"id";
NSString *const kResponseKeyDay = @"day";

// getwodinfo
NSString *const kResponseKeyWodCanEdit = @"canedit";
NSString *const kResponseKeyWodId = @"id";
NSString *const kResponseKeyWodName = @"name";
NSString *const kResponseKeyWodResults = @"results";
NSString *const kResponseKeyWodStart = @"start";
NSString *const kResponseKeyWodTitle = @"title";
NSString *const kResponseKeyWodWod = @"wod";
NSString *const kResponseKeyWodWodId = @"wodid";

// getuserinfo
NSString *const kResponseKeyUserAddress1 = @"u_address1";
NSString *const kResponseKeyUserAddress2 = @"u_address2";
NSString *const kResponseKeyUserCity = @"u_city";
NSString *const kResponseKeyUserCountry = @"u_country";
NSString *const kResponseKeyUserFirstName = @"u_first";
NSString *const kResponseKeyUserLastName = @"u_last";
NSString *const kResponseKeyUserPhone1 = @"u_phone1";
NSString *const kResponseKeyUserPhone2 = @"u_phone2";
NSString *const kResponseKeyUserState = @"u_state";
NSString *const kResponseKeyUserZip = @"u_zip";
NSString *const kResponseKeyUserEmail = @"u_email";
NSString *const kResponseKeyUserName = @"u_username";
NSString *const kResponseKeyUserPicture = @"u_photo";

// reservation
NSString *const kResponseKeyReservationId = @"resid";
NSString *const kResponseKeyReservationTitle = @"title";
NSString *const kResponseKeyReservationWhen = @"when";

// attendance
NSString *const kResponseKeyAttendanceId = @"aid";
NSString *const kResponseKeyAttendanceTitle = @"title";
NSString *const kResponseKeyAttendanceWhen = @"when";

// wall
NSString *const kResponseKeyWallId = @"id";
NSString *const kResponseKeyWallMessage = @"msg";
NSString *const kResponseKeyWallUserName = @"name";
NSString *const kResponseKeyWallPic = @"pic";
NSString *const kResponseKeyWallUserPicture = @"profilepic";
NSString *const kResponseKeyWallYours = @"yours";

// result
NSString *const kResponseKeyResult = @"result";

// Notification

NSString *const kNotificationGetUserInfo = @"get_user_info";
NSString *const kNotificationUpdateProfile = @"update_profile";
NSString *const kNotificationMyWods = @"my_wods";

@implementation Constants

@end
