//
//  GetEulaRequest.h
//  RhinoFit
//
//  Created by S on 6/28/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetEulaRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;

+ (RKObjectMapping*) getEulaRequestMapping;

@end
