//
//  BenchmarkHistory.h
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BenchmarkHistory : NSObject

@property (nonatomic, strong) NSNumber *benchmarkDataId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *value;

- (NSComparisonResult)compare:(BenchmarkHistory*)otherObject;

@end
