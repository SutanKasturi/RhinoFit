//
//  UserManager.m
//  AKGithubClient
//
//  Created by Alex Kurkin on 12/26/13.
//  Copyright (c) 2013 Brilliant Consulting Inc. All rights reserved.
//

#import "NetworkManager.h"
#import <RestKit/RestKit.h>
#import "CoreDataHandler.h"
#import "Constants.h"
#import "RequestFail.h"

#import "LoginRequest.h"
#import "UserInfoRequest.h"
#import "UpdateUserInfoRequest.h"
#import "GetCountriesRequest.h"
#import "GetStatesRequest.h"

#import "ClassesRequest.h"
#import "RhinoFitClass.h"
#import "MakeReservationRequest.h"
#import "ListReservationRequest.h"
#import "DeleteReservationRequest.h"
#import "GetAttendanceRequest.h"
#import "MakeAttendanceRequest.h"
#import "DeleteAttendanceRequest.h"

#import "GetWodInfoRequest.h"
#import "WodInfo.h"
#import "TrackWodRequest.h"
#import "GetMyWodsRequest.h"

#import "DeleteBenchmarkData.h"
#import "Reservation.h"
#import "Attendance.h"
#import "BenchmarkHistory.h"

#import "MyBenchmarksRequest.h"
#import "AddNewBenchmarkRequest.h"
#import "MyMembershipsRequest.h"
#import "AvailableBenchmarksRequest.h"
#import "MyBenchmark.h"
#import "MyBenchmarkDataRequest.h"
#import "MyMembership.h"
#import "AvailableBenchmark.h"

#import "Wall.h"
#import "GetWallPostsRequest.h"
#import "AddWallPostRequest.h"

//#import <NSData+Base64.h>

@implementation NetworkManager

#pragma mark - User Manager

static UserInfo* currentUser;

// UserInfo
- (UserInfo*) getUser
{
    if ( currentUser )
        return currentUser;
//    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
//    NSArray *result = [cdHandler getAllDataForEntity:kCoreDataUserInfo];
//    for ( UserInfo *user in result ) {
//        currentUser = user;
//        return currentUser;
//    }
    
    return nil;
}

- (void) updateuserInfo {
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    
    NSArray *result = [cdHandler getAllDataForEntity:kCoreDataUserInfo];
    for ( UserInfo *user in result ) {
        currentUser = user;
        return;
    }
}

- (void) deleteUser
{
    if ( currentUser == nil )
        return;
    
    currentUser = nil;
    NSLog(@"DELETE USER");
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    [sharedInstance removeObjectForKey:kParamToken];
    
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    [cdHandler deleteAllDataForEntity:kCoreDataUserInfo sortField:@"userEmail"];
}

- (NSString*) getToken
{
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    NSString *token = [sharedInstance objectForKey:kParamToken];
    if ( token != nil && ![token isEqualToString:@""] ) {
        return token;
    }
    
    return @"";
}

- (void)sendEmailLogin:(NSString *)email
              password:(NSString *)password
               success:(void (^)(BOOL isLoggedIn))success
               failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    LoginRequest *dataObject = [LoginRequest new];
    [dataObject setAction:kRequestLogin];
    [dataObject setEmail:email];
    [dataObject setPassword:password];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error ) {
                     [self errorMessage:error.localizedDescription];
                     if ( success )
                         success(NO);
                 }
                 else {
                     if ( [response objectForKey:@"token"] ){
                         NSString *token = [response objectForKey:@"token"];
                         NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
                         [sharedInstance setObject:token forKey:kParamToken];
                         [sharedInstance setObject:email forKey:kRhinoFitUserEmail];
                         if ( success )
                             success(YES);
                     }
                     else {
                         NSString *error = [response objectForKey:@"error"];
                         [self errorMessage:error];
                         if ( success )
                             success(NO);
                     }
                 }             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self errorMessage:error.localizedDescription];
                 if ( failure )
                     failure(operation, error);
             }];
}

#pragma mark - Classes
- (NSArray*) getClasses:(NSDate*)date
{
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    return [cdHandler getAllDataForEntity:kCoreDataClass];
}

#pragma mark - User Info
- (void) getUserInfo:(void (^)(id result))success
             failure:(void (^)(NSString *error))failure
{
    UserInfoRequest *dataObject = [UserInfoRequest new];
    [dataObject setAction:kRequestGetUserInfo];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error ) {
                     if ( failure )
                         failure(error.localizedDescription);
                     [self errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                         [self errorMessage:error];
                     }
                     else {
                         CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
                         NSDictionary *userInfo = @{
                                                    @"userFirstName":[response objectForKey:kResponseKeyUserFirstName]?[response objectForKey:kResponseKeyUserFirstName]:@"",
                                                    @"userLastName":[response objectForKey:kResponseKeyUserLastName]?[response objectForKey:kResponseKeyUserLastName]:@"",
                                                    @"userAddress1":[response objectForKey:kResponseKeyUserAddress1]?[response objectForKey:kResponseKeyUserAddress1]:@"",
                                                    @"userAddress2":[response objectForKey:kResponseKeyUserAddress2]?[response objectForKey:kResponseKeyUserAddress2]:@"",
                                                    @"userCity":[response objectForKey:kResponseKeyUserCity]?[response objectForKey:kResponseKeyUserCity]:@"",
                                                    @"userCountry":[response objectForKey:kResponseKeyUserCountry]?[response objectForKey:kResponseKeyUserCountry]:@"",
                                                    @"userPhone1":[response objectForKey:kResponseKeyUserPhone1]?[response objectForKey:kResponseKeyUserPhone1]:@"",
                                                    @"userPhone2":[response objectForKey:kResponseKeyUserPhone2]?[response objectForKey:kResponseKeyUserPhone2]:@"",
                                                    @"userState":[response objectForKey:kResponseKeyUserState]?[response objectForKey:kResponseKeyUserState]:@"",
                                                    @"userZip":[response objectForKey:kResponseKeyUserZip]?[response objectForKey:kResponseKeyUserZip]:@"",
                                                    @"userEmail":[response objectForKey:kResponseKeyUserName]?[response objectForKey:kResponseKeyUserName]:@"",
                                                    @"userPicture":[response objectForKey:kResponseKeyUserPicture]?[response objectForKey:kResponseKeyUserPicture]:@""
                                                    };
                         [cdHandler deleteAllDataForEntity:kCoreDataUserInfo sortField:@"userEmail"];
                         [cdHandler insertNewRecord:kCoreDataUserInfo fields:userInfo];
                         [self updateuserInfo];
                         if ( success )
                             success(userInfo);
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateProfile object:userInfo];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) updateUserInfo:(UIImage*)image
              firstName:(NSString*)firstName
               lastName:(NSString*)lastName
               address1:(NSString*)address1
               address2:(NSString*)address2
                   city:(NSString*)city
       stateAndProvince:(NSString*)stateAndProvice
           zipAndPostal:(NSString*)zipAndPostal
                country:(NSString*)country
              homePhone:(NSString*)homePhone
            mobilePhone:(NSString*)mobilePhone
                  email:(NSString*)email
                success:(void (^)(id result))success
                failure:(void (^)(NSString *error))failure {
    UpdateUserInfoRequest *dataObject = [UpdateUserInfoRequest new];
    [dataObject setAction:kRequestUpdateUserInfo];
    [dataObject setToken:[self getToken]];
    [dataObject setU_first:firstName];
    [dataObject setU_last:lastName];
    [dataObject setU_address1:address1];
    [dataObject setU_address2:address2];
    [dataObject setU_city:city];
    [dataObject setU_state:stateAndProvice];
    [dataObject setU_zip:zipAndPostal];
    [dataObject setU_country:country];
    [dataObject setU_phone1:homePhone];
    [dataObject setU_phone2:mobilePhone];
    [dataObject setU_username:email];
    if ( image )
        [dataObject setFile:UIImageJPEGRepresentation(image, 1.0f)];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error ) {
                     if ( failure )
                         failure(error.localizedDescription);
                     [self errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                         [self errorMessage:error];
                     }
                     else {
                         CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
                         NSString *photo = [response objectForKey:@"photo"];
                         if ( photo == nil || [photo isEqualToString:@""] || [photo isKindOfClass:[NSNull class]] ) {
                             photo = [self getUser].userPicture;
                         }
                         NSDictionary *userInfo = @{
                                                    @"userFirstName":firstName,
                                                    @"userLastName":lastName,
                                                    @"userAddress1":address1,
                                                    @"userAddress2":address2,
                                                    @"userCity":city,
                                                    @"userCountry":country,
                                                    @"userPhone1":homePhone,
                                                    @"userPhone2":mobilePhone,
                                                    @"userState":stateAndProvice,
                                                    @"userZip":zipAndPostal,
                                                    @"userEmail":email,
                                                    @"userPicture":photo
                                                    };
                         [cdHandler deleteAllDataForEntity:kCoreDataUserInfo sortField:@"userEmail"];
                         [cdHandler insertNewRecord:kCoreDataUserInfo fields:userInfo];
                         [self updateuserInfo];
                         if ( success )
                             success(userInfo);
                                 
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateProfile object:userInfo];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

static NSArray *_countries;
- (void) getCountries:(void (^)(id results))success
              failure:(void (^)(NSString *error))failure {
    if ( _countries ) {
        if ( success )
            success(_countries);
        return;
    }
    
    GetCountriesRequest *dataObject = [GetCountriesRequest new];
    [dataObject setAction:kRequestGetCountries];
    [dataObject setToken:[self getToken]];

    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error ) {
                     if ( failure )
                         failure(error.localizedDescription);
                     [self errorMessage:error.localizedDescription];
                 }
                 if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ){
                     NSString *error = [response objectForKey:@"error"];
                     if ( failure )
                         failure(error);
                     [self errorMessage:error];
                 }
                 else if ( [response isKindOfClass:[NSArray class]] ){
                     _countries = (NSArray*)response;
                     if ( success )
                         success(response);
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

static NSMutableDictionary *_states;

- (void) getStates:(NSString*)country
           success:(void (^)(id result))success
           failure:(void (^)(NSString *error))failure {
    if ( _states ) {
        NSArray *states = [_states objectForKey:country];
        if ( states ) {
            if ( success )
                success(states);
            return;
        }
    }
    
    GetStatesRequest *dataObject = [GetStatesRequest new];
    [dataObject setAction:kRequestGetStates];
    [dataObject setToken:[self getToken]];
    [dataObject setCountry:country];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error ) {
                     if ( failure )
                         failure(error.localizedDescription);
                     [self errorMessage:error.localizedDescription];
                 }
                 if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ){
                     NSString *error = [response objectForKey:@"error"];
                     if ( failure )
                         failure(error);
                     [self errorMessage:error];
                 }
                 else if ( [response isKindOfClass:[NSArray class]] ){
                     if ( _states == nil )
                         _states = [[NSMutableDictionary alloc] init];
                     [_states setObject:response forKey:country];
                     if ( success )
                         success(response);
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

static NSDateFormatter *sUserVisibleDateFormatter = nil;

- (NSDate *)getDateFromRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    // Convert the RFC 3339 date time string to an NSDate.
    return [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
}


#pragma mark - Classes

- (void) getClassess:(NSString*)startDate
             endDate:(NSString *)endDate
             success:(void (^)(NSArray*result))success
             failure:(void (^)(NSString *error))failure
{
    ClassesRequest *dataObject = [ClassesRequest new];
    [dataObject setAction:kRequestGetClassess];
    [dataObject setToken:[self getToken]];
    [dataObject setStartdate:startDate];
    [dataObject setEnddate:endDate];
    
    // what to print
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);

    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure ) {
                         failure(operation.HTTPRequestOperation.responseString);
                     }
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( ![response isKindOfClass:[NSArray class]] && [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else {
                         NSMutableArray *result = [[NSMutableArray alloc] init];
                         for ( NSDictionary *theClass in response ) {
                             RhinoFitClass *class = [[RhinoFitClass alloc] init];
                             class.startDate = [self getDateFromRFC3339DateTimeString:[theClass objectForKey:kResponseKeyStartDate]];
                             class.endDate = [self getDateFromRFC3339DateTimeString:[theClass objectForKey:kResponseKeyEndDate]];
                             class.allDay = [NSNumber numberWithBool:[[theClass objectForKey:kResponseKeyAllDay] boolValue]];
                             class.title = [theClass objectForKey:kResponseKeyTitle];
                             class.color = [theClass objectForKey:kResponseKeyColor];
                             class.origColor = [theClass objectForKey:kResponseKeyOrigColor];
                             class.reservationId = [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyReservation] intValue]];
                             class.instructorId = [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyInstructorId] intValue]];
                             class.instructorName = [theClass objectForKey:kResponseKeyInstructorName];
                             class.classId = [theClass objectForKey:kResponseKeyClassId];
                             class.aId = [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyAttendanceId] intValue]];
                             class.day = [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyDay] intValue]];
                             class.isActionAttendance = NO;
                             class.isActionReservation = NO;
                             [result addObject:class];
                         }
                         if ( success ) {
                             success(result);
                         }
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( operation.HTTPRequestOperation.response.statusCode == RKStatusCodeClassSuccessful ) {
                     if ( success )
                         success(nil);
                 }
                 else {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
             }];
}

- (void) makeReservation:(NSString*)classId
         reservationDate:(NSString*)reservationDate
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(NSString *error))failure
{
    MakeReservationRequest *dataObject = [[MakeReservationRequest alloc] init];
    [dataObject setAction:kRequestMakeReservation];
    [dataObject setToken:[self getToken]];
    [dataObject setClasstimeid:classId];
    [dataObject setDate:reservationDate];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             if ( failure )
                                 failure(error);
                         }
                         else {
                             if ( success )
                                 success(response);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) listReservation:(void (^)(NSMutableArray *result))success
                 failure:(void (^)(NSString *error))failure
{
    ListReservationRequest *dataObject = [[ListReservationRequest alloc] init];
    [dataObject setAction:kRequestListReservations];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure (error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         if ( success ) {
                             NSMutableArray *result = [[NSMutableArray alloc] init];
                             for ( NSDictionary *dict in response ) {
                                 Reservation *reservation = [[Reservation alloc] init];
                                 reservation.reservationId = [NSNumber numberWithInt:[[dict objectForKey:kResponseKeyReservationId] intValue]];
                                 reservation.title = [dict objectForKey:kResponseKeyTitle];
                                 
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];

                                 reservation.when = [df dateFromString:[dict objectForKey:kResponseKeyReservationWhen]];
                                 reservation.isActionReservation = NO;
                                 [result addObject:reservation];
                             }
                             success (result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
- (void) deleteReservation:(NSString*)resId
                   success:(void (^)(BOOL isSuccess))success
                   failure:(void (^)(NSString *error))failure
{
    DeleteReservationRequest *dataObject = [[DeleteReservationRequest alloc] init];
    [dataObject setAction:kRequestDeleteReservation];
    [dataObject setToken:[self getToken]];
    [dataObject setResid:resId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             if ( failure )
                                 failure(error);
                         }
                         else if ( [[response objectForKey:kResponseKeyResult] intValue] == 1 ){
                             if ( success )
                                 success(YES);
                         }
                         else
                         {
                             if ( failure )
                                 failure(kMessageUnkownError);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
- (void) getAttendance:(NSString*)startDate
               endDate:(NSString *)endDate
               success:(void (^)(NSMutableArray *result))success
               failure:(void (^)(NSString *error))failure
{
    GetAttendanceRequest *dataObject = [[GetAttendanceRequest alloc] init];
    [dataObject setAction:kRequestGetAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setStartdate:startDate];
    [dataObject setEnddate:endDate];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure (error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         if ( success ) {
                             NSMutableArray *result = [[NSMutableArray alloc] init];
                             for ( NSDictionary *dict in response ) {
                                 Attendance *attendance = [[Attendance alloc] init];
                                 attendance.attendanceId = [NSNumber numberWithInt:[[dict objectForKey:kResponseKeyAttendanceId] intValue]];
                                 attendance.title = [dict objectForKey:kResponseKeyTitle];
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
                                 attendance.when = [df dateFromString:[dict objectForKey:kResponseKeyAttendanceWhen]];
                                 attendance.isActionAttendance = NO;
                                 [result addObject:attendance];
                             }
                             if ( success )
                                 success(result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
- (void) makeAttendance:(NSString*)classId
         attendanceDate:(NSString*)attendanceDate
                success:(void (^)(NSNumber *attendanceId))success
                failure:(void (^)(NSString *error))failure
{
    MakeAttendanceRequest *dataObject = [[MakeAttendanceRequest alloc] init];
    [dataObject setAction:kRequestMakeAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setClasstimeid:classId];
    [dataObject setDate:attendanceDate];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else if ( [response isKindOfClass:[NSDictionary class]] ){
                     if ( [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response objectForKey:kResponseKeyAttendanceId] ) {
                         NSNumber *attendanceId = [NSNumber numberWithInt:[[response objectForKey:kResponseKeyAttendanceId] intValue]];
                         if ( success )
                             success(attendanceId);
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
- (void) deleteAttendance:(NSString*)aId
                  success:(void (^)(BOOL isSuccess))success
                  failure:(void (^)(NSString *error))failure
{
    DeleteAttendanceRequest *dataObject = [[DeleteAttendanceRequest alloc] init];
    [dataObject setAction:kRequestDeleteAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setAid:aId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else if ( [response isKindOfClass:[NSDictionary class]] ){
                     if ( [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [[response objectForKey:kResponseKeyResult] intValue] == 1 ){
                         if ( success )
                             success(YES);
                     }
                     else
                     {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}


#pragma mark - WODs

- (void) getWodInfo:(NSString*)classId
          startDate:(NSDate*)startDate
            success:(void (^)(id results))success
            failure:(void (^)(NSString *error))failure {
    GetWodInfoRequest *dataObject = [[GetWodInfoRequest alloc] init];
    [dataObject setAction:kRequestGetWodInfo];
    [dataObject setToken:[self getToken]];
    [dataObject setId:classId];
    [dataObject setStart:startDate];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else if ( [response isKindOfClass:[NSDictionary class]] ){
                     if ( [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else {
                         WodInfo *wodInfo = [[WodInfo alloc] init];
                         wodInfo.name = [response objectForKey:kResponseKeyWodName];
                         wodInfo.canEdit = [[response objectForKey:kResponseKeyWodCanEdit] boolValue];
                         wodInfo.classId = [response objectForKey:kResponseKeyWodId];
                         wodInfo.results = [response objectForKey:kResponseKeyWodResults];
                         wodInfo.startDate = [self getDateFromRFC3339DateTimeString:[response objectForKey:kResponseKeyWodStart]];
                         wodInfo.title = [response objectForKey:kResponseKeyWodTitle];
                         wodInfo.wod = [response objectForKey:kResponseKeyWodWod];
                         wodInfo.wodId = [response objectForKey:kResponseKeyWodWodId];
                         if ( success )
                             success(wodInfo);
                     }
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) trackWod:(NSString*)classId
        startDate:(NSDate*)startDate
              wod:(NSString*)wod
            title:(NSString*)title
          results:(NSString*)results
          success:(void (^)(id results))success
          failure:(void (^)(NSString *error))failure {
    TrackWodRequest *dataObject = [[TrackWodRequest alloc] init];
    [dataObject setAction:kRequestTrackWod];
    [dataObject setToken:[self getToken]];
    [dataObject setId:classId];
    [dataObject setStart:startDate];
    [dataObject setWod:wod];
    [dataObject setTitle:title];
    [dataObject setResults:results];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else if ( [response isKindOfClass:[NSDictionary class]] ){
                     if ( [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else {
                         if ( success )
                             success(response);
                     }
                 }
                 else {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) getMyWods:(NSString*)startDate
           endDate:(NSString *)endDate
           success:(void (^)(NSArray*result))success
           failure:(void (^)(NSString *error))failure {
    GetMyWodsRequest *dataObject = [GetMyWodsRequest new];
    [dataObject setAction:kRequestGetMyWods];
    [dataObject setToken:[self getToken]];
    [dataObject setStartdate:startDate];
    [dataObject setEnddate:endDate];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure ) {
                         failure(operation.HTTPRequestOperation.responseString);
                     }
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         NSMutableArray *result = [[NSMutableArray alloc] init];
                         NSLog(@"%@", response);
                         for ( NSDictionary *dict in response ) {
                             WodInfo *wodInfo = [[WodInfo alloc] init];
                             wodInfo.name = [dict objectForKey:kResponseKeyWodName] && ![[dict objectForKey:kResponseKeyWodName] isKindOfClass:[NSNull class]] ? [dict objectForKey:kResponseKeyWodName]:@"";
                             wodInfo.canEdit = [[dict objectForKey:kResponseKeyWodCanEdit] boolValue];
                             wodInfo.classId = [dict objectForKey:kResponseKeyWodId];
                             wodInfo.results = [dict objectForKey:kResponseKeyWodResults] && ![[dict objectForKey:kResponseKeyWodResults] isKindOfClass:[NSNull class]] ? [dict objectForKey:kResponseKeyWodResults]:@"";
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             [df setDateFormat:@"yyyy-MM-dd hh:mm"];
                             wodInfo.startDate = ![[dict objectForKey:kResponseKeyWodStart] isKindOfClass:[NSNull class]]
                                                        ?[df dateFromString:[dict objectForKey:kResponseKeyWodStart]]:nil;
                             wodInfo.title = [dict objectForKey:kResponseKeyWodTitle] && ![[dict objectForKey:kResponseKeyWodTitle] isKindOfClass:[NSNull class]] ? [dict objectForKey:kResponseKeyWodTitle]:@"";
                             wodInfo.wod = [dict objectForKey:kResponseKeyWodWod] && ![[dict objectForKey:kResponseKeyWodWod] isKindOfClass:[NSNull class]] ? [dict objectForKey:kResponseKeyWodWod]:@"";
                             wodInfo.wodId = [dict objectForKey:kResponseKeyWodWodId];
                             [result addObject:wodInfo];
                         }
                         if ( success ) {
                             success(result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( operation.HTTPRequestOperation.response.statusCode == RKStatusCodeClassSuccessful ) {
                     if ( success )
                         success(nil);
                 }
                 else {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
             }];
}


#pragma mark - Benchmark

- (void) getMyBenchmarks:(void (^)(NSMutableArray*result))success
                 failure:(void (^)(NSString *error))failure
{
    MyBenchmarksRequest *dataObject = [[MyBenchmarksRequest alloc] init];
    [dataObject setAction:kRequestMyBenchmarks];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure ) {
                             failure(error);
                         }
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         NSMutableArray *result = [[NSMutableArray alloc] init];
                         for ( NSDictionary *dict in response ) {
                             NSLog(@"%@", dict);
                             if ( ![[dict objectForKey:kParamBBestResults] isKindOfClass:[NSNull class]] ) {
                                 MyBenchmark *benchmark = [[MyBenchmark alloc] init];
                                 benchmark.benchmarkId = [NSNumber numberWithInt:[[dict objectForKey:kParamBId] intValue]];
                                 benchmark.title = [dict objectForKey:kParamBDesc];
                                 benchmark.type = [dict objectForKey:kParamBType];
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"yyyy-MM-dd"];
                                 benchmark.currentDate = [df dateFromString:[dict objectForKey:kParamBBestDate]];
                                 benchmark.currentScore = [dict objectForKey:kParamBBestResults];
                                 benchmark.lastDate = [df dateFromString:[dict objectForKey:kParamBLastDate]];
                                 benchmark.lastScore = [dict objectForKey:kParamBLastResults];
                                 [result addObject:benchmark];
                             }
                         }
                         if ( success )
                             success(result);
                     }
                     else {
                         if ( failure ) {
                             failure(kMessageUnkownError);
                         }
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
- (void) addNewBenchmark:(NSString*)benchmarkId
                    date:(NSString*)date
                   value:(NSString*)value
                  dataId:(NSString*)dataId
                 success:(void (^)(NSNumber *benchmarkDataId))success
                 failure:(void (^)(NSString *error))failure
{
    AddNewBenchmarkRequest *dataObject = [[AddNewBenchmarkRequest alloc] init];
    [dataObject setAction:kRequestNewBenchmark];
    [dataObject setToken:[self getToken]];
    [dataObject setId:benchmarkId];
    [dataObject setDate:date];
    [dataObject setValue:value];
    [dataObject setDataid:dataId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure (operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             if ( failure )
                                 failure(error);
                         }
                         else {
                             NSNumber *benchmarkDataId = [NSNumber numberWithInt:[[response objectForKey:kParamId] intValue]];
                             if (success) {
                                 success(benchmarkDataId);
                             }
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if (failure)
                     failure(error.localizedDescription);
             }];
}

- (void) getAvailableBenchmarks:(void (^)(NSMutableArray*result))success
                        failure:(void (^)(NSString *error))failure
{
    AvailableBenchmarksRequest *dataObject = [[AvailableBenchmarksRequest alloc] init];
    [dataObject setAction:kRequestAvailableBenchmarks];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure ) {
                             failure(error);
                         }
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         NSMutableArray *result = [[NSMutableArray alloc] init];
                         for ( NSDictionary *dict in response ) {
                             NSLog(@"%@", dict);
                             AvailableBenchmark *availableBenchmark = [[AvailableBenchmark alloc] init];
                             availableBenchmark.benchmarkId = [NSNumber numberWithInt:[[dict objectForKey:kParamBId] intValue]];
                             availableBenchmark.bdescription = [dict objectForKey:kParamBDesc];
                             availableBenchmark.btype = [dict objectForKey:kParamBType];
                             availableBenchmark.bformat = [dict objectForKey:kParamBFormat];
                             [result addObject:availableBenchmark];
                         }
                         if ( success )
                             success(result);
                     }
                     else {
                         if ( failure ) {
                             failure(kMessageUnkownError);
                         }
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) getMyBenchmarkData:(NSString*)benchmarkId
                    success:(void (^)(NSMutableArray*result))success
                    failure:(void (^)(NSString *error))failure
{
    MyBenchmarkDataRequest *dataObject = [[MyBenchmarkDataRequest alloc] init];
    [dataObject setAction:kRequestMyBenchmarkData];
    [dataObject setToken:[self getToken]];
    [dataObject setId:benchmarkId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure (operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ) {
                         if ( success ) {
                             NSMutableArray *result = [[NSMutableArray alloc] init];
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             [df setDateFormat:@"yyyy-MM-dd"];
                             for ( NSDictionary *dict in response ) {
                                 BenchmarkHistory *history = [[BenchmarkHistory alloc] init];
                                 [history setBenchmarkDataId:[NSNumber numberWithInt:[[dict objectForKey:kParamId] intValue]]];
                                 [history setDate:[df dateFromString:[dict objectForKey:kParamDate]]];
                                 [history setValue:[dict objectForKey:kParamValue]];
                                 [result addObject:history];
                             }
                             result = [[NSMutableArray alloc] initWithArray:[result sortedArrayUsingSelector:@selector(compare:)]];
                             success(result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if (failure)
                     failure(error.localizedDescription);
             }];
}

- (void) deleteBenchmarkData:(NSString *)benchmarkId
                        date:(NSString*)date
                       value:(NSString*)value
                      dataId:(NSString*)dataId
                     success:(void (^)(BOOL isSuccess))success
                     failure:(void (^)(NSString *error))failure
{
    DeleteBenchmarkData *dataObject = [[DeleteBenchmarkData alloc] init];
    [dataObject setAction:kRequestDeleteBenchmarkData];
    [dataObject setToken:[self getToken]];
    [dataObject setId:benchmarkId];
    [dataObject setDate:date];
    [dataObject setValue:value];
    [dataObject setDataid:dataId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"]){
                     NSString *error = [response objectForKey:@"error"];
                     if ( failure )
                         failure(error);
                 }
                 else if ( [response isKindOfClass:[NSArray class]] ){
                     if ( success )
                         success(YES);
                 }
                 else
                 {
                     if ( failure )
                         failure(kMessageUnkownError);
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) getMyMemberships:(void (^)(NSMutableArray*result))success
                  failure:(void (^)(NSString *error))failure
{
    MyMembershipsRequest *dataObject = [[MyMembershipsRequest alloc] init];
    [dataObject setAction:kRequestMyMemberships];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure(error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure ) {
                             failure(error);
                         }
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         if ( success ) {
                             NSMutableArray *result = [[NSMutableArray alloc] init];
                             for ( NSDictionary *dict in response ) {
                                 NSLog(@"%@", dict);
                                 MyMembership *membership = [[MyMembership alloc] init];
                                 membership.memebershipId = [NSNumber numberWithInt:[[dict objectForKey:kParamMId] intValue]];
                                 membership.membershipName = [dict objectForKey:kParamMName];
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"yyyy-MM-dd"];
                                 membership.startDate = [df dateFromString:[dict objectForKey:kParamMStartDate]];
                                 membership.endDate = [df dateFromString:[dict objectForKey:kParamMEndDate]];
                                 membership.renewal = [dict objectForKey:kParamMRenewal];
                                 membership.attended = [NSNumber numberWithInt:[[dict objectForKey:kParamMAttended] intValue]];
                                 membership.attendedLimit = [NSNumber numberWithInt:[[dict objectForKey:kParamMAttendedLimit] intValue]];
                                 membership.limit = [dict objectForKey:kParamMLimit];
                                 [result addObject:membership];
                             }
                             success(result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

#pragma mark - Walls

- (void) getWallPosts:(void (^)(NSMutableArray*result))success
              failure:(void (^)(NSString *error))failure {
    GetWallPostsRequest *dataObject = [[GetWallPostsRequest alloc] init];
    [dataObject setAction:kRequestGetWallPosts];
    [dataObject setToken:[self getToken]];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure (error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
                         if ( success ) {
                             NSMutableArray *result = [[NSMutableArray alloc] init];
                             for ( NSDictionary *dict in response ) {
                                 Wall *wall = [[Wall alloc] init];
                                 wall.wallId = [NSNumber numberWithInt:[[dict objectForKey:kResponseKeyWallId] intValue]];
                                 wall.msg = [dict objectForKey:kResponseKeyWallMessage]?[dict objectForKey:kResponseKeyWallMessage]:@"";
                                 wall.name = [dict objectForKey:kResponseKeyWallUserName]?[dict objectForKey:kResponseKeyWallUserName]:@"";
                                 wall.profilePic = [dict objectForKey:kResponseKeyWallUserPicture]?[dict objectForKey:kResponseKeyWallUserPicture]:@"";
                                 wall.yours = [[dict objectForKey:kResponseKeyWallYours] boolValue];
                                 wall.pic = ![[dict objectForKey:kResponseKeyWallPic] isKindOfClass:[NSNull class]]?[dict objectForKey:kResponseKeyWallPic]:@"";
                                 [result addObject:wall];
                             }
                             success (result);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}

- (void) addWallPostWithImage:(UIImage*)image
             message:(NSString*)message
             success:(void (^)(NSNumber*wallId))success
             failure:(void (^)(NSString *error))failure {
    AddWallPostRequest *dataObject = [[AddWallPostRequest alloc] init];
    [dataObject setAction:kRequestAddWallPost];
    [dataObject setToken:[self getToken]];
    [dataObject setMsg:message];
    if ( image )
        [dataObject setFile:UIImageJPEGRepresentation(image, 1.0f)];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     if ( failure )
                         failure(operation.HTTPRequestOperation.responseString);
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     if ( failure )
                         failure (error.localizedDescription);
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         if ( failure )
                             failure(error);
                     }
                     else if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:kResponseKeyWallId] ){
                         if ( success ) {
                             success ([response objectForKey:kResponseKeyWallId]);
                         }
                     }
                     else {
                         if ( failure )
                             failure(kMessageUnkownError);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( failure )
                     failure(error.localizedDescription);
             }];
}
@end