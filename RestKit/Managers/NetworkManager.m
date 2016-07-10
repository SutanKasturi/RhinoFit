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
#import "GetEulaRequest.h"
#import "AcceptEulaRequest.h"
#import "UserInfoRequest.h"
#import "UpdateUserInfoRequest.h"
#import "GetCountriesRequest.h"
#import "GetStatesRequest.h"
#import "DeletePostRequest.h"
#import "ReportPost.h"

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
    else {
        [self getUserInfo:nil failure:nil];
    }
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    NSArray *result = [cdHandler getAllDataForEntity:kCoreDataUserInfo];
    for ( UserInfo *user in result ) {
        currentUser = user;
        return currentUser;
    }
    
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

- (BOOL) checkValidUser {
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    BOOL isValid = [sharedInstance boolForKey:kIsFirstUser];
    return isValid;
}

- (void)sendEmailLogin:(NSString *)email
              password:(NSString *)password
               success:(void (^)(BOOL isLoggedIn, BOOL isValidUser))success
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
                 NSLog(@"Login API %@", response);
                 if ( error ) {
                     [self errorMessage:error.localizedDescription];
                     if ( success )
                         success(NO, NO);
                 }
                 else {
                     if ( [response objectForKey:@"token"] ){
                         NSString *token = [response objectForKey:@"token"];
                         NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
                         [sharedInstance setObject:token forKey:kParamToken];
                         [sharedInstance setObject:email forKey:kRhinoFitUserEmail];
                         if ([[response objectForKey:@"valideula"] integerValue] == 0) {
                             [sharedInstance setBool:NO forKey:kIsFirstUser];
                             if (success) {
                                 success(YES, NO);
                             }
                         } else {
                             [sharedInstance setBool:YES forKey:kIsFirstUser];
                             if ( success )
                                 success(YES, YES);
                         }
                     }
                     else {
                         NSString *error = [response objectForKey:@"error"];
                         [self errorMessage:error];
                         if ( success )
                             success(NO, NO);
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self errorMessage:error.localizedDescription];
                 if ( failure )
                     failure(operation, error);
             }];
}

- (void) getCurrentEula:(NSString *)token
                success:(void (^)(NSString *eulaContent))success
                 failed:(void (^)(NSError *error))failed {
    
    GetEulaRequest *dataObject = [GetEulaRequest new];
    [dataObject setAction:kRequestEula];
    [dataObject setToken:token];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation,RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 NSLog(@"Get Eula API %@", response);
                 if (error) {
                     [self errorMessage:error.localizedDescription];
                     if (success) {
                         success(@"");
                     }
                 } else {
                     if ([[response objectForKey:@"success"] integerValue] == 1) {
                         NSString *versionId = [response objectForKey:@"versionid"];
                         NSString *eulaContent = [response objectForKey:@"html"];
                         NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
                         [sharedInstance setObject:versionId forKey:kParamEulaVersionId];
                         if (success) {
                             success(eulaContent);
                         }
                     }
                 }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", error.description);
        [self errorMessage:error.localizedDescription];
        if ( failed )
            failed(error);
    }];
}

- (void) deleteWallPost:(NSNumber *)wallId
                success:(void (^)(BOOL ))success
                failure:(void (^)(NSString *))failure {
    
    DeletePostRequest *dataObject = [DeletePostRequest new];
    [dataObject setAction:kRequestDeletePost];
    [dataObject setToken:[self getToken]];
    [dataObject setWallid:wallId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 NSLog(@"Delete Wall Post API %@", response);
                 if (error) {
                     [self errorMessage:error.localizedDescription];
                     if (success) {
                         success(NO);
                     }
                 } else {
                     if (success) {
                         success(YES);
                     }
                 }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) reportWallPost:(NSNumber *)wallId
                success:(void (^)(BOOL))success
                failure:(void (^)(NSString *))failure {
    ReportPost *dataObject = [ReportPost new];
    [dataObject setAction:kRequestReportPost];
    [dataObject setToken:[self getToken]];
    [dataObject setWallid:wallId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 NSLog(@"Report Wall Post API %@", response);
                 if (error) {
                     [self errorMessage:error.localizedDescription];
                     if (success) {
                         success(NO);
                     }
                 } else {
                     if (success) {
                         success(YES);
                     }
                 }
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 
             }];
}

- (void) acceptEula:(NSString *)versionId
            success:(void (^)(BOOL isSuccess))success
             failed:(void (^)(NSError *))failed {
    AcceptEulaRequest *dataObject = [AcceptEulaRequest new];
    [dataObject setAction:kAcceptEula];
    [dataObject setToken:[self getToken]];
    [dataObject setVersionid:versionId];
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 NSLog(@"Accept Eula %@", response);
                 if (error) {
                     [self errorMessage:error.localizedDescription];
                     if (success) {
                         success(NO);
                     }
                 } else {
                     NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
                     [sharedInstance setBool:YES forKey:kIsFirstUser];
                     if (success) {
                         success(YES);
                     }
                 }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@", error.description);
        [self errorMessage:error.localizedDescription];
        if ( failed )
            failed(error);
    }];
}

- (BOOL) isNull:(NSDictionary*)dict keyValue:(NSString*)keyValue
{
    NSString *value = [dict objectForKey:keyValue];
    if ( value == nil
        || [value isKindOfClass:[NSNull class]]
        || ([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"] || [value isEqualToString:@"<null>"]))
        )
        return YES;
    return NO;
}
#pragma mark - Classes
- (NSArray*) getClasses:(NSDate*)date
{
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    return [cdHandler getAllDataForEntity:kCoreDataClass];
}

#pragma mark - User Info

//- (void) getUserInfoEula:(void (^)(id))success
//                 failure:(void (^)(NSString *))failure {
//    UserInfoRequest *dataObject = [UserInfoRequest new];
//    [dataObject setAction:kRequestGetUserInfoE];
//    [dataObject setToken:[self getToken]];
//    
//}
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
                 NSLog(@"User Info : %@", response);
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
                                                    @"userFirstName":![self isNull:response keyValue:kResponseKeyUserFirstName]?[response objectForKey:kResponseKeyUserFirstName]:@"",
                                                    @"userLastName":![self isNull:response keyValue:kResponseKeyUserLastName]?[response objectForKey:kResponseKeyUserLastName]:@"",
                                                    @"userAddress1":![self isNull:response keyValue:kResponseKeyUserAddress1]?[response objectForKey:kResponseKeyUserAddress1]:@"",
                                                    @"userAddress2":![self isNull:response keyValue:kResponseKeyUserAddress2]?[response objectForKey:kResponseKeyUserAddress2]:@"",
                                                    @"userCity":![self isNull:response keyValue:kResponseKeyUserCity]?[response objectForKey:kResponseKeyUserCity]:@"",
                                                    @"userCountry":![self isNull:response keyValue:kResponseKeyUserCountry]?[response objectForKey:kResponseKeyUserCountry]:@"",
                                                    @"userPhone1":![self isNull:response keyValue:kResponseKeyUserPhone1]?[response objectForKey:kResponseKeyUserPhone1]:@"",
                                                    @"userPhone2":![self isNull:response keyValue:kResponseKeyUserPhone2]?[response objectForKey:kResponseKeyUserPhone2]:@"",
                                                    @"userState":![self isNull:response keyValue:kResponseKeyUserState]?[response objectForKey:kResponseKeyUserState]:@"",
                                                    @"userZip":![self isNull:response keyValue:kResponseKeyUserZip]?[response objectForKey:kResponseKeyUserZip]:@"",
                                                    @"userEmail":![self isNull:response keyValue:kResponseKeyUserName]?[response objectForKey:kResponseKeyUserName]:@"",
                                                    @"userPicture":![self isNull:response keyValue:kResponseKeyUserPicture]?[response objectForKey:kResponseKeyUserPicture]:@""
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
                         if ( [photo isEqual:[NSNull null]] || photo == nil || [photo isEqualToString:@""] || [photo isKindOfClass:[NSNull class]] ) {
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
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    return date;
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
                             class.startDate = [self isNull:theClass keyValue:kResponseKeyStartDate] ? [NSDate new] : [self getDateFromRFC3339DateTimeString:[theClass objectForKey:kResponseKeyStartDate]];
                             class.endDate = [self isNull:theClass keyValue:kResponseKeyEndDate] ? [NSDate new] : [self getDateFromRFC3339DateTimeString:[theClass objectForKey:kResponseKeyEndDate]];
                             class.allDay = [self isNull:theClass keyValue:kResponseKeyAllDay] ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:[[theClass objectForKey:kResponseKeyAllDay] boolValue]];
                             class.title = [self isNull:theClass keyValue:kResponseKeyTitle] ? @"" : [theClass objectForKey:kResponseKeyTitle];
                             class.color = [self isNull:theClass keyValue:kResponseKeyColor] ? @"" : [theClass objectForKey:kResponseKeyColor];
                             class.origColor = [self isNull:theClass keyValue:kResponseKeyOrigColor] ? @"" : [theClass objectForKey:kResponseKeyOrigColor];
                             class.reservationId = [self isNull:theClass keyValue:kResponseKeyReservation] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyReservation] intValue]];
                             class.instructorId = [self isNull:theClass keyValue:kResponseKeyInstructorId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyInstructorId] intValue]];
                             class.instructorName = [self isNull:theClass keyValue:kResponseKeyInstructorName] ? @"" : [theClass objectForKey:kResponseKeyInstructorName];
                             class.classId = [self isNull:theClass keyValue:kResponseKeyClassId] ? @"" : [theClass objectForKey:kResponseKeyClassId];
                             class.aId = [self isNull:theClass keyValue:kResponseKeyAttendanceId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyAttendanceId] intValue]];
                             class.day = [self isNull:theClass keyValue:kResponseKeyDay] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[theClass objectForKey:kResponseKeyDay] intValue]];
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
                                 reservation.reservationId = [self isNull:dict keyValue:kResponseKeyReservationId] ? [NSNumber numberWithInt:-1] :[NSNumber numberWithInt:[[dict objectForKey:kResponseKeyReservationId] intValue]];
                                 reservation.title = [self isNull:dict keyValue:kResponseKeyTitle] ? @"" : [dict objectForKey:kResponseKeyTitle];
                                 
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];

                                 reservation.when = [self isNull:dict keyValue:kResponseKeyReservationWhen] ? [NSDate new] : [df dateFromString:[dict objectForKey:kResponseKeyReservationWhen]];
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
                                 attendance.attendanceId = [self isNull:dict keyValue:kResponseKeyAttendanceId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kResponseKeyAttendanceId] intValue]];
                                 attendance.title = [self isNull:dict keyValue:kResponseKeyTitle] ? @"" : [dict objectForKey:kResponseKeyTitle];
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
                                 attendance.when = [self isNull:dict keyValue:kResponseKeyAttendanceWhen] ? [NSDate new] : [df dateFromString:[dict objectForKey:kResponseKeyAttendanceWhen]];
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
                         wodInfo.name = [self isNull:response keyValue:kResponseKeyWodName] ? @"" : [response objectForKey:kResponseKeyWodName];
                         wodInfo.canEdit = [self isNull:response keyValue:kResponseKeyWodCanEdit] ? NO : [[response objectForKey:kResponseKeyWodCanEdit] boolValue];
                         wodInfo.classId = [self isNull:response keyValue:kResponseKeyWodId] ? @"" : [response objectForKey:kResponseKeyWodId];
                         wodInfo.results = [self isNull:response keyValue:kResponseKeyWodResults] ? @"" : [response objectForKey:kResponseKeyWodResults];
                         wodInfo.startDate = [self isNull:response keyValue:kResponseKeyWodStart] ? [NSDate new] : [self getDateFromRFC3339DateTimeString:[response objectForKey:kResponseKeyWodStart]];
                         wodInfo.title = [self isNull:response keyValue:kResponseKeyWodTitle] ? @"" : [response objectForKey:kResponseKeyWodTitle];
                         wodInfo.wod = [self isNull:response keyValue:kResponseKeyWodWod] ? @"" : [response objectForKey:kResponseKeyWodWod];
                         wodInfo.wodId = [self isNull:response keyValue:kResponseKeyWodId] ? @"" : [response objectForKey:kResponseKeyWodWodId];
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
                         
                         NSDateFormatter *df = [[NSDateFormatter alloc] init];
                         [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                         for ( NSDictionary *dict in response ) {
                             WodInfo *wodInfo = [[WodInfo alloc] init];
                             wodInfo.name = [self isNull:dict keyValue:kResponseKeyWodName] ? @"" : [dict objectForKey:kResponseKeyWodName];
                             wodInfo.canEdit = [self isNull:dict keyValue:kResponseKeyWodCanEdit] ? NO : [[dict objectForKey:kResponseKeyWodCanEdit] boolValue];
                             wodInfo.classId = [self isNull:dict keyValue:kResponseKeyWodId] ? @"" : [dict objectForKey:kResponseKeyWodId];
                             wodInfo.results = [self isNull:dict keyValue:kResponseKeyWodResults] ? @"" : [dict objectForKey:kResponseKeyWodResults];
                             wodInfo.startDate = [self isNull:dict keyValue:kResponseKeyWodStart] ? [NSDate new] : [df dateFromString:[dict objectForKey:kResponseKeyWodStart]];
                             wodInfo.title = [self isNull:dict keyValue:kResponseKeyWodTitle] ? @"" : [dict objectForKey:kResponseKeyWodTitle];
                             wodInfo.wod = [self isNull:dict keyValue:kResponseKeyWodWod] ? @"" : [dict objectForKey:kResponseKeyWodWod];
                             wodInfo.wodId = [self isNull:dict keyValue:kResponseKeyWodId] ? @"" : [dict objectForKey:kResponseKeyWodWodId];
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
                                 NSRange range = [benchmark.type rangeOfString:@":"];
                                 if ( range.length > 0 ) {
                                     range = [benchmark.currentScore rangeOfString:@":"];
                                     if ( range.length <= 0 )
                                         benchmark.currentScore = [NSString stringWithFormat:@"%@:00", benchmark.currentScore];
                                     range = [benchmark.lastScore rangeOfString:@":"];
                                     if ( range.length <= 0 )
                                         benchmark.lastScore = [NSString stringWithFormat:@"%@:00", benchmark.lastScore];
                                 }
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
                             availableBenchmark.benchmarkId = [self isNull:dict keyValue:kParamBId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kParamBId] intValue]];
                             availableBenchmark.bdescription = [self isNull:dict keyValue:kParamBId] ? @"" : [dict objectForKey:kParamBDesc];
                             availableBenchmark.btype = [self isNull:dict keyValue:kParamBId] ? @"" : [dict objectForKey:kParamBType];
                             availableBenchmark.bformat = [self isNull:dict keyValue:kParamBId] ? @"" : [dict objectForKey:kParamBFormat];
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
                       type:(NSString*)type
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
                                 [history setBenchmarkDataId:[self isNull:dict keyValue:kParamId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kParamId] intValue]]];
                                 [history setDate:[self isNull:dict keyValue:kParamDate] ? [NSDate new] : [df dateFromString:[dict objectForKey:kParamDate]]];
                                 [history setValue:[self isNull:dict keyValue:kParamValue] ? @"" : [dict objectForKey:kParamValue]];
                                 NSRange range = [type rangeOfString:@":"];
                                 if ( range.length > 0 ) {
                                     range = [history.value rangeOfString:@":"];
                                     if ( range.length <= 0 )
                                         history.value = [NSString stringWithFormat:@"%@:00", history.value];
                                 }

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
                                 membership.memebershipId = [self isNull:dict keyValue:kParamMId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kParamMId] intValue]];
                                 membership.membershipName = [self isNull:dict keyValue:kParamMName] ? @"" : [dict objectForKey:kParamMName];
                                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                 [df setDateFormat:@"yyyy-MM-dd"];
                                 membership.startDate = [self isNull:dict keyValue:kParamMStartDate] ? [NSDate new] : [df dateFromString:[dict objectForKey:kParamMStartDate]];
                                 membership.endDate = [self isNull:dict keyValue:kParamMEndDate] ? [NSDate new] : [df dateFromString:[dict objectForKey:kParamMEndDate]];
                                 membership.renewal = [self isNull:dict keyValue:kParamMRenewal] ? @"" : [dict objectForKey:kParamMRenewal];
                                 membership.attended = [self isNull:dict keyValue:kParamMAttended] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kParamMAttended] intValue]];
                                 membership.attendedLimit = [self isNull:dict keyValue:kParamMAttendedLimit] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kParamMAttendedLimit] intValue]];
                                 membership.limit = [self isNull:dict keyValue:kParamMLimit] ? @"" : [dict objectForKey:kParamMLimit];
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
                 NSLog(@"Get Wall Post API %@", response);
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
                                 wall.wallId = [self isNull:dict keyValue:kResponseKeyWallId] ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:[[dict objectForKey:kResponseKeyWallId] intValue]];
                                 wall.msg = [self isNull:dict keyValue:kResponseKeyWallMessage] ? @"" : [dict objectForKey:kResponseKeyWallMessage];
                                 wall.name = [self isNull:dict keyValue:kResponseKeyWallUserName] ? @"" : [dict objectForKey:kResponseKeyWallUserName];
                                 wall.profilePic = [self isNull:dict keyValue:kResponseKeyWallUserPicture] ? @"" : [dict objectForKey:kResponseKeyWallUserPicture];
                                 wall.yours = [self isNull:dict keyValue:kResponseKeyWallYours] ? NO : [[dict objectForKey:kResponseKeyWallYours] boolValue];
                                 wall.flaggable = [self isNull:dict keyValue:kResponseKeyWallFlaggable] ? NO : [[dict objectForKey:kResponseKeyWallFlaggable] boolValue];
                                 wall.pic = [self isNull:dict keyValue:kResponseKeyWallPic] ? @"" : [dict objectForKey:kResponseKeyWallPic];
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