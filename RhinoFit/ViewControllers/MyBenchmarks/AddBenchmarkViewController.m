//
//  AddBenchmarkViewController.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AddBenchmarkViewController.h"
#import "NetworkManager.h"
#import "MyMembershipsTableViewCell.h"
#import "Constants.h"
#import "AvailableBenchmark.h"
#import "WaitingViewController.h"
#import "BenchmarkSpinnerViewController.h"
#import "MyBenchmarksViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AddBenchmarkViewController ()<BenchmarkSpinnerViewControllerDelegate>

@property (nonatomic, strong) AvailableBenchmark *selectedBenchmark;
@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIButton *overlayButton;
@property (nonatomic, strong) BenchmarkSpinnerViewController *benchmarkSpinnerViewController;
@property (nonatomic, strong) NSMutableArray * availableBenchmark;

@end

@implementation AddBenchmarkViewController

@synthesize benchmarkTextField;
@synthesize dateTextField;
@synthesize dateButton;
@synthesize measurementTextfield;
@synthesize measurementLabel;
@synthesize benchmarkButton;
@synthesize benchmarkSpinnerButton;
@synthesize saveButton;
@synthesize selectedBenchmark;
@synthesize deleteBenchmarkButton;
@synthesize waitingViewController;
@synthesize overlayView;
@synthesize overlayButton;
@synthesize benchmarkSpinnerViewController;
@synthesize availableBenchmark;

- (void)getAvailableBenchmark
{
    if ( availableBenchmark && [availableBenchmark count] > 0 ) {
        [self setAvailableBenchmarkLabels];
        return;
    }
    
    availableBenchmark = [MyBenchmarksViewController getAvailableBenchmarks];
    if ( availableBenchmark ) {
        [self getAvailableBenchmark];
        return;
    }
    
    if ( availableBenchmark == nil )
        availableBenchmark = [[NSMutableArray alloc] init];
    else
        [availableBenchmark removeAllObjects];
    
    [[NetworkManager sharedManager] getAvailableBenchmarks:^(NSMutableArray *result) {
                availableBenchmark = result;
                [self setAvailableBenchmarkLabels];
            } failure:^(NSString *error) {
                [waitingViewController showResult:error];
            }];
}

- (void) setAvailableBenchmarkLabels
{
    [self setEditableBenchmark:NO];
    if ( availableBenchmark == nil ) {
        [self getAvailableBenchmark];
        return;
    }
    
    if ( [availableBenchmark count] == 0 ) {
        [waitingViewController showResult:kMessageNoAvailableBenchmarks];
        return;
    }
    benchmarkSpinnerViewController.mBenchmarkArray = availableBenchmark;
    [benchmarkSpinnerViewController.tableView reloadData];
    if ( self.mBenchmark ) {
        for ( int i = 0; i < [availableBenchmark count]; i++ ) {
            AvailableBenchmark *available = availableBenchmark[i];
            if ( [available.benchmarkId intValue] == [self.mBenchmark.benchmarkId intValue] ) {
                selectedBenchmark = available;
                [self didSelectedBenchmark:selectedBenchmark];
                break;
            }
        }
        benchmarkTextField.text = self.mBenchmark.title;
        if ( self.mBenchmarkHistory ) {
            [dateTextField setDate:self.mBenchmarkHistory.date format:@"MM/dd/yyyy"];
            measurementTextfield.text = self.mBenchmarkHistory.value;
        }
        else {
            [dateTextField setDate:self.mBenchmark.currentDate format:@"MM/dd/yyyy"];
            measurementTextfield.text = self.mBenchmark.currentScore;
        }
        measurementLabel.text = self.mBenchmark.type;
        [self setEditableBenchmark:YES];
    }
    else {
        [self setEditableBenchmark:NO];
        [benchmarkTextField setEnabled:YES];
        [benchmarkButton setEnabled:YES];
        [overlayView setHidden:NO];
    }
    [waitingViewController.view setHidden:YES];
}

- (void) tapHandler {
    [overlayView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [benchmarkTextField setEnabled:NO];
    [dateTextField setType:TEXT_FIELD_DATE];
    [dateTextField setDate:[NSDate new] format:@"MM/dd/yyyy"];
    
    [saveButton setButtonType:CustomButtonBlue];
    
    if ( self.mBenchmarkHistory ) {
        [deleteBenchmarkButton setHidden:NO];
        [benchmarkTextField setEnabled:NO];
        [benchmarkButton setEnabled:NO];
    }
    else {
        [deleteBenchmarkButton setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        overlayButton = [[UIButton alloc] initWithFrame:self.view.bounds];
        [overlayButton addTarget:self action:@selector(hideBenchmarkSpinner) forControlEvents:UIControlEventTouchUpInside];
        [self.overlayView addSubview:overlayButton];
        
        benchmarkSpinnerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BenchmarkSpinnerViewController"];
        CGRect rect = benchmarkSpinnerButton.frame;
        benchmarkSpinnerViewController.view.frame = CGRectMake(rect.origin.x + 10, rect.origin.y + rect.size.height, rect.size.width - 10, 300);
        benchmarkSpinnerViewController.delegate = self;
        [overlayView setHidden:YES];
        
        [overlayView addSubview:benchmarkSpinnerViewController.view];
        [self addChildViewController:benchmarkSpinnerViewController];
        [self.view addSubview:overlayView];
        
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.view.bounds;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [self getAvailableBenchmark];
        if ( [availableBenchmark count] == 0 )
            [waitingViewController showWaitingIndicator];
        else
            [waitingViewController.view setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideBenchmarkSpinner {
    [self onBenchmarkSpinner:nil];
}
- (void) setEditableBenchmark:(BOOL)isEditable
{
    [benchmarkTextField setEnabled:isEditable];
    [dateTextField setEnabled:isEditable];
    [measurementTextfield setEnabled:isEditable];
    [benchmarkButton setEnabled:isEditable];
    [dateButton setEnabled:isEditable];
    [saveButton setEnabled:isEditable];
    [benchmarkSpinnerButton setEnabled:isEditable];
    if ( isEditable == NO )
        measurementLabel.text = @"";
    
    if ( self.mBenchmarkHistory ) {
        [benchmarkSpinnerButton setEnabled:NO];
        [benchmarkButton setEnabled:NO];
        [benchmarkTextField setEnabled:NO];
    }
}

- (IBAction)onDate:(id)sender {
    [dateTextField becomeFirstResponder];
}
- (IBAction)onBenchmarkSpinner:(id)sender {
    if ( [overlayView isHidden] ) {
        overlayView.alpha = 1.0f;
        [overlayView setHidden:NO];
    }
    else
        [overlayView setHidden:YES];
}
- (IBAction)onDeleteBenchmark:(id)sender {
    [self confirmPopup:kMessageDeleteBenchmark];
}

- (IBAction)onSave:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    hud.labelText = NSLocalizedString(@"Adding...", nil);
    hud.dimBackground = YES;
    
    NSString *dataId = nil;
    if ( self.mBenchmarkHistory )
        dataId = [self.mBenchmarkHistory.benchmarkDataId stringValue];

    NSString *measureText = measurementTextfield.text;
    NSRange range = [self.measurementLabel.text rangeOfString:@":"];
    if ( range.length <= 0 ) {
        measureText = [NSString stringWithFormat:@"%d",[measurementTextfield.text intValue]];
    }
    
    [[NetworkManager sharedManager] addNewBenchmark:[NSString stringWithFormat:@"%@", selectedBenchmark.benchmarkId]
                                               date:dateTextField.text
                                              value:measureText
                                             dataId:dataId
                                            success:^(NSNumber *benchmarkDataId) {
                                                [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                if ( benchmarkDataId ) {
                                                    NSArray *newBenchmark = [[NSArray alloc] initWithObjects:selectedBenchmark, dateTextField.datePicker.date, measurementTextfield.text, nil];
                                                    if ( self.mBenchmarkHistory ) {
                                                        self.mBenchmarkHistory.benchmarkDataId = benchmarkDataId;
                                                        self.mBenchmarkHistory.date = dateTextField.datePicker.date;
                                                        self.mBenchmarkHistory.value = measurementTextfield.text;
                                                    }
                                                    
                                                    [self.delegate didAddedBenchmark:newBenchmark];
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }
                                            }
                                            failure:^(NSString *error) {
                                                [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                [alertView show];
                                            }];
}

#pragma mark - Delete confirm

- (void) confirmPopup:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self deleteBenchmarkData];
    }
}

- (void) deleteBenchmarkData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    hud.labelText = NSLocalizedString(@"Deleting...", nil);
    hud.dimBackground = YES;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    [[NetworkManager sharedManager] deleteBenchmarkData:[self.mBenchmark.benchmarkId stringValue]
                                                   date:[df stringFromDate:self.mBenchmarkHistory.date]
                                                  value:self.mBenchmarkHistory.value
                                                 dataId:[self.mBenchmarkHistory.benchmarkDataId stringValue]
                                                success:^(BOOL isSuccess) {
                                                    [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                    if ( isSuccess )
                                                        [self.delegate didDeletedBenchmarkData];
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }
                                                failure:^(NSString *error) {
                                                    [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                    [alertView show];
                                                }];
}

#pragma mark - BenchmarkSpinnerViewControllerDelegate

- (void)didSelectedBenchmark:(AvailableBenchmark *)benchmark {
    [UIView animateWithDuration:0.2f
                     animations:^{
                         overlayView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [overlayView setHidden:YES];
                     }];
    selectedBenchmark = benchmark;
    benchmarkTextField.text = selectedBenchmark.bdescription;
    if ( [selectedBenchmark.btype isEqualToString:@"minutes:seconds"] ||
        [selectedBenchmark.btype isEqualToString:@"min:sec"] ) {
        [measurementTextfield setType:TEXT_FIELD_MINUTEANDSECOND];
        measurementTextfield.pickerView = nil;
        measurementTextfield.text = @"00:00";
    }
    else {
        [measurementTextfield setType: TEXT_FIELD_NORMAL];
        measurementTextfield.text = @"0";
    }
    measurementLabel.text = selectedBenchmark.btype;
    [self setEditableBenchmark:YES];
}

@end
