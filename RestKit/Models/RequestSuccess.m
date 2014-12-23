//
//  RequestSuccess.m
//  2B1S
//
//  Created by Sutan on 9/25/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "RequestSuccess.h"

@implementation RequestSuccess

+ (RKObjectMapping*) getRequestSuccessMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RequestSuccess class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"success":@"successMessage"
                                                  }];
    return mapping;
}

@end
