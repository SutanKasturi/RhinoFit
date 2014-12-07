//
//  GetWallPostsRequest.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "GetWallPostsRequest.h"

@implementation GetWallPostsRequest

+ (RKObjectMapping*) getWallPostsRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token"]];
    return mapping;
}

@end
