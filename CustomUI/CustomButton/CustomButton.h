//
//  CustomButton.h
//  2B1S
//
//  Created by Cui on 9/11/14.
//  Copyright (c) 2014 Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CustomButtonBlack,
    CustomButtonBlue,
    CustomButtonGreen,
    CustomButtonGrey,
    CustomButtonOrange,
    CustomButtonTan,
    CustomButtonWhite
    
} CustomButtonType;

@interface CustomButton : UIButton

@property (nonatomic, assign) NSInteger customButtonType;

- (void) setButtonType:(NSInteger) type;

@end
