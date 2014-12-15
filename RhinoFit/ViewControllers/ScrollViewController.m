//
//  ScrollViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ScrollViewController.h"
#import "ScrollContentDelegate.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"";
    
    if ( self.viewController ) {
        CGRect rect = [UIScreen mainScreen].bounds;
        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        self.viewController.delegate = self;
        [self addChildViewController:self.viewController];
        [self.scrollView addSubview:self.viewController.view];
        [self.view addSubview:self.scrollView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setContentViewController:(ScrollContentViewController*)viewController {
    self.viewController = viewController;
}

#pragma mark - ScrollContentDelegate

- (void) didChangeScrollContent:(CGFloat)height {
    self.scrollView.contentSize = CGSizeMake(0, height);
}

@end
