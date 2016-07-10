//
//  UserManager.h
//  AKGithubClient
//
//  Created by Alex Kurkin on 12/26/13.
//  Copyright (c) 2013 Brilliant Consulting Inc. All rights reserved.
//

#import "AKObjectManager.h"
#import "UserInfo.h"
#import "BenchmarkHistory.h"

@interface NetworkManager : AKObjectManager

// User Manager
- (UserInfo*) getUser;
- (void) deleteUser;
- (NSString*) getToken;
- (BOOL) checkValidUser;

// Classes
- (NSArray*) getClasses:(NSDate*)date;


// Login
- (void) sendEmailLogin:(NSString*) email
               password:(NSString*) password
                success:(void (^)(BOOL isLoggedIn, BOOL isValidUser))success
                failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

// Eula
- (void) getCurrentEula:(NSString*) token
                success:(void (^)(NSString *eulaContent))success
                 failed:(void (^)(NSError *error))failed;

- (void) acceptEula: (NSString *)versionId
            success:(void (^)(BOOL isSuccess)) success
             failed:(void (^)(NSError *error))failure;

// Classes
- (void) getClassess:(NSString*)startDate
             endDate:(NSString *)endDate
             success:(void (^)(NSArray*result))success
             failure:(void (^)(NSString *error))failure;

- (void) listReservation:(void (^)(NSMutableArray *result))success
                 failure:(void (^)(NSString *error))failure;

- (void) makeReservation:(NSString*)classId
         reservationDate:(NSString*)reservationDate
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(NSString *error))failure;
- (void) deleteReservation:(NSString*)resId
                   success:(void (^)(BOOL isSuccess))success
                   failure:(void (^)(NSString *error))failure;

- (void) getAttendance:(NSString*)startDate
               endDate:(NSString *)endDate
               success:(void (^)(NSMutableArray *result))success
               failure:(void (^)(NSString *error))failure;

- (void) makeAttendance:(NSString*)classId
         attendanceDate:(NSString*)attendanceDate
                success:(void (^)(NSNumber *attendanceId))success
                failure:(void (^)(NSString *error))failure;

- (void) deleteAttendance:(NSString*)aId
                  success:(void (^)(BOOL isSuccess))success
                  failure:(void (^)(NSString *error))failure;

// Wods
- (void) getWodInfo:(NSString*)classId
          startDate:(NSDate*)startDate
            success:(void (^)(id results))success
            failure:(void (^)(NSString *error))failure;

- (void) trackWod:(NSString*)classId
        startDate:(NSDate*)startDate
              wod:(NSString*)wod
            title:(NSString*)title
          results:(NSString*)results
          success:(void (^)(id results))success
          failure:(void (^)(NSString *error))failure;

- (void) getMyWods:(NSString*)startDate
             endDate:(NSString *)endDate
             success:(void (^)(NSArray*result))success
             failure:(void (^)(NSString *error))failure;

// Benchmark
- (void) getMyBenchmarks:(void (^)(NSMutableArray*result))success
                 failure:(void (^)(NSString *error))failure;
- (void) addNewBenchmark:(NSString*)benchmarkId
                    date:(NSString*)date
                   value:(NSString*)value
                  dataId:(NSString*)dataId
                 success:(void (^)(NSNumber *benchmarkDataId))success
                 failure:(void (^)(NSString *error))failure;
- (void) getAvailableBenchmarks:(void (^)(NSMutableArray*result))success
                        failure:(void (^)(NSString *error))failure;

- (void) getMyBenchmarkData:(NSString*)benchmarkId
                       type:(NSString*)type
                    success:(void (^)(NSMutableArray*result))success
                    failure:(void (^)(NSString *error))failure;

- (void) deleteBenchmarkData:(NSString *)benchmarkId
                        date:(NSString*)date
                       value:(NSString*)value
                      dataId:(NSString*)dataId
                     success:(void (^)(BOOL isSuccess))success
                     failure:(void (^)(NSString *error))failure;


- (void) getMyMemberships:(void (^)(NSMutableArray*result))success
                        failure:(void (^)(NSString *error))failure;

// Walls
- (void) getWallPosts:(void (^)(NSMutableArray*result))success
              failure:(void (^)(NSString *error))failure;

- (void) addWallPostWithImage:(UIImage*)image
             message:(NSString*)message
             success:(void (^)(NSNumber*wallId))success
             failure:(void (^)(NSString *error))failure;
- (void) deleteWallPost:(NSNumber*)wallId
                success:(void (^)( BOOL isSuccess ))success
                failure:(void (^)(NSString *error))failure;
- (void) reportWallPost:(NSNumber*) wallId
                success:(void (^)( BOOL isSuccess ))success
                failure:(void (^)(NSString *error))failure;
// User Info
- (void) getUserInfo:(void (^)(id result))success
             failure:(void (^)(NSString *error))failure;
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
                failure:(void (^)(NSString *error))failure;
- (void) getCountries:(void (^)(id results))success
              failure:(void (^)(NSString *error))failure;
- (void) getStates:(NSString*)country
           success:(void (^)(id result))success
           failure:(void (^)(NSString *error))failure;

@end
