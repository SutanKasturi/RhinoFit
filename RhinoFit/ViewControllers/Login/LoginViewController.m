//
//  LoginViewController.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "LoginViewController.h"
#import "DemoTextField.h"
#import "CustomButton.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize mEmailTextField;
@synthesize mPasswordTextField;
@synthesize mLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [mLoginButton setButtonType:CustomButtonGrey];
    [mEmailTextField setType:TEXT_FIELD_EMAIL];
    
    NSString *token = [[NetworkManager sharedManager] getToken];
    if ( token != nil && ![token isEqualToString:@""] )
        [self successfullyLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogIn:(id)sender {
    BOOL isValid = YES;
    if ( ![mEmailTextField validate] )
        isValid = NO;
    if ( ![mPasswordTextField validate] )
        isValid = NO;
    
    if ( isValid ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        hud.labelText = NSLocalizedString(@"Logging in...", nil);
        hud.dimBackground = YES;
        
        NetworkManager *networkManage = [NetworkManager sharedManager];
        [networkManage sendEmailLogin:mEmailTextField.text
                             password:mPasswordTextField.text
                              success:^(BOOL isLoggedIn) {
                                  [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                                  if ( isLoggedIn == YES ) {
                                      [self successfullyLoggedIn];
                                  }
                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                              }];
    }
}

- (void) successfullyLoggedIn
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = viewController;
}

@end
