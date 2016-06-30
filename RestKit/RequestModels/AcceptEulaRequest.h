//
//  AcceptEulaRequest.h
//  RhinoFit
//
//  Created by S on 6/28/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceptEulaRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *versionId;

+ (RKObjectMapping*) getAcceptEulaRequestMapping;

@end
