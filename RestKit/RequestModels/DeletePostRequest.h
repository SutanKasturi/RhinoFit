//
//  DeletePostRequest.h
//  RhinoFit
//
//  Created by S on 6/30/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface DeletePostRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSNumber *wallid;

+ (RKObjectMapping*) deleteWallPostsRequestMapping;

@end
