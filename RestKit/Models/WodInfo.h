//
//  WodInfo.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WodInfo : NSObject

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *wod;
@property (nonatomic, strong) NSString *wodId;
@property (nonatomic, strong) NSString *results;

@end
