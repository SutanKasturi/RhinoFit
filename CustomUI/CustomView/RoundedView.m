//
//  RoundedView.m
//  FIX
//
//  Created by Admin on 9/11/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import "RoundedView.h"

@implementation RoundedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cornerRadius = 0.0f;//self.frame.size.height / 2.0f;
        _borderWidth = -1.0f;
        _isPressed = NO;
        _hasClickEvent = NO;
        _isReverse = NO;
        [self draw];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        _borderWidth = -1.0f;
        _cornerRadius = 0.0f;//self.frame.size.height / 2.0f;
        _isPressed = NO;
        _hasClickEvent = NO;
        _isReverse = NO;
        [self draw];
    }
    return self;
}

- (void) setBorderWidth:(float)borderWidth {
    _borderWidth = borderWidth;
    [self draw];
}

- (void) setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    [self draw];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self draw];
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self draw];
}

- (void)touchEffect
{
    CALayer *layer = self.layer;
    if ( _isPressed == YES ) {
        if ( _isReverse == YES )
            layer.opacity = 1.0f;
        else
            layer.opacity = 0.5f;
    }
    else {
        if ( _isReverse == YES )
            layer.opacity = 0.8f;
        else
            layer.opacity = 1.0f;
    }
}

- (void) setIsReverse:(BOOL)isReverse {
    _isReverse = isReverse;
    if ( isReverse == YES ) {
        CALayer *layer = self.layer;
        layer.opacity = 0.5f;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( _hasClickEvent == NO )
        return;
    _isPressed = YES;
    [super touchesBegan:touches withEvent:event];
    [self touchEffect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( _hasClickEvent == NO )
        return;
    _isPressed = NO;
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self touchEffect];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( _hasClickEvent == NO )
        return;
    _isPressed = NO;
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self touchEffect];
}

- (void) draw {
//    CGRect frame = self.frame;
//    
//    if ( frame.size.width != frame.size.height ) {
//        NSLog(@"Warning: Height and Width should be the same for view");
//    }
    
    CALayer *layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_cornerRadius];
    if ( _backgroundColor == nil ) {
        [layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    } else {
        [layer setBackgroundColor:[_backgroundColor CGColor]];
    }
    
    if ( _borderWidth < 0 ) {
        [layer setBorderWidth:1.0f];
    }
    else {
        [layer setBorderWidth:_borderWidth];
    }
    
    if ( _borderColor == nil ) {
        [layer setBorderColor:[[UIColor blackColor] CGColor]];
    } else {
        [layer setBorderColor:[_borderColor CGColor]];
    }
}
@end
