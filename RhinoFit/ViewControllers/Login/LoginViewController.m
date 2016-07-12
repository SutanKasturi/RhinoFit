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
#import <Social/Social.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize mEmailTextField;
@synthesize mPasswordTextField;@synthesize mLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [mEmailTextField setType:TEXT_FIELD_EMAIL];
    
    NSString *token = [[NetworkManager sharedManager] getToken];
    if ( token != nil && ![token isEqualToString:@""] ) {
        if ([[NetworkManager sharedManager] checkValidUser]) {
            [self successfullyLoggedIn];
//            [self showTermsView];
        } else {
            [self showTermsView];
//            [self successfullyLoggedIn];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.frame = self.view.bounds;
}

- (IBAction)onLogIn:(id)sender {
    [self.view endEditing:YES];
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
                              success:^(BOOL isLoggedIn, BOOL isValidUser) {
                                  [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                                  if ( isLoggedIn == YES ) {
                                      if (isValidUser) {
                                          [self successfullyLoggedIn];
                                      } else {
                                          [self showTermsView];
//                                          [self successfullyLoggedIn];
                                      }
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
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) showTermsView {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)onOpenBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://my.rhinofit.ca/findrhinofitgym"]];
}

#pragma mark - forgot password methods -

- (IBAction)onResetPassword:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://my.rhinofit.ca/forgetpassword.php"]];
}

#pragma mark - facebook manage method -

- (IBAction)onLikeViaFacebook:(id)sender {
    UIApplication *a = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", kFacebookId]];
    if( ![a canOpenURL:url] )
        url = [NSURL URLWithString:kFacebookLink];
    [a openURL:url];
}

- (IBAction)onShareViaFacebook:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = AppURL;
    
    [self presentViewController:controller animated:YES completion:Nil];
}

@end
