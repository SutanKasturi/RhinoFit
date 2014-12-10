//
//  GetCountriesRequest.m
//  RhinoFit
//
//  Created by Admin on 12/9/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "GetCountriesRequest.h"

@implementation GetCountriesRequest

+ (RKObjectMapping*) getCountriesRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token"]];
    return mapping;
}

@end
