//
//  LoginRequest.h
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface LoginRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

+ (RKObjectMapping*) getLoginRequestMapping;

@end
