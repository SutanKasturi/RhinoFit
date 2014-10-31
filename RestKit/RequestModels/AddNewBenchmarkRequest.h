//
//  AddNewBenchmarkRequest.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface AddNewBenchmarkRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *value;

+ (RKObjectMapping*) getAddNewBenchmarkRequestMapping;

@end
