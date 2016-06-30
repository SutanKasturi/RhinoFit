//
//  ReportPost.m
//  RhinoFit
//
//  Created by S on 6/30/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import "ReportPost.h"

@implementation ReportPost
+(RKObjectMapping*) reportWallPostRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"action", @"token", @"wallid"]];
    return mapping;
}

@end
