//
//  PostWallMessageContentViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "PostWallMessageContentViewController.h"
#import "TakePhoto.h"
#import "NetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PostWallMessageContentViewController ()<TakePhotoDelegate>

@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) TakePhoto *takePhoto;

@end

@implementation PostWallMessageContentViewController

@synthesize takePhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.messageTextView setText:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPictureButton:(id)sender {
    if ( self.postImage == nil ) {
        if ( takePhoto == nil ) {
            takePhoto = [[TakePhoto alloc] init:self];
            takePhoto.actiondelegate = self;
            [self addChildViewController:takePhoto];
        }
        [takePhoto takePhoto];
    }
    else {
        self.postImage = nil;
        self.postImageView.image = nil;
        [self setPictureButtonTitle];
        [self.delegate didChangeContentHeight:-1];
    }
}

- (void) setPictureButtonTitle {
    if ( self.postImage == nil ) {
        [self.pictureButton setTitle:@"Add Picture" forState:UIControlStateNormal];
    }
    else {
        [self.pictureButton setTitle:@"Remove Picture" forState:UIControlStateNormal];
    }
}

- (void) postThisMessage {
    if ( [self.messageTextView validate] ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view.superview animated:YES];
        hud.labelText = NSLocalizedString(@"Posting...", nil);
        hud.dimBackground = YES;
        
        [[NetworkManager sharedManager] addWallPostWithImage:self.postImage
                                                     message:self.messageTextView.text
                                                     success:^(NSNumber*wallId) {
                                                         [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                                     }
                                                     failure:^(NSString *error) {
                                                         [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                                     }];
    }
}

#pragma mark - TakePhotoDelegate

- (void)setImage:(UIImage *)aImage {
    self.postImage = aImage;
    self.postImageView.image = aImage;
    [self.delegate didChangeContentHeight:484];
    [self setPictureButtonTitle];
}

@end
