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

@interface LoginViewController ()<NetworkManagerDelegate>

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
        networkManage.delegate = self;
        [networkManage sendEmailLogin:mEmailTextField.text password:mPasswordTextField.text];
    }
}

- (void) successfullyLoggedIn
{
    [[NSUserDefaults standardUserDefaults] setValue:mEmailTextField.text forKey:kRhinoFitUserEmail];
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = viewController;
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    if ( ![action isEqualToString:kRequestLogin] )
        return;
    
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    
    if ( obj != nil && ![obj isEqualToString:@""] ) {
        [self successfullyLoggedIn];
    }
}

- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    if ( ![action isEqualToString:kRequestLogin] )
        return;
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
}

@end
