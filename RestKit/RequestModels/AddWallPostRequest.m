//
//  AddWallPostRequest.m
//  RhinoFit
//
//  Created by Admin on 12/6/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AddWallPostRequest.h"

@implementation AddWallPostRequest

+ (RKObjectMapping*) addWallPostRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"msg", @"file"]];
    return mapping;
}

@end
