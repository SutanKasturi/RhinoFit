//
//  Wall.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wall : NSObject

@property (nonatomic, strong) NSNumber *wallId;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, assign) BOOL yours;
@end
