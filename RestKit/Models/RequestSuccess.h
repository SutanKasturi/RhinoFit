//
//  RequestSuccess.h
//  2B1S
//
//  Created by Sutan on 9/25/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RequestSuccess : NSObject

@property (nonatomic, strong) NSString *successMessage;

+ (RKObjectMapping*) getRequestSuccessMapping;

@end
