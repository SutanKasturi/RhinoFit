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
#import <MBProgressHUD/MBProgressHUD.h>

@interface AddBenchmarkViewController ()<DemoTextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *availableBenchmarkLabels;
@property (nonatomic, strong) AvailableBenchmark *selectedBenchmark;
@property (nonatomic, strong) WaitingViewController *waitingViewController;

@end

@implementation AddBenchmarkViewController

@synthesize benchmarkTextField;
@synthesize dateTextField;
@synthesize dateButton;
@synthesize measurementTextfield;
@synthesize measurementLabel;
@synthesize benchmarkButton;
@synthesize saveButton;
@synthesize availableBenchmarkLabels;
@synthesize selectedBenchmark;
@synthesize waitingViewController;

static NSMutableArray * availableBenchmark;

- (NSMutableArray*)getAvailableBenchmark
{
    if ( availableBenchmark && [availableBenchmark count] > 0 )
        return availableBenchmark;
    
    if ( availableBenchmark == nil )
        availableBenchmark = [[NSMutableArray alloc] init];
    else
        [availableBenchmark removeAllObjects];
    
    [[NetworkManager sharedManager] getAvailableBenchmarks:^(NSMutableArray *result) {
        availableBenchmark = result;
        [self setAvailableBenchmarkLabels];
    } failure:^(NSString *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    return availableBenchmark;
}

- (void) setAvailableBenchmarkLabels
{
    [self setEditableBenchmark:NO];
    if ( availableBenchmark == nil ) {
        [self getAvailableBenchmark];
        return;
    }
    
    if ( availableBenchmark == nil || [availableBenchmark count] == 0 ) {
        [waitingViewController showResult:@"There is no available benchmark"];
        return;
    }
    
    if ( availableBenchmarkLabels == nil )
        availableBenchmarkLabels = [[NSMutableArray alloc] init];
    else
        [availableBenchmarkLabels removeAllObjects];
    for ( AvailableBenchmark *available in availableBenchmark) {
        [availableBenchmarkLabels addObject:available.bdescription];
    }
    
    benchmarkTextField.pickerArray = availableBenchmarkLabels;
    [benchmarkTextField setType:TEXT_FIELD_PICKER];
    benchmarkTextField.pickerdelegate = self;
    
    if ( self.mBenchmark ) {
        for ( int i = 0; i < [availableBenchmark count]; i++ ) {
            AvailableBenchmark *available = availableBenchmark[i];
            if ( [available.benchmarkId intValue] == [self.mBenchmark.benchmarkId intValue] ) {
                selectedBenchmark = available;
                [self didSelectedPicker:i];
                break;
            }
        }
        benchmarkTextField.text = self.mBenchmark.title;
        measurementTextfield.text = self.mBenchmark.lastScore;
        measurementLabel.text = self.mBenchmark.type;
        [self setEditableBenchmark:YES];
    }
    else {
        [self setEditableBenchmark:NO];
        [benchmarkTextField setEnabled:YES];
        [benchmarkButton setEnabled:YES];
    }
    [waitingViewController.view setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [benchmarkTextField setEnabled:NO];
    [dateTextField setType:TEXT_FIELD_DATE];
    [dateTextField setDate:[NSDate new] format:@"MM/dd/yyyy"];
    
    [saveButton setButtonType:CustomButtonBlue];
    
    [self setAvailableBenchmarkLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.view.bounds;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        if ( [[self getAvailableBenchmark] count] == 0 )
            [waitingViewController showWaitingIndicator];
        else
            [waitingViewController.view setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEditableBenchmark:(BOOL)isEditable
{
    [benchmarkTextField setEnabled:isEditable];
    [dateTextField setEnabled:isEditable];
    [measurementTextfield setEnabled:isEditable];
    [benchmarkButton setEnabled:isEditable];
    [dateButton setEnabled:isEditable];
    [saveButton setEnabled:isEditable];
    if ( isEditable == NO )
        measurementLabel.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onDate:(id)sender {
    [dateTextField becomeFirstResponder];
}
- (IBAction)onBenchmark:(id)sender {
    [benchmarkTextField becomeFirstResponder];
}

- (IBAction)onSave:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    hud.labelText = NSLocalizedString(@"Adding...", nil);
    hud.dimBackground = YES;
    [[NetworkManager sharedManager] addNewBenchmark:[NSString stringWithFormat:@"%@", selectedBenchmark.benchmarkId]
                                               date:dateTextField.text
                                              value:measurementTextfield.text
                                            success:^(NSMutableDictionary *result) {
                                                [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                if ( result ) {
                                                    NSArray *newBenchmark = [[NSArray alloc] initWithObjects:selectedBenchmark, dateTextField.datePicker.date, measurementTextfield.text, nil];
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

#pragma mark - DemoTextFieldDelegate

- (void)didSelectedPicker:(int)row
{
    selectedBenchmark = [self getAvailableBenchmark][row];
    if ( [selectedBenchmark.btype isEqualToString:@"minutes:seconds"] ) {
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
