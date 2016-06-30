//
//  LoginViewController.h
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoTextField;
@class RoundedButton;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet DemoTextField *mEmailTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *mPasswordTextField;
@property (weak, nonatomic) IBOutlet RoundedButton *mLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *rhinofitLabel;

@end
