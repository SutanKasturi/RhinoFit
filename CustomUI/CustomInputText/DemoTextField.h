//
//  DemoTextField.h
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TEXT_FIELD_NORMAL,
    TEXT_FIELD_EMAIL,
    TEXT_FIELD_DATE,
    TEXT_FIELD_DATETIME,
    TEXT_FIELD_SEX,
    TEXT_FIELD_PICKER
}TextFieldType;

@class DemoTextField;

@protocol DemoTextFieldDelegate <NSObject>

@optional
- (void) didChangedDate:(NSDate*)date;

@end

// Application specific customization.
@interface DemoTextField : UITextField

@property (weak, nonatomic) id<DemoTextFieldDelegate> datedelegate;

@property (nonatomic, setter = setRequired:) BOOL required;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) NSMutableArray *pickerArray;

- (BOOL) validate;

// Date Action
- (void) setDate:(NSDate *)date;
- (void) nextDate;
- (void) prevDate;
- (void) today;
- (NSString *)getDate;

@end
