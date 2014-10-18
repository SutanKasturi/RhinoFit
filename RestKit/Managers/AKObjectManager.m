//
//  AKObjectManager.m
//  AKGithubClient
//
//  Created by Alex Kurkin on 12/26/13.
//  Copyright (c) 2013 Brilliant Consulting Inc. All rights reserved.
//

#import "AKObjectManager.h"
#import <RestKit/RestKit.h>
#import "Constants.h"
#import "RequestSuccess.h"
#import "RequestFail.h"
#import "LoginRequest.h"
#import "UserInfoRequest.h"
#import "ClassesRequest.h"
#import "MakeReservationRequest.h"
#import "ListReservationRequest.h"
#import "DeleteReservationRequest.h"
#import "GetAttendanceRequest.h"
#import "MakeAttendanceRequest.h"
#import "DeleteAttendanceRequest.h"

static AKObjectManager *sharedManager = nil;

@implementation AKObjectManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:kAppBaseUrl];

        sharedManager = [self managerWithBaseURL:url];
        sharedManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        
        sharedManager.managedObjectStore = managedObjectStore;
        
        NSError *error;
        BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
        if ( !success ) {
            RKLogError(@"Failed to create Application Data Directory at path '%@' : %@", RKApplicationDataDirectory(), error);
        }
        
//        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
//        RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelDebug);
        
        [managedObjectStore createPersistentStoreCoordinator];
        NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"RhinoFit.sqlite"];
        NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path
                                                                         fromSeedDatabaseAtPath:nil
                                                                              withConfiguration:nil
                                                                                        options:nil
                                                                                          error:&error];
        
        if ( !persistentStore ) {
            RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
        }
        
        // Create the managed object contexts
        [managedObjectStore createManagedObjectContexts];

        // Configure a managed object cache to ensure we do not create duplicate objects
        managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
        
        /*
         THIS CLASS IS MAIN POINT FOR CUSTOMIZATION:
         - setup HTTP headers that should exist on all HTTP Requests
         - override methods in this class to change default behavior for all HTTP Requests
         - define methods that should be available across all object managers
         */
        [sharedManager setupRequestDescriptors];
        [sharedManager setupResponseDescriptors];
        sharedManager.isStartedRequest = NO;
    });

    return sharedManager;
}

- (void) errorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) successMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) setupRequestDescriptors {
}

- (void) setupResponseDescriptors {
    [self setupRequestResponseDescriptors];
    [self setupUserResponseDescriptors];
//    [self setupClassResponseDescriptors];
//    [self setupReservationResponseDescriptors];
//    [self setupAttendanceResponseDescriptors];
}


#pragma mark - Request Mapping

- (void) setupRequestResponseDescriptors {
    // Request Fial
    RKResponseDescriptor *requestFailResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[RequestFail getRequestFailMapping]
                                                                                                        method:RKRequestMethodAny
                                                                                                   pathPattern:nil
                                                                                                       keyPath:nil
                                                                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self addResponseDescriptor:requestFailResponseDescriptors];
    
    
    // RequestSuccess
    RKResponseDescriptor *requestSuccessResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[RequestSuccess getRequestSuccessMapping]
                                                                                                           method:RKRequestMethodAny
                                                                                                      pathPattern:nil
                                                                                                          keyPath:nil
                                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self addResponseDescriptor:requestSuccessResponseDescriptors];
    
    // LoginRequest
    RKRequestDescriptor *loginRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[LoginRequest getLoginRequestMapping]
                                                                                                 objectClass:[LoginRequest class]
                                                                                                 rootKeyPath:nil
                                                                                                      method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:loginRequestResponseDescriptors];
    
    // UserInfoRequest
    RKRequestDescriptor *userInfoRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[UserInfoRequest getUserInfoRequestMapping]
                                                                                                 objectClass:[UserInfoRequest class]
                                                                                                 rootKeyPath:nil
                                                                                                      method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:userInfoRequestResponseDescriptors];
    
    // UserInfoRequest
    RKRequestDescriptor *classesRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[ClassesRequest getClassesRequestMapping]
                                                                                                    objectClass:[ClassesRequest class]
                                                                                                    rootKeyPath:nil
                                                                                                         method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:classesRequestResponseDescriptors];
    
    // MakeReservationResquest
    RKRequestDescriptor *makeReservationRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MakeReservationRequest getMakeReservationRequestMapping]
                                                                                                   objectClass:[MakeReservationRequest class]
                                                                                                   rootKeyPath:nil
                                                                                                        method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:makeReservationRequestResponseDescriptors];
    
    // ListReservationResquest
    RKRequestDescriptor *listReservationRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[ListReservationRequest getListReservationRequestMapping]
                                                                                                           objectClass:[ListReservationRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:listReservationRequestResponseDescriptors];
    
    // DeleteReservationResquest
    RKRequestDescriptor *deleteReservationRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[DeleteReservationRequest getDeleteReservationRequestMapping]
                                                                                                           objectClass:[DeleteReservationRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:deleteReservationRequestResponseDescriptors];
    
    // GetAttendanceResquest
    RKRequestDescriptor *getAttendanceRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetAttendanceRequest getGetAttendanceRequestMapping]
                                                                                                           objectClass:[GetAttendanceRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:getAttendanceRequestResponseDescriptors];
    
    // MakeAttendanceResquest
    RKRequestDescriptor *makeAttendanceRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MakeAttendanceRequest getMakeAttendanceRequestMapping]
                                                                                                           objectClass:[MakeAttendanceRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:makeAttendanceRequestResponseDescriptors];
    
    // DeleteAttendanceResquest
    RKRequestDescriptor *deleteAttendanceRequestResponseDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[DeleteAttendanceRequest getDeleteAttendanceRequestMapping]
                                                                                                           objectClass:[DeleteAttendanceRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:deleteAttendanceRequestResponseDescriptors];
}

#pragma mark - CoreData Mapping

// UserInfo
- (void) setupUserResponseDescriptors {
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:kCoreDataUserInfo inManagedObjectStore:self.managedObjectStore];
    NSDictionary *userMappingDictionary = @{
                                            @"u_first":@"userFirstName",
                                            @"u_last":@"userLastName",
                                            @"u_address1":@"userAddress1",
                                            @"u_address2":@"userAddress2",
                                            @"u_city":@"userCity",
                                            @"u_state":@"userState",
                                            @"u_zip":@"userZip",
                                            @"u_country":@"userCountry",
                                            @"u_phone1":@"userPhone1",
                                            @"u_phone2":@"userPhone2"};
    
    [userMapping addAttributeMappingsFromDictionary:userMappingDictionary];
    
    RKResponseDescriptor *userResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                 method:RKRequestMethodAny
                                                                                            pathPattern:nil
                                                                                                keyPath:nil
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self addResponseDescriptor:userResponseDescriptors];
}

// Class
//- (void) setupClassResponseDescriptors {
//    RKEntityMapping *classMapping = [RKEntityMapping mappingForEntityForName:kCoreDataClass inManagedObjectStore:self.managedObjectStore];
//    classMapping.identificationAttributes = @[@"classId"];
//    NSDictionary *classMappingDictionary = @{
//                                              @"start":@"stateDate",
//                                              @"end":@"endDate",
//                                              @"allDay":@"allDay",
//                                              @"title":@"title",
//                                              @"color":@"color",
//                                              @"origcolor":@"origColor",
//                                              @"reservation":@"reservation",
//                                              @"instructorid":@"instructorId",
//                                              @"instructorname":@"instructorName",
//                                              @"id":@"classId",
//                                              @"aid":@"aId",
//                                              @"day":@"day"};
//    
//    [classMapping addAttributeMappingsFromDictionary:classMappingDictionary];
//    
//    RKResponseDescriptor *classResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:classMapping
//                                                                                                   method:RKRequestMethodAny
//                                                                                              pathPattern:nil
//                                                                                                  keyPath:nil
//                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    [self addResponseDescriptor:classResponseDescriptors];
//}
//
//
//// Reservation
//- (void) setupReservationResponseDescriptors {
//    RKEntityMapping *reservationMapping = [RKEntityMapping mappingForEntityForName:kCoreDataReservation inManagedObjectStore:self.managedObjectStore];
//    reservationMapping.identificationAttributes = @[@"reservationId"];
//    NSDictionary *reservationMappingDictionary = @{
//                                              @"resid":@"reservationId",
//                                              @"title":@"title",
//                                              @"when":@"when"};
//    
//    [reservationMapping addAttributeMappingsFromDictionary:reservationMappingDictionary];
//    
//    RKResponseDescriptor *reservationResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:reservationMapping
//                                                                                                   method:RKRequestMethodAny
//                                                                                              pathPattern:nil
//                                                                                                  keyPath:nil
//                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    [self addResponseDescriptor:reservationResponseDescriptors];
//}
//
//// Attendance
//- (void) setupAttendanceResponseDescriptors {
//    RKEntityMapping *attendanceMapping = [RKEntityMapping mappingForEntityForName:kCoreDataAttendance inManagedObjectStore:self.managedObjectStore];
//    attendanceMapping.identificationAttributes = @[@"attendanceId"];
//    NSDictionary *attendanceMappingDictionary = @{
//                                                   @"resid":@"attendanceId",
//                                                   @"title":@"title",
//                                                   @"when":@"when"};
//    
//    [attendanceMapping addAttributeMappingsFromDictionary:attendanceMappingDictionary];
//    
//    RKResponseDescriptor *attendanceResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:attendanceMapping
//                                                                                                        method:RKRequestMethodAny
//                                                                                                   pathPattern:nil
//                                                                                                       keyPath:nil
//                                                                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    [self addResponseDescriptor:attendanceResponseDescriptors];
//}

@end