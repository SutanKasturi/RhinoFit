//
//  AKObjectManager.h
//  AKGithubClient
//
//  Created by Alex Kurkin on 12/26/13.
//  Copyright (c) 2013 Brilliant Consulting Inc. All rights reserved.
//

#import "RKObjectManager.h"

@interface AKObjectManager : RKObjectManager

+ (instancetype) sharedManager;

@property(nonatomic, assign) BOOL isStartedRequest;

- (void) setupRequestDescriptors;
- (void) setupResponseDescriptors;
- (void) errorMessage:(NSString*)message;
- (void) successMessage:(NSString *)message;

@end
