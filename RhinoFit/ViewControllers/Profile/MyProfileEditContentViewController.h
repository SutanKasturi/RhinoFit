//
//  MyProfileEditContentViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContentViewController.h"
#import "CustomButton.h"
#import "DemoTextField.h"

@interface MyProfileEditContentViewController : ScrollContentViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet DemoTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *address1TextField;
@property (weak, nonatomic) IBOutlet DemoTextField *address2TextField;
@property (weak, nonatomic) IBOutlet DemoTextField *cityTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *stateAndProviceTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *zipAndPostalTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *countryTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *homePhoneTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *mobilePhoneTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CustomButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *countryIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stateIndicator;

@end
