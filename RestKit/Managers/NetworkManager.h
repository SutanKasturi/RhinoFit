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

// Classes
- (NSArray*) getClasses:(NSDate*)date;


- (void) sendEmailLogin:(NSString*) email
               password:(NSString*) password
                success:(void (^)(BOOL isLoggedIn))success
                failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) getUserInfo:(void (^)(id result))success
             failure:(void (^)(NSString *error))failure;

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

@end
