//
//  UserInfoRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "UserInfoRequest.h"

@implementation UserInfoRequest

+ (RKObjectMapping*) getUserInfoRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token"]];
    return mapping;
}

@end
