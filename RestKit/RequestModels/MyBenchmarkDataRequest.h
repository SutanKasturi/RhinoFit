//
//  MyBenchmarkDataRequest.h
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBenchmarkDataRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *id;

+ (RKObjectMapping*) getMyBenchmarkDataRequestMapping;

@end
