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
#import "UpdateUserInfoRequest.h"
#import "GetCountriesRequest.h"
#import "GetStatesRequest.h"

#import "ClassesRequest.h"
#import "MakeReservationRequest.h"
#import "ListReservationRequest.h"
#import "DeleteReservationRequest.h"
#import "GetAttendanceRequest.h"
#import "MakeAttendanceRequest.h"
#import "DeleteAttendanceRequest.h"

#import "GetWodInfoRequest.h"
#import "TrackWodRequest.h"
#import "GetMyWodsRequest.h"

#import "MyBenchmarksRequest.h"
#import "AddNewBenchmarkRequest.h"
#import "MyMembershipsRequest.h"
#import "AvailableBenchmarksRequest.h"
#import "MyBenchmarkDataRequest.h"
#import "DeleteBenchmarkData.h"
#import "GetWallPostsRequest.h"
#import "AddWallPostRequest.h"

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
        
//        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//        RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
//        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelTrace);
//        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelDebug);
//        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelInfo);
//        RKLogConfigureByName("RestKit/Netowrk", RKLogLevelCritical);
        
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
    // LoginRequest
    RKRequestDescriptor *loginRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[LoginRequest getLoginRequestMapping]
                                                                                                 objectClass:[LoginRequest class]
                                                                                                 rootKeyPath:nil
                                                                                                      method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:loginRequestDescriptors];
    
    // UserInfoRequest
    RKRequestDescriptor *userInfoRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[UserInfoRequest getUserInfoRequestMapping]
                                                                                                    objectClass:[UserInfoRequest class]
                                                                                                    rootKeyPath:nil
                                                                                                         method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:userInfoRequestDescriptors];
    
    RKRequestDescriptor *updateUserInfoRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[UpdateUserInfoRequest updateUserInfoRequestMapping]
                                                                                            objectClass:[UpdateUserInfoRequest class]
                                                                                            rootKeyPath:nil
                                                                                                 method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:updateUserInfoRequestDescriptors];
    
    // GetCountryRequest
    RKRequestDescriptor *getCountriesRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetCountriesRequest getCountriesRequestMapping]
                                                                                                  objectClass:[GetCountriesRequest class]
                                                                                                  rootKeyPath:nil
                                                                                                       method:RKRequestMethodPOST];
    [self addRequestDescriptor:getCountriesRequestDescriptors];
    
    // GetStatesRequest
    RKRequestDescriptor *getStatesRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetStatesRequest getStatesRequestMapping]
                                                                                                objectClass:[GetStatesRequest class]
                                                                                                rootKeyPath:nil
                                                                                                     method:RKRequestMethodPOST];
    [self addRequestDescriptor:getStatesRequestDescriptors];
    
    // ClassRequest
    RKRequestDescriptor *classesRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[ClassesRequest getClassesRequestMapping]
                                                                                                   objectClass:[ClassesRequest class]
                                                                                                   rootKeyPath:nil
                                                                                                        method:RKRequestMethodPOST];
    
    [self addRequestDescriptor:classesRequestDescriptors];
    
    // GetWodInfoRequest
    RKRequestDescriptor *getWodInfoRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetWodInfoRequest getWodInfoRequestMapping]
                                                                                           objectClass:[GetWodInfoRequest class]
                                                                                           rootKeyPath:nil
                                                                                                method:RKRequestMethodPOST];
    [self addRequestDescriptor:getWodInfoRequestDescriptors];
    
    // TrackWodRequest
    RKRequestDescriptor *trackWodRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[TrackWodRequest trackWodRequestMapping]
                                                                                              objectClass:[TrackWodRequest class]
                                                                                              rootKeyPath:nil
                                                                                                   method:RKRequestMethodPOST];
    [self addRequestDescriptor:trackWodRequestDescriptors];

    // GetMyWodsRequest
    RKRequestDescriptor *getMyWodsRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetMyWodsRequest getMyWodsRequestMapping]
                                                                                            objectClass:[GetMyWodsRequest class]
                                                                                            rootKeyPath:nil
                                                                                                 method:RKRequestMethodPOST];
    [self addRequestDescriptor:getMyWodsRequestDescriptors];

    // MakeReservationResquest
    RKRequestDescriptor *makeReservationRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MakeReservationRequest getMakeReservationRequestMapping]
                                                                                                           objectClass:[MakeReservationRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:makeReservationRequestDescriptors];
    
    // ListReservationResquest
    RKRequestDescriptor *listReservationRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[ListReservationRequest getListReservationRequestMapping]
                                                                                                           objectClass:[ListReservationRequest class]
                                                                                                           rootKeyPath:nil
                                                                                                                method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:listReservationRequestDescriptors];
    
    // DeleteReservationResquest
    RKRequestDescriptor *deleteReservationRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[DeleteReservationRequest getDeleteReservationRequestMapping]
                                                                                                             objectClass:[DeleteReservationRequest class]
                                                                                                             rootKeyPath:nil
                                                                                                                  method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:deleteReservationRequestDescriptors];
    
    // GetAttendanceResquest
    RKRequestDescriptor *getAttendanceRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetAttendanceRequest getGetAttendanceRequestMapping]
                                                                                                         objectClass:[GetAttendanceRequest class]
                                                                                                         rootKeyPath:nil
                                                                                                              method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:getAttendanceRequestDescriptors];
    
    // MakeAttendanceResquest
    RKRequestDescriptor *makeAttendanceRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MakeAttendanceRequest getMakeAttendanceRequestMapping]
                                                                                                          objectClass:[MakeAttendanceRequest class]
                                                                                                          rootKeyPath:nil
                                                                                                               method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:makeAttendanceRequestDescriptors];
    
    // DeleteAttendanceResquest
    RKRequestDescriptor *deleteAttendanceRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[DeleteAttendanceRequest getDeleteAttendanceRequestMapping]
                                                                                                            objectClass:[DeleteAttendanceRequest class]
                                                                                                            rootKeyPath:nil
                                                                                                                 method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:deleteAttendanceRequestDescriptors];
    
    // MyBenchmarksResquest
    RKRequestDescriptor *myBenchmarksRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MyBenchmarksRequest getMyBenchmarksRequestMapping]
                                                                                                        objectClass:[MyBenchmarksRequest class]
                                                                                                        rootKeyPath:nil
                                                                                                             method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:myBenchmarksRequestDescriptors];
    
    // AddNewBenchmarksResquest
    RKRequestDescriptor *addNewBenchmarksRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[AddNewBenchmarkRequest getAddNewBenchmarkRequestMapping]
                                                                                                            objectClass:[AddNewBenchmarkRequest class]
                                                                                                            rootKeyPath:nil
                                                                                                                 method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:addNewBenchmarksRequestDescriptors];
    
    // MyBenchmarkDataRequest
    RKRequestDescriptor *myBenchmarkDataRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MyBenchmarkDataRequest getMyBenchmarkDataRequestMapping]
                                                                                                    objectClass:[MyBenchmarkDataRequest class]
                                                                                                    rootKeyPath:nil
                                                                                                         method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:myBenchmarkDataRequestDescriptors];
    
    // DeleteBenchmarkDataRequest
    RKRequestDescriptor *deleteBenchmarkDataRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[DeleteBenchmarkData getDeleteBenchmarkDataRequestMapping]
                                                                                                   objectClass:[DeleteBenchmarkData class]
                                                                                                   rootKeyPath:nil
                                                                                                        method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:deleteBenchmarkDataRequestDescriptors];
    
    // MyMembershipsResquest
    RKRequestDescriptor *myMembershipsRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[MyMembershipsRequest getMyMembershipsRequestMapping]
                                                                                                         objectClass:[MyMembershipsRequest class]
                                                                                                         rootKeyPath:nil
                                                                                                              method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:myMembershipsRequestDescriptors];
    
    // AvailableBenchmarksRequest
    RKRequestDescriptor *availableBenchmarksRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[AvailableBenchmarksRequest getAvailableBenchmarksRequestMapping]
                                                                                                               objectClass:[AvailableBenchmarksRequest class]
                                                                                                               rootKeyPath:nil
                                                                                                                    method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:availableBenchmarksRequestDescriptors];
    
    // Walls
    RKRequestDescriptor *getWallPostRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[GetWallPostsRequest getWallPostsRequestMapping]
                                                                                                       objectClass:[GetWallPostsRequest class]
                                                                                                       rootKeyPath:nil
                                                                                                            method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:getWallPostRequestDescriptors];
    
    RKRequestDescriptor *addWallPostRequestDescriptors = [RKRequestDescriptor requestDescriptorWithMapping:[AddWallPostRequest addWallPostRequestMapping]
                                                                                               objectClass:[AddWallPostRequest class]
                                                                                               rootKeyPath:nil
                                                                                                    method:RKRequestMethodPOST];
    
    
    [self addRequestDescriptor:addWallPostRequestDescriptors];
}

- (void) setupResponseDescriptors {
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
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[NSArray class]];
    [userMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@""]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:responseDescriptor];
}

@end