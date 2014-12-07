//
//  TrackWodViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "TrackWodViewController.h"
#import "WaitingViewController.h"
#import "NetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MyWodsViewController.h"

@interface TrackWodViewController ()

@property (nonatomic, strong) WaitingViewController *waitingViewController;

@end

@implementation TrackWodViewController

@synthesize waitingViewController;
@synthesize mClass;
@synthesize classId;
@synthesize startDate;
@synthesize mWodInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.trackWodButton setButtonType:CustomButtonGrey];
    self.nameLabel.text = @"";
    self.timeLabel.text = @"";
    self.dateLabel.text = @"";
    self.descriptionTextView.text = @"";
    self.resultsTextView.text = @"";
    
    float height = 507;
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    [self.delegate didChangeScrollContent:height];
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.title = @"Track WOD";
}

- (void)viewDidAppear:(BOOL)animated {
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.view.bounds;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        
        [waitingViewController showWaitingIndicator];
        if ( mClass ) {
            classId = mClass.classId;
            startDate = mClass.startDate;
        }
        else if ( mWodInfo ) {
            classId = mWodInfo.classId;
            startDate = mWodInfo.startDate;
        }
        
        [[NetworkManager sharedManager] getWodInfo:classId
                                         startDate:startDate
                                           success:^(id results) {
                                               if ( results != nil )
                                               {
                                                   [self setupWodInfo:results];
                                                   [waitingViewController.view setHidden:YES];
                                               }
                                               else {
                                                   [waitingViewController showResult:results];
                                               }
                                           }
                                           failure:^(NSString *error) {
                                               [waitingViewController showResult:error];
                                           }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupWodInfo:(WodInfo*)wodInfo {
    mWodInfo = wodInfo;
    if ( wodInfo ) {
        self.nameLabel.text = wodInfo.name;
        self.titleTextField.text = wodInfo.title;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        self.timeLabel.text = [df stringFromDate:wodInfo.startDate];
        [df setDateFormat:@"MMM dd, yyyy"];
        self.dateLabel.text = [df stringFromDate:wodInfo.startDate];
        self.descriptionTextView.text = wodInfo.wod;
        self.resultsTextView.text = wodInfo.results;
        
        if ( wodInfo.canEdit == NO ) {
            [self.titleTextField setEnabled:NO];
            [self.titleTextField setBorderColor:[UIColor clearColor]];
            [self.titleTextField setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.1f]];
            [self.descriptionTextView setEditable:NO];
            [self.descriptionTextView setBorderColor:[UIColor clearColor]];
            [self.descriptionTextView setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.1f]];
            [self.resultsTextView setEditable:NO];
            [self.resultsTextView setBorderColor:[UIColor clearColor]];
            [self.resultsTextView setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.1f]];
        }
        else {
            [self.titleTextField setEnabled:YES];
            [self.descriptionTextView setEditable:YES];
            [self.resultsTextView setEditable:YES];
        }
    }
}
- (IBAction)onTrackWod:(id)sender {
    if ( mWodInfo && mWodInfo.canEdit ) {
        BOOL isValidate = YES;
        if ( ![self.titleTextField validate] )
            isValidate = NO;
        if ( ![self.descriptionTextView validate] )
            isValidate = NO;
        if ( ![self.resultsTextView validate] )
            isValidate = NO;
        
        if ( isValidate == NO )
            return;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view.superview animated:YES];
        hud.labelText = NSLocalizedString(@"Saving...", nil);
        hud.dimBackground = YES;
        
        [[NetworkManager sharedManager] trackWod:mWodInfo.classId
                                       startDate:mWodInfo.startDate
                                             wod:self.descriptionTextView.text
                                           title:self.titleTextField.text
                                         results:self.resultsTextView.text
                                         success:^(id results) {
                                             [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                             if ( mClass ) {
                                                 [MyWodsViewController setStartDate:mWodInfo.startDate];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMyWods object:nil];
                                             }
                                             else {
                                                 mWodInfo.title = self.titleTextField.text;
                                                 mWodInfo.wod = self.descriptionTextView.text;
                                                 mWodInfo.results = self.resultsTextView.text;
                                                 mWodInfo.wodId = [results objectForKey:kResponseKeyWodWodId];
                                                 [self.wodDelegate didChangedWod];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }
                                         }
                                         failure:^(NSString *error) {
                                             [MBProgressHUD hideHUDForView:self.parentViewController.view.superview animated:YES];
                                         }];
    }
    else {
        [MyWodsViewController setStartDate:mWodInfo.startDate];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMyWods object:nil];

    }
}

@end
