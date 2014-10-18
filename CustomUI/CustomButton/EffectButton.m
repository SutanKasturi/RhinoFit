//
//  EffectButton.m
//  FIX
//
//  Created by Admin on 9/11/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import "EffectButton.h"

@implementation EffectButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = self.layer;
    if ( self.selected || self.highlighted ) {
        layer.opacity = 0.7f;
    }
    else {
        layer.opacity = 1.0f;
    }
}

-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
