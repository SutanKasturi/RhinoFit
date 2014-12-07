//
//  GetMyWodsRequest.m
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "GetMyWodsRequest.h"

@implementation GetMyWodsRequest

+ (RKObjectMapping*) getMyWodsRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"startdate", @"enddate"]];
    return mapping;
}

@end
