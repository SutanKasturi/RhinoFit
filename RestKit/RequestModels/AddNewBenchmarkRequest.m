//
//  AddNewBenchmarkRequest.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AddNewBenchmarkRequest.h"

@implementation AddNewBenchmarkRequest

+(RKObjectMapping *)getAddNewBenchmarkRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"id", @"date", @"value"]];
    return mapping;
}

@end
