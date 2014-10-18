//
//  MakeReservationRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MakeReservationRequest.h"

@implementation MakeReservationRequest

+ (RKObjectMapping*) getMakeReservationRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"classtimeid", @"date"]];
    return mapping;
}

@end
