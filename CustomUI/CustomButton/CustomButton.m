//
//  CustomButton.m
//  2B1S
//
//  Created by Sutan on 9/11/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self draw];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
//        [self draw];
    }
    return self;
}

- (void) setButtonType:(NSInteger) type {
    NSString *buttonName = @"";
    switch (type) {
        case CustomButtonBlack:
            buttonName = @"black";
            break;
            
        case CustomButtonBlue:
            buttonName = @"blue";
            break;
            
        case CustomButtonGreen:
            buttonName = @"green";
            break;
            
        case CustomButtonGrey:
            buttonName = @"grey";
            break;
            
        case CustomButtonOrange:
            buttonName = @"orange";
            break;
            
        case CustomButtonTan:
            buttonName = @"tan";
            break;
            
        case CustomButtonWhite:
            buttonName = @"white";
            break;
            
        default:
            return;
            break;
    }
    UIImage *buttonImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@Button.png", buttonName]] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonHighlight.png", buttonName]] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}

@end
