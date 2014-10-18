//
//  ClassesRequest.h
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ClassesRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *startdate;
@property (nonatomic, strong) NSString *enddate;

+ (RKObjectMapping*) getClassesRequestMapping;

@end
