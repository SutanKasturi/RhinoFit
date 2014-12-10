//
//  DemoTextField.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "DemoTextView.h"

@implementation DemoTextView

@synthesize required;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self setBackgroundColor:[UIColor whiteColor]];
    _borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.layer.borderColor = _borderColor.CGColor;
    self.delegate = self;
    required = YES;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: 0.8];
}

- (BOOL) validate
{
    self.layer.borderColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1].CGColor;
    
    if (required && [self.text isEqualToString:@""]){
        return NO;
    }
    
    self.layer.borderColor = _borderColor.CGColor;
    
    return YES;
}

#pragma mark - UITextField Delegate

- (void)textViewDidBeginEditing:(UITextView *) textView
{
	self.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f].CGColor;
}

- (void)textViewDidEndEditing:(UITextView *) textView
{
    [self validate];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
//- (void) drawPlaceholderInRect:(CGRect)rect {
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//}

@end
