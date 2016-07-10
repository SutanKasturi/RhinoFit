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
            takePhoto.isAllowEditing = NO;
            takePhoto.actiondelegate = self;
            [self addChildViewController:takePhoto];
        }
        [takePhoto takePhoto];
    }
    else {
        self.postImage = nil;
        self.postImageView.image = nil;
        [self setPictureButtonTitle];
        [self.scrollDelegate didChangeScrollContent:-1];
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
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"AddWalls" object:self];
                                                         [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                                         [self.navigationController popViewControllerAnimated:YES];
//                                                         Wall *wall = [[Wall alloc] init];
//                                                         wall.wallId = wallId;
//                                                         wall.msg = self.messageTextView.text;
//                                                         UserInfo *userInfo = [[NetworkManager sharedManager] getUser];
//                                                         if ( userInfo ) {
//                                                             wall.name = [NSString stringWithFormat:@"%@ %@", userInfo.userFirstName, userInfo.userLastName];
//                                                             wall.profilePic = userInfo.userPicture;
//                                                         }
//                                                         wall.yours = YES;
//                                                         wall.pic =
                                                     }
                                                     failure:^(NSString *error) {
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"AddWalls" object:self];
                                                         [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                                     }];
    }
}

#pragma mark - TakePhotoDelegate

- (void)setImage:(UIImage *)aImage {
    self.postImage = [self imageWithImage:aImage];
    self.postImageView.image = self.postImage;
    [self.scrollDelegate didChangeScrollContent:484];
    [self setPictureButtonTitle];
}

- (UIImage *) imageWithImage:(UIImage*)image {
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if ( width > 800 ) {
        height = height / width * 800;
        width = 800;
    }
    if ( height > 800 ) {
        width = width / height * 800;
        height = 800;
    }
    size.width = width;
    size.height = height;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
