//
//  MyBenchmarkDataRequest.m
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyBenchmarkDataRequest.h"

@implementation MyBenchmarkDataRequest

+(RKObjectMapping *)getMyBenchmarkDataRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"id"]];
    return mapping;
}

@end
