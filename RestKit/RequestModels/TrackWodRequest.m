//
//  TrackWodRequest.m
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "TrackWodRequest.h"

@implementation TrackWodRequest

+ (RKObjectMapping*) trackWodRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"id", @"start", @"wod", @"title", @"results"]];
    return mapping;
}

@end
