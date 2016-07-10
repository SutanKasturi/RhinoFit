//
//  AcceptEulaRequest.m
//  RhinoFit
//
//  Created by S on 6/28/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import "AcceptEulaRequest.h"

@implementation AcceptEulaRequest
+ (RKObjectMapping*) getAcceptEulaRequestMapping
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"versionid"]];
    return mapping;
}
@end
