//
//  DemoTextField.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "DemoTextField.h"

@interface DemoTextField() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation DemoTextField

@synthesize required;
@synthesize isEmailField;
@synthesize type;

@synthesize pickerArray;
@synthesize pickerArray2;
@synthesize picker1;
@synthesize picker2;

@synthesize datePicker;
@synthesize pickerView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBorderStyle:UITextBorderStyleNone];
    
    [self setFont: [UIFont systemFontOfSize:17]];
    [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _cornerRadius = 4.0f;
    _borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.layer.borderColor = [_borderColor CGColor];
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    required = YES;
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = [_borderColor CGColor];
}
- (void) setCornerRadius:(NSInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
- (void) setTextFieldType:(NSInteger)textFieldType {
    self.type = textFieldType;
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
    
//    CGFloat width = self.superview.frame.size.width - 40.0f;
//    CGRect rect = layer.frame;
//    rect.size.width = width;
//    layer.frame = rect;
}

//- (void) drawPlaceholderInRect:(CGRect)rect {
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//}

- (BOOL) validate
{
    self.layer.borderColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5].CGColor;
    
    if (required && [self.text isEqualToString:@""]){
        return NO;
    }
    else if (type == TEXT_FIELD_EMAIL){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            return NO;
        }
    }
    
    self.layer.borderColor = [_borderColor CGColor];
    
    return YES;
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(UITextField *) textField
{
    self.layer.borderColor = [_borderColor CGColor];
    if ( type == TEXT_FIELD_DATE ) {
        if ( datePicker == nil ) {
            datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            if ( ![self.text isEqualToString:@""] ) {
                NSUInteger count = 0, length = [self.text length];
                NSRange range = NSMakeRange(0, length);
                while( range.location != NSNotFound ) {
                    range = [self.text rangeOfString:@"," options:0 range:range];
                    if ( range.location != NSNotFound ) {
                        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                        count++;
                    }
                }
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                if ( count > 1 )
                    [df setDateFormat:@"EEE, LLLL d, yyyy"];
                else
                    [df setDateFormat:@"LLLL d, yyyy"];
                datePicker.date = [df dateFromString:self.text];
            }
            self.inputView = datePicker;
        }
    }
    else if ( type == TEXT_FIELD_DATETIME ) {
        if ( datePicker == nil ) {
            datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            if ( ![self.text isEqualToString:@""] ) {
                NSUInteger count = 0, length = [self.text length];
                NSRange range = NSMakeRange(0, length);
                while( range.location != NSNotFound ) {
                    range = [self.text rangeOfString:@"," options:0 range:range];
                    if ( range.location != NSNotFound ) {
                        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                        count++;
                    }
                }
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                if ( count > 1 )
                    [df setDateFormat:@"EEE, LLLL d, yyyy"];
                else
                    [df setDateFormat:@"LLLL d, yyyy"];
                datePicker.date = [df dateFromString:self.text];
            }
            self.inputView = datePicker;
        }
    }
    else if ( type == TEXT_FIELD_SEX ) {
        if ( pickerView == nil ) {
            pickerArray = [NSMutableArray arrayWithObjects:@"", @"Male", @"Female", nil];
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
            [pickerView setDataSource:self];
            [pickerView setDelegate:self];
            pickerView.showsSelectionIndicator = YES;
            self.inputView = pickerView;
        }
    }
    else if ( type == TEXT_FIELD_PICKER || type == TEXT_FIELD_MINUTEANDSECOND ) {
        if ( pickerView == nil ) {
            if ( type == TEXT_FIELD_MINUTEANDSECOND ) {
                pickerArray = [[NSMutableArray alloc] init];
                pickerArray2 = [[NSMutableArray alloc] init];
                for ( int i = 0; i < 60; i++ ) {
                    NSString *value = [NSString stringWithFormat:@"%d", i];
                    if ( i < 10 ) {
                        value = [NSString stringWithFormat:@"0%d", i];
                    }
                    [pickerArray addObject:value];
                    [pickerArray2 addObject:value];
                }
                picker1 = @"00";
                picker2 = @"00";
            }
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
            [pickerView setDataSource:self];
            [pickerView setDelegate:self];
            pickerView.showsSelectionIndicator = YES;
            self.inputView = pickerView;
            if ( type == TEXT_FIELD_PICKER ) {
                for ( int i = 0; i < [pickerArray count]; i++ ) {
                    NSString *value = pickerArray[i];
                    if ( [value isEqualToString:self.text] ) {
                        [pickerView selectRow:i inComponent:0 animated:YES];
                    }
                }
            }
            else {
                NSString *string = self.text;
                if ( [string isEqualToString:@""] ) {
                    string = @"00:00";
                }
                NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
                picker1 = [string substringToIndex:range.location];
                picker2 = [string substringFromIndex:range.location + 1];
                int minute = [picker1 intValue];
                int second = [picker2 intValue];
                for ( int i = (int)[pickerArray count]; i < minute + 300; i++ ) {
                    [pickerArray addObject:[NSString stringWithFormat:@"%d", i]];
                }
                [pickerView selectRow:minute inComponent:0 animated:YES];
                [pickerView selectRow:second inComponent:1 animated:YES];
            }
        }
    }
}

- (BOOL) isLengthOverWidth:(NSString*)dateString
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
    CGFloat textWidth = [dateString sizeWithAttributes:attributes].width + 40;
    if ( textWidth > self.frame.size.width )
        return YES;
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *) textField
{    
    [self validate];
}

#pragma mark - UIDatePicker Delegate

- (void) datePickerValueChanged:(id)sender {
    if ( self.dateFormat == nil || [self.dateFormat isEqualToString:@""] )
        [self setDate:datePicker.date];
    else {
        [self setDate:datePicker.date format:self.dateFormat];
    }
}


// Date Action
- (void) setDate:(NSDate *)date format:(NSString*)format{
    if ( datePicker == nil ) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.dateFormat = format;
    [df setDateFormat:format];
    NSString *dateString = [df stringFromDate:date];
    self.text = dateString;
    datePicker.date = date;
    [self.pickerdelegate didChangedDate:datePicker.date];
}
- (void) setDate:(NSDate *)date
{
    if ( datePicker == nil ) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, LLLL d, yyyy"];
    NSString *dateString = [df stringFromDate:date];
    if ( [self isLengthOverWidth:dateString] ) {
        [df setDateFormat:@"LLLL d, yyyy"];
        dateString = [df stringFromDate:date];
    }
    self.text = dateString;
    datePicker.date = date;
    [self.pickerdelegate didChangedDate:datePicker.date];
}

- (void) nextDate
{
    NSDateComponents *compoents = [[NSDateComponents alloc] init];
    [compoents setDay:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingComponents:compoents toDate:datePicker.date options:0];
    [self setDate:date];
}

- (void) prevDate
{
    NSDateComponents *compoents = [[NSDateComponents alloc] init];
    [compoents setDay:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingComponents:compoents toDate:datePicker.date options:0];
    [self setDate:date];
}

- (void) today
{
    NSDate *date = [NSDate new];
    [self setDate:date];
}

- (NSString *)getDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:datePicker.date];
}


#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ( type == TEXT_FIELD_MINUTEANDSECOND )
        return 2;
    else
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ( component == 0 )
        return [pickerArray count];
    else
        return [pickerArray2 count];
}

#pragma mark - UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ( component == 0 ) {
        int count = (int)[pickerArray count];
        if ( type == TEXT_FIELD_MINUTEANDSECOND && row + 300 >= count) {
            for ( int i = count; i < count + 60; i++ ) {
                [pickerArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
            [self.pickerView reloadComponent:0];
        }
        return [pickerArray objectAtIndex:row];
    }
    else
        return [pickerArray2 objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ( type != TEXT_FIELD_MINUTEANDSECOND ) {
        self.text = [pickerArray objectAtIndex:row];
        [self.pickerdelegate didSelectedPicker:(int)row];
    }
    else {
        if ( component == 0 ) {
            picker1 = [pickerArray objectAtIndex:row];
        }
        else {
            picker2 = [pickerArray2 objectAtIndex:row];
        }
        self.text = [NSString stringWithFormat:@"%@:%@", picker1, picker2];
    }
}

@end
