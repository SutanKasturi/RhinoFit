//
//  AddWallPostRequest.h
//  RhinoFit
//
//  Created by Admin on 12/6/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddWallPostRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSData *file;

+ (RKObjectMapping*) addWallPostRequestMapping;

@end
