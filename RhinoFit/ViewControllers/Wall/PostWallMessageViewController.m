//
//  PostWallMessageViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "PostWallMessageViewController.h"
#import "PostWallMessageContentViewController.h"

@interface PostWallMessageViewController ()<PostWallMessageContentViewControllerDelegate>

@property (nonatomic, strong) PostWallMessageContentViewController *postWallMessageContentViewController;

@end

@implementation PostWallMessageViewController

@synthesize postWallMessageContentViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.postThisMessageButton setButtonType:CustomButtonBlue];
    
    self.navigationItem.backBarButtonItem.title = @"";
    self.title = @"Post a Wall Message";
    
    if ( postWallMessageContentViewController == nil ) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
        
        postWallMessageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostWallMessageContentViewController"];
        postWallMessageContentViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 484);
        postWallMessageContentViewController.delegate = self;
        [self addChildViewController:postWallMessageContentViewController];
        [self.scrollView addSubview:postWallMessageContentViewController.view];
        
        [self.view addSubview:self.scrollView];
    }
    
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPostThisMessage:(id)sender {
    [postWallMessageContentViewController postThisMessage];
}

#pragma mark - PostWallMessageContentViewControllerDelegate

- (void)didChangeContentHeight:(CGFloat)height {
    if ( height == -1 ) {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(0, height);
    }
}

@end
