//
//  MyMembershipsRequest.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyMembershipsRequest.h"

@implementation MyMembershipsRequest

+ (RKObjectMapping *)getMyMembershipsRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token"]];
    return mapping;
}

@end
