//
//  UserManager.h
//  AKGithubClient
//
//  Created by Alex Kurkin on 12/26/13.
//  Copyright (c) 2013 Brilliant Consulting Inc. All rights reserved.
//

#import "AKObjectManager.h"
#import "UserInfo.h"

@class NetworkManager;
@protocol NetworkManagerDelegate <NSObject>

@required
- (void) successRequest:(NSString*)action result:(id)obj;
- (void) failureRequest:(NSString*)action errorMessage:(NSString*)errorMessage;

@end

@interface NetworkManager : AKObjectManager

@property (weak, nonatomic) id<NetworkManagerDelegate> delegate;

// User Manager
- (UserInfo*) getUser;
- (void) deleteUser;
- (NSString*) getToken;

// Classes
- (NSArray*) getClasses:(NSDate*)date;


- (void) sendEmailLogin:(NSString*) email
               password:(NSString*) password;
- (void) getUserInfo:(void (^)(id result))success
             failure:(void (^)(NSString *error))failure;
- (void) getClassess:(NSString*)startDate
             endDate:(NSString *)endDate
             success:(void (^)(NSArray*result))success
             failure:(void (^)(NSString *error))failure;

- (void) makeReservation:(NSString*)classId reservationDate:(NSString*)reservationDate;
- (void) listReservation;
- (void) deleteReservation:(NSString*)resId;
- (void) getAttendance:(NSString*)startDate endDate:(NSString *)endDate;
- (void) makeAttendance:(NSString*)classId attendanceDate:(NSString*)attendanceDate;
- (void) deleteAttendance:(NSString*)aId;

- (void) getMyBenchmarks:(void (^)(NSMutableArray*result))success
                 failure:(void (^)(NSString *error))failure;
- (void) addNewBenchmark:(NSString*)benchmarkId
                    date:(NSString*)date
                   value:(NSString*)value
                 success:(void (^)(NSMutableDictionary*result))success
                 failure:(void (^)(NSString *error))failure;
- (void) getAvailableBenchmarks:(void (^)(NSMutableArray*result))success
                        failure:(void (^)(NSString *error))failure;

- (void) getMyMemberships:(void (^)(NSMutableArray*result))success
                        failure:(void (^)(NSString *error))failure;

@end
