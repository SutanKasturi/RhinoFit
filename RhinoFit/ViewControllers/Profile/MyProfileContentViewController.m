//
//  MyProfileContentViewController.m
//  RhinoFit
//
//  Created by Admin on 12/6/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyProfileContentViewController.h"
#import "UserInfo.h"
#import "NetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MyProfileContentViewController ()

@end

@implementation MyProfileContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupProfileContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupProfileContent) name:kNotificationUpdateProfile object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationUpdateProfile];
}

- (void) setupProfileContent {
    UserInfo *currentUser = [[NetworkManager sharedManager] getUser];

    if ( currentUser ) {
        NSLog(@"AVATAR IMAGE: %@", currentUser.userPicture);
        [self.avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUser.userPicture]]
                                    placeholderImage:[UIImage imageNamed:@"avatar"]
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 self.avatarImageView.image = image;
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             }];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.userFirstName, currentUser.userLastName];
        NSString *address = [NSString stringWithFormat:@"%@\n%@\n%@, %@\n%@\n%@", currentUser.userAddress1, currentUser.userAddress2, currentUser.userCity, currentUser.userState, currentUser.userZip, currentUser.userCountry];
        self.addressLabel.text = address;
        self.phoneLabel.text = [NSString stringWithFormat:@"%@\n%@", currentUser.userPhone1, currentUser.userPhone2];
        self.emailLabel.text = currentUser.userEmail;
        
        float width = [UIScreen mainScreen].bounds.size.width - 115;
        CGSize constrainedSize = CGSizeMake(width, 9999);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:address attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width > width) {
            requiredHeight = CGRectMake(0,0, width, requiredHeight.size.height);
        }
        float height = 247 + requiredHeight.size.height;
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
        [self.delegate didChangeContentHeight:height];
    }
}

@end
