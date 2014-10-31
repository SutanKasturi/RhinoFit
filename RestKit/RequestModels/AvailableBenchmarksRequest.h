//
//  AvailableBenchmarksRequest.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface AvailableBenchmarksRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;

+ (RKObjectMapping*) getAvailableBenchmarksRequestMapping;

@end
