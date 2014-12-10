//
//  GetCountriesRequest.h
//  RhinoFit
//
//  Created by Admin on 12/9/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCountriesRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;

+ (RKObjectMapping*) getCountriesRequestMapping;

@end
