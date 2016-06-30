//
//  GetEulaRequest.m
//  RhinoFit
//
//  Created by S on 6/28/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import "GetEulaRequest.h"

@implementation GetEulaRequest

+ (RKObjectMapping*) getEulaRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token"]];
    return mapping;
}

@end
