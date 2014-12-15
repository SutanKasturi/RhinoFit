//
//  MyBenchmark.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBenchmark : NSObject

@property (nonatomic, strong) NSNumber * benchmarkId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSDate * currentDate;
@property (nonatomic, strong) NSString * currentScore;
@property (nonatomic, strong) NSDate * lastDate;
@property (nonatomic, strong) NSString * lastScore;

@end
