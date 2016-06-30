//
//  MyProfileViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyProfileViewController.h"
#import "NetworkManager.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MyProfileContentViewController.h"
#import "ScrollViewController.h"

@interface MyProfileViewController ()<MyProfileContentViewControllerDelegate>

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    
    MyProfileContentViewController *myProfileContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileContentViewController"];
    myProfileContentViewController.delegate = self;
    [self addChildViewController:myProfileContentViewController];
    [self.scrollView addSubview:myProfileContentViewController.view];
    [self.view addSubview:self.scrollView];
    
//    [self.updateMyProfileButton setButtonType:CustomButtonBlue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (IBAction)onUpdateMyProfile:(id)sender {
    ScrollViewController *scrollViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrollViewController"];
    [scrollViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileEditContentViewController"]];
    [self.navigationController pushViewController:scrollViewController animated:YES];
    scrollViewController.title = @"Edit My Profile";
}

- (void)didChangeContentHeight:(CGFloat)height {
    self.scrollView.contentSize = CGSizeMake(0, height);
}

@end
