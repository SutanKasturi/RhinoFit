//
//  TrackWodRequest.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackWodRequest : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSString *wod;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *results;

+ (RKObjectMapping*) trackWodRequestMapping;

@end
