//
//  ClassesRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ClassesRequest.h"

@implementation ClassesRequest

+ (RKObjectMapping*) getClassesRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"startdate", @"enddate"]];
    return mapping;
}

@end
