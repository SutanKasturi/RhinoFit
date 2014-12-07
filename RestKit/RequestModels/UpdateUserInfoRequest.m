//
//  UpdateUserInfoRequest.m
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "UpdateUserInfoRequest.h"

@implementation UpdateUserInfoRequest

+ (RKObjectMapping*) updateUserInfoRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"u_first", @"u_last", @"u_address1", @"u_address2", @"u_city", @"u_state", @"u_zip", @"u_country", @"u_phone1", @"u_phone2", @"file", @"u_username"]];
    return mapping;
}

@end
