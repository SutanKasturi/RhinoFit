//
//  GetWodInfoRequest.m
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "GetWodInfoRequest.h"

@implementation GetWodInfoRequest

+ (RKObjectMapping*) getWodInfoRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"id", @"start"]];
    return mapping;
}

@end
