//
//  MyMembership.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMembership : NSObject

@property (nonatomic, assign) NSNumber *memebershipId;
@property (nonatomic, strong) NSString *membershipName;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *renewal;
@property (nonatomic, assign) NSNumber *attended;
@property (nonatomic, assign) NSNumber *attendedLimit;
@property (nonatomic, strong) NSString *limit;

@end
