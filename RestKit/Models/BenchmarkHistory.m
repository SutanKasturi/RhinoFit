//
//  BenchmarkHistory.m
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "BenchmarkHistory.h"

@implementation BenchmarkHistory

- (NSComparisonResult)compare:(BenchmarkHistory*)otherObject {
    return [otherObject.benchmarkDataId compare:self.benchmarkDataId];
}

@end
