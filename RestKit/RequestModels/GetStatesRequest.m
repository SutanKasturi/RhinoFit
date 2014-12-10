//
//  GetStatesRequest.m
//  RhinoFit
//
//  Created by Admin on 12/9/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "GetStatesRequest.h"

@implementation GetStatesRequest

+ (RKObjectMapping*) getStatesRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"country"]];
    return mapping;
}

@end
