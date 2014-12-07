//
//  MyProfileEditContentViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyProfileEditContentViewController.h"
#import "TakePhoto.h"
#import "NetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyProfileEditContentViewController ()<TakePhotoDelegate>

@property (nonatomic, strong) TakePhoto *takePhoto;
@property (nonatomic, strong) UIImage *mImage;

@end

@implementation MyProfileEditContentViewController

@synthesize takePhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat height = 587;
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    [self.delegate didChangeScrollContent:height];
    [self.saveButton setButtonType:CustomButtonGrey];
    [self setupProfileContent];
    [self.emailTextField setType:TEXT_FIELD_EMAIL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupProfileContent {
    UserInfo *currentUser = [[NetworkManager sharedManager] getUser];
    
    if ( currentUser ) {
        [self.avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUser.userPicture]]
                                    placeholderImage:[UIImage imageNamed:@"avatar"]
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 self.avatarImageView.image = image;
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             }];
        self.firstNameTextField.text = currentUser.userFirstName;
        self.lastNameTextField.text = currentUser.userLastName;
        self.address1TextField.text = currentUser.userAddress1;
        self.address2TextField.text = currentUser.userAddress2;
        self.cityTextField.text = currentUser.userCity;
        self.stateAndProviceTextField.text = currentUser.userState;
        self.zipAndPostalTextField.text = currentUser.userZip;
        self.countryTextField.text = currentUser.userCountry;
        self.emailTextField.text = currentUser.userEmail;
        self.homePhoneTextField.text = currentUser.userPhone1;
        self.mobilePhoneTextField.text = currentUser.userPhone2;
    }
}

#pragma mark - Button Actions

- (IBAction)onUpdatePicture:(id)sender {
    if ( takePhoto == nil ) {
        takePhoto = [[TakePhoto alloc] init:self];
        takePhoto.actiondelegate = self;
        [self addChildViewController:takePhoto];
    }
    [takePhoto takePhoto];
}

- (IBAction)onSave:(id)sender {
    BOOL isValidate = YES;
    if ( ![self.firstNameTextField validate] )
        isValidate = NO;
    if ( ![self.lastNameTextField validate] )
        isValidate = NO;
    if ( ![self.lastNameTextField validate] )
        isValidate = NO;
    if ( ![self.address1TextField validate] )
        isValidate = NO;
    if ( ![self.address2TextField validate] )
        isValidate = NO;
    if ( ![self.cityTextField validate] )
        isValidate = NO;
    if ( ![self.stateAndProviceTextField validate] )
        isValidate = NO;
    if ( ![self.zipAndPostalTextField validate] )
        isValidate = NO;
    if ( ![self.homePhoneTextField validate] )
        isValidate = NO;
    if ( ![self.mobilePhoneTextField validate] )
        isValidate = NO;
    if ( ![self.countryTextField validate] )
        isValidate = NO;
    if ( ![self.emailTextField validate] )
        isValidate = NO;
    
    if ( isValidate == NO )
    {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view.superview animated:YES];
    hud.labelText = NSLocalizedString(@"Updating...", nil);
    hud.dimBackground = YES;
    
    [[NetworkManager sharedManager] updateUserInfo:self.mImage
                                         firstName:self.firstNameTextField.text
                                          lastName:self.lastNameTextField.text
                                          address1:self.address1TextField.text
                                          address2:self.address2TextField.text
                                              city:self.cityTextField.text
                                  stateAndProvince:self.stateAndProviceTextField.text
                                      zipAndPostal:self.zipAndPostalTextField.text
                                           country:self.countryTextField.text
                                         homePhone:self.homePhoneTextField.text
                                       mobilePhone:self.mobilePhoneTextField.text
                                             email:self.emailTextField.text
                                           success:^(id result) {
                                               [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           failure:^(NSString *error) {
                                               [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                           }];
}

#pragma mark - TakePhotoDelegate

- (void)setImage:(UIImage *)aImage {
    self.mImage = aImage;
    self.avatarImageView.image = aImage;
}

@end
