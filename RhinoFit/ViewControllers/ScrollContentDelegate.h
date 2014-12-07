//
//  ScrollContentDelegate.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScrollContentDelegate <NSObject>

@optional
- (void) didChangeScrollContent:(CGFloat)height;

@end
