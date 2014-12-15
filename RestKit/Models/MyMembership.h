//
//  MyMembership.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMembership : NSObject

@property (nonatomic, strong) NSNumber *memebershipId;
@property (nonatomic, strong) NSString *membershipName;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *renewal;
@property (nonatomic, strong) NSNumber *attended;
@property (nonatomic, strong) NSNumber *attendedLimit;
@property (nonatomic, strong) NSString *limit;

@end
