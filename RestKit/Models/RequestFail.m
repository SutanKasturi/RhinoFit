//
//  RequestFail.m
//  2B1S
//
//  Created by Sutan on 9/25/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "RequestFail.h"

@implementation RequestFail

+ (RKObjectMapping*) getRequestFailMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RequestFail class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"error":@"errorMessage"
                                                  }];
    return mapping;
}


@end
