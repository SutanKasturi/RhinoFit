//
//  ReportPost.h
//  RhinoFit
//
//  Created by S on 6/30/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ReportPost : NSObject
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSNumber *wallid;

+ (RKObjectMapping*) reportWallPostRequestMapping;
@end
