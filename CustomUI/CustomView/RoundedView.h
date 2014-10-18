//
//  RoundedView.h
//  FIX
//
//  Created by Admin on 9/11/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedView : UIView

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, assign) BOOL isReverse;

@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, setter= hasClickEvent:) BOOL hasClickEvent;

- (void) draw;

@end
