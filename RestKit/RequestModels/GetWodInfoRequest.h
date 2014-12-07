//
//  GetWodInfoRequest.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetWodInfoRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSDate *start;

+ (RKObjectMapping*) getWodInfoRequestMapping;

@end
