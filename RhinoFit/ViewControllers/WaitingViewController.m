//
//  WaitingViewController.m
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "WaitingViewController.h"

@interface WaitingViewController ()

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showWaitingIndicator
{
    [self.view setHidden:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [self.waitingIndicator startAnimating];
    [self.waitingIndicator setHidden:NO];
    [self.resultLabel setHidden:YES];
}

- (void) showResult:(NSString*)result
{
    [self.view setHidden:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [self.waitingIndicator stopAnimating];
    [self.waitingIndicator setHidden:YES];
    [self.resultLabel setText:result];
    [self.resultLabel setHidden:NO];
}

@end
