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
#import "ClassesRequest.h"
#import "RhinoFitClass.h"
#import "MakeReservationRequest.h"
#import "ListReservationRequest.h"
#import "DeleteReservationRequest.h"
#import "GetAttendanceRequest.h"
#import "MakeAttendanceRequest.h"
#import "DeleteAttendanceRequest.h"
#import "Reservation.h"
#import "Attendance.h"

@implementation NetworkManager

#pragma mark - User Manager

static UserInfo* currentUser;

// UserInfo
- (UserInfo*) getUser
{
    if ( currentUser )
        return currentUser;
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    NSArray *result = [cdHandler getAllDataForEntity:kCoreDataUserInfo];
    for ( UserInfo *user in result ) {
        currentUser = user;
        return currentUser;
    }
    
    return nil;
}

- (void) deleteUser
{
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    [sharedInstance removeObjectForKey:kParamToken];
    
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    [cdHandler deleteAllDataForEntity:kCoreDataUserInfo];
//    [cdHandler deleteAllDataForEntity:kCoreDataClass];
//    [cdHandler deleteAllDataForEntity:kCoreDataReservation];
//    [cdHandler deleteAllDataForEntity:kCoreDataAttendance];
    currentUser = nil;
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

// Classes
- (NSArray*) getClasses:(NSDate*)date
{
    CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
    return [cdHandler getAllDataForEntity:kCoreDataClass];
//    return [cdHandler getEntityDataByDate:kCoreDataClass dateField:@" dateValue:<#(NSDate *)#>:kCoreDataClass idField: idValue:<#(NSNumber *)#>]
}

- (void)sendEmailLogin:(NSString *)email
              password:(NSString *)password
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
                     [self.delegate failureRequest:kRequestLogin errorMessage:error.localizedDescription];
                     [self errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response objectForKey:@"token"] ){
                         NSString *token = [response objectForKey:@"token"];
                         NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
                         [sharedInstance setObject:token forKey:kParamToken];
                         [self.delegate successRequest:kRequestLogin result:token];
                     }
                     else {
                         NSString *error = [response objectForKey:@"error"];
                         [self.delegate failureRequest:kRequestLogin errorMessage:error];
                         [self errorMessage:error];
                     }
                 }             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestLogin errorMessage:[error localizedDescription]];
             }];
}

- (void) getUserInfo
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
                     [self.delegate failureRequest:kRequestGetUserInfo errorMessage:error.localizedDescription];
                     [self errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         [self.delegate failureRequest:kRequestGetUserInfo errorMessage:error];
                         [self errorMessage:error];
                     }
                     else {
                         CoreDataHandler *cdHandler = [[CoreDataHandler alloc] init];
                         NSDictionary *userInfo = @{
                                                    @"userFirstName":[response objectForKey:kResponseKeyUserFirstName],
                                                    @"userLastName":[response objectForKey:kResponseKeyUserLastName],
                                                    @"userAddress1":[response objectForKey:kResponseKeyUserAddress1],
                                                    @"userAddress2":[response objectForKey:kResponseKeyUserAddress2],
                                                    @"userCity":[response objectForKey:kResponseKeyUserCity],
                                                    @"userCountry":[response objectForKey:kResponseKeyUserCountry],
                                                    @"userPhone1":[response objectForKey:kResponseKeyUserPhone1],
                                                    @"userPhone2":[response objectForKey:kResponseKeyUserPhone2],
                                                    @"userState":[response objectForKey:kResponseKeyUserState],
                                                    @"userZip":[response objectForKey:kResponseKeyUserZip]
                                                    };
                         [cdHandler insertNewRecord:kCoreDataUserInfo fields:userInfo];
                         [self.delegate successRequest:kRequestGetUserInfo result:userInfo];
                     }
                 }             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestGetUserInfo errorMessage:[error localizedDescription]];
             }];
}

- (void) getClassess:(NSString*)startDate endDate:(NSString *)endDate
{
    ClassesRequest *dataObject = [ClassesRequest new];
    [dataObject setAction:kRequestGetClassess];
    [dataObject setToken:[self getToken]];
    [dataObject setStartdate:startDate];
    [dataObject setEnddate:endDate];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);

    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestGetClassess errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestGetClassess errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( ![response isKindOfClass:[NSArray class]] && [response objectForKey:@"error"] ){
                         NSString *error = [response objectForKey:@"error"];
                         [self.delegate failureRequest:kRequestGetClassess errorMessage:error];
                     }
                     else {
                         NSMutableArray *result = [[NSMutableArray alloc] init];
                         for ( NSDictionary *theClass in response ) {
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                             RhinoFitClass *class = [[RhinoFitClass alloc] init];
                             NSString *startDateString = [[[theClass objectForKey:kResponseKeyStartDate] substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                             NSString *endDateString = [[[theClass objectForKey:kResponseKeyEndDate] substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                             class.startDate = [df dateFromString:startDateString];
                             class.endDate = [df dateFromString:endDateString];
                             class.allDay = [NSNumber numberWithBool:[theClass objectForKey:kResponseKeyAllDay]];
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
                         [self.delegate successRequest:kRequestGetClassess result:result];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 if ( operation.HTTPRequestOperation.response.statusCode == RKStatusCodeClassSuccessful )
                     [self.delegate successRequest:kRequestGetClassess result:nil];
                 else
                     [self.delegate failureRequest:kRequestGetClassess errorMessage:error.localizedDescription];
             }];
}

- (void) makeReservation:(NSString*)classId reservationDate:(NSString*)reservationDate
{
    MakeReservationRequest *dataObject = [[MakeReservationRequest alloc] init];
    [dataObject setAction:kRequestMakeReservation];
    [dataObject setToken:[self getToken]];
    [dataObject setClasstimeid:classId];
    [dataObject setDate:reservationDate];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestMakeReservation errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestMakeReservation errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             [self.delegate failureRequest:kRequestMakeReservation errorMessage:error];
                         }
                         else {
                             NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:response];
                             [result setValue:kRequestMakeReservation forKey:kParamAction];
                             [result setValue:classId forKey:kResponseKeyClassId];
                             [self.delegate successRequest:kRequestMakeReservation result:result];
                         }
                     }
                     else {
                         [self.delegate failureRequest:kRequestMakeReservation errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestMakeReservation errorMessage:error.localizedDescription];
             }];
}

- (void) listReservation
{
    ListReservationRequest *dataObject = [[ListReservationRequest alloc] init];
    [dataObject setAction:kRequestListReservations];
    [dataObject setToken:[self getToken]];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestListReservations errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestListReservations errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         [self.delegate failureRequest:kRequestListReservations errorMessage:error];
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
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
                         [self.delegate successRequest:kRequestListReservations result:result];
                     }
                     else {
                         [self.delegate failureRequest:kRequestListReservations errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestListReservations errorMessage:error.localizedDescription];
             }];
}
- (void) deleteReservation:(NSString*)resId
{
    DeleteReservationRequest *dataObject = [[DeleteReservationRequest alloc] init];
    [dataObject setAction:kRequestDeleteReservation];
    [dataObject setToken:[self getToken]];
    [dataObject setResid:resId];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestDeleteReservation errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestDeleteReservation errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             [self.delegate failureRequest:kRequestDeleteReservation errorMessage:error];
                         }
                         else if ( [[response objectForKey:kResponseKeyResult] intValue] == 1 ){
                             NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                             [result setValue:kRequestDeleteReservation forKey:kParamAction];
                             [result setValue:resId forKey:kResponseKeyReservationId];
                             [self.delegate successRequest:kRequestDeleteReservation result:result];
                         }
                         else
                         {
                             [self.delegate failureRequest:kRequestDeleteReservation errorMessage:kMessageUnkownError];
                         }
                     }
                     else {
                         [self.delegate failureRequest:kRequestDeleteReservation errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestDeleteReservation errorMessage:error.localizedDescription];
             }];
}
- (void) getAttendance:(NSString*)startDate endDate:(NSString *)endDate
{
    GetAttendanceRequest *dataObject = [[GetAttendanceRequest alloc] init];
    [dataObject setAction:kRequestGetAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setStartdate:startDate];
    [dataObject setEnddate:endDate];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestGetAttendance errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestGetAttendance errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"] ) {
                         NSString *error = [response objectForKey:@"error"];
                         [self.delegate failureRequest:kRequestGetAttendance errorMessage:error];
                     }
                     else if ( [response isKindOfClass:[NSArray class]] ){
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
                         [self.delegate successRequest:kRequestGetAttendance result:result];
                     }
                     else {
                         [self.delegate failureRequest:kRequestGetAttendance errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestGetAttendance errorMessage:error.localizedDescription];
             }];
}
- (void) makeAttendance:(NSString*)classId attendanceDate:(NSString*)attendanceDate
{
    MakeAttendanceRequest *dataObject = [[MakeAttendanceRequest alloc] init];
    [dataObject setAction:kRequestMakeAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setClasstimeid:classId];
    [dataObject setDate:attendanceDate];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestMakeAttendance errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestMakeAttendance errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             [self.delegate failureRequest:kRequestMakeAttendance errorMessage:error];
                         }
                         else {
                             NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:response];
                             [result setValue:kRequestMakeAttendance forKey:kParamAction];
                             [result setValue:classId forKey:kResponseKeyClassId];
                             [self.delegate successRequest:kRequestMakeAttendance result:result];
                         }
                     }
                     else {
                         [self.delegate failureRequest:kRequestMakeAttendance errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestMakeAttendance errorMessage:error.localizedDescription];
             }];
}
- (void) deleteAttendance:(NSString*)aId
{
    DeleteAttendanceRequest *dataObject = [[DeleteAttendanceRequest alloc] init];
    [dataObject setAction:kRequestDeleteAttendance];
    [dataObject setToken:[self getToken]];
    [dataObject setAid:aId];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    [self postObject:dataObject
                path:@"api.php"
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if ( operation.HTTPRequestOperation.response.statusCode != 200 ) {
                     [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:operation.HTTPRequestOperation.responseString];
                     return;
                 }
                 NSError *error;
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:&error];
                 if ( error || response == nil ) {
                     [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:error.localizedDescription];
                 }
                 else {
                     if ( [response isKindOfClass:[NSDictionary class]] ){
                         if ( [response objectForKey:@"error"] ) {
                             NSString *error = [response objectForKey:@"error"];
                             [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:error];
                         }
                         else if ( [[response objectForKey:kResponseKeyResult] intValue] == 1 ){
                             NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                             [result setValue:kRequestDeleteAttendance forKey:kParamAction];
                             [result setValue:aId forKey:kResponseKeyAttendanceId];
                             [self.delegate successRequest:kRequestDeleteAttendance result:result];
                         }
                         else
                         {
                             [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:kMessageUnkownError];
                         }
                     }
                     else {
                         [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:kMessageUnkownError];
                     }
                 }
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 NSLog(@"Error : %@", error.description);
                 [self.delegate failureRequest:kRequestDeleteAttendance errorMessage:error.localizedDescription];
             }];
}

@end