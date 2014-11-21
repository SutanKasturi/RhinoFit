//
//  DeleteBenchmarkData.m
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "DeleteBenchmarkData.h"

@implementation DeleteBenchmarkData

+(RKObjectMapping *)getDeleteBenchmarkDataRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"id", @"date", @"value", @"dataid"]];
    return mapping;
}

@end
