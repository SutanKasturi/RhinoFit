//
//  GetStatesRequest.h
//  RhinoFit
//
//  Created by Admin on 12/9/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetStatesRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *country;

+ (RKObjectMapping*) getStatesRequestMapping;

@end
