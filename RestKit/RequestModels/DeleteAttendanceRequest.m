//
//  DeleteAttendanceRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "DeleteAttendanceRequest.h"

@implementation DeleteAttendanceRequest

+ (RKObjectMapping*) getDeleteAttendanceRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"aid"]];
    return mapping;
}

@end
