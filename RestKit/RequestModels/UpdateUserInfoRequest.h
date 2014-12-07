//
//  UpdateUserInfoRequest.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUserInfoRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSData *file;
@property (nonatomic, strong) NSString *u_first;
@property (nonatomic, strong) NSString *u_last;
@property (nonatomic, strong) NSString *u_address1;
@property (nonatomic, strong) NSString *u_address2;
@property (nonatomic, strong) NSString *u_city;
@property (nonatomic, strong) NSString *u_state;
@property (nonatomic, strong) NSString *u_zip;
@property (nonatomic, strong) NSString *u_country;
@property (nonatomic, strong) NSString *u_phone1;
@property (nonatomic, strong) NSString *u_phone2;
@property (nonatomic, strong) NSString *u_username;

+ (RKObjectMapping*) updateUserInfoRequestMapping;
@end
