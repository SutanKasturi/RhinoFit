//
//  TermsViewController.m
//  RhinoFit
//
//  Created by S on 6/23/16.
//  Copyright © 2016 Sutan. All rights reserved.
//

#import "TermsViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "NetworkManager.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btnCheckBox setImage: [UIImage imageNamed:@"check_box_false"] forState:UIControlStateNormal];
    [self.btnCheckBox setImage:[UIImage imageNamed:@"check_box_true"] forState:UIControlStateSelected];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Getting Eula...", nil);
    hud.dimBackground = YES;
    
    NetworkManager *networkManage = [NetworkManager sharedManager];
    [networkManage getCurrentEula:[[NetworkManager sharedManager] getToken]
                          success:^(NSString *eulaContent) {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              if (![eulaContent isEqualToString:@""]) {
                                  NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                                          initWithData:[eulaContent dataUsingEncoding:NSUnicodeStringEncoding]
                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                          documentAttributes:nil
                                                                          error:nil];
                                  self.termsContentTextView.attributedText = attributedString;
                              }
                          } failed:^(NSError *error) {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCheckBox:(id)sender {

    if (self.btnCheckBox.isSelected) {
        [self.btnCheckBox setSelected:NO];
        [self.btnSubmit setEnabled:NO];
    } else {
        [self.btnCheckBox setSelected:YES];
        [self.btnSubmit setEnabled:YES];
    }
}

- (IBAction)tapSubmit:(id)sender {
    
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Accept Eula...", nil);
    hud.dimBackground = YES;
    NetworkManager *networkManage = [NetworkManager sharedManager];
    [networkManage acceptEula:[sharedInstance objectForKey:kParamEulaVersionId]
                      success:^(BOOL isSuccess) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          if (isSuccess) {
                              UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                              AppDelegate *app = [[UIApplication sharedApplication] delegate];
                              app.window.rootViewController = viewController;
                          }
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
