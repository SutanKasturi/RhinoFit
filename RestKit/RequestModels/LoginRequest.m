//
//  LoginRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

+ (RKObjectMapping*) getLoginRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"email", @"password"]];
    return mapping;
}

@end
