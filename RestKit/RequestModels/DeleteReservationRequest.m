//
//  DeleteReservationRequest.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "DeleteReservationRequest.h"

@implementation DeleteReservationRequest

+ (RKObjectMapping*) getDeleteReservationRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"resid"]];
    return mapping;
}

@end
