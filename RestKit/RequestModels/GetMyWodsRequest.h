//
//  GetMyWodsRequest.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMyWodsRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *startdate;
@property (nonatomic, strong) NSString *enddate;

+ (RKObjectMapping*) getMyWodsRequestMapping;

@end
