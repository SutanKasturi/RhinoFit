//
//  AttendanceViewController.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AttendanceViewController.h"
#import "WaitingViewController.h"
#import "Constants.h"
#import "AttendanceTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "NetworkManager.h"

@interface AttendanceViewController ()<AttendanceTableViewCellDelegate, NetworkManagerDelegate, SRMonthPickerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSMutableArray *mAttendance;

@end

@implementation AttendanceViewController

@synthesize waitingViewController;
@synthesize mAttendance;
@synthesize monthLabel;
@synthesize monthPicker;

- (NSString*)formatDate:(NSDate *)date
{
    // A convenience method that formats the date in Month-Year format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM, y";
    return [formatter stringFromDate:date];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleString];

    self.monthPicker.monthPickerDelegate = self;
    
    // Set the label to show the date
    monthLabel.text = [NSString stringWithFormat:@"%@", [self formatDate:self.monthPicker.date]];
    
    // Some options to play around with
    monthPicker.maximumYear = @2100;
    monthPicker.minimumYear = @1900;
    monthPicker.yearFirst = YES;
    [monthPicker setHidden:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self getAttendances];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
    waitingViewController.view.frame = self.tableView.frame;
    [self addChildViewController:waitingViewController];
    [self.view addSubview:waitingViewController.view];
    [waitingViewController showWaitingIndicator];
}

- (void) setTitleString
{
    self.title = [NSString stringWithFormat:@"My Attendace(%d)", (int)[mAttendance count]];
}

#pragma mark - TapGesture
- (void) tapHandle
{
    [monthPicker setHidden:YES];
}

#pragma mark - SRMonthPickerDelegate

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
    dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);
    
    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getAttendances];
        });
    });
    
}

- (void) getAttendances
{
    monthLabel.text = [NSString stringWithFormat:@"%@", [self formatDate:self.monthPicker.date]];
    [waitingViewController showWaitingIndicator];
    NetworkManager *networkManager = [NetworkManager sharedManager];
    networkManager.delegate = self;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *year = [df stringFromDate:monthPicker.date];
    [components setYear:[year intValue]];
    [df setDateFormat:@"MM"];
    NSString *month = [df stringFromDate:monthPicker.date];
    [components setMonth:[month intValue]];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[cal dateFromComponents:components]];
    
    [networkManager getAttendance:[NSString stringWithFormat:@"%@-%@-01", year, month] endDate:[NSString stringWithFormat:@"%@-%@-%d", year, month, (int)range.length]];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    if ( ![action isEqualToString:kRequestGetAttendance] )
        return;
    
    if ( obj != nil && [obj isKindOfClass:[NSMutableArray class]]) {
        mAttendance = obj;
        [self setTitleString];
        [self.tableView reloadData];
        if ( [[self mAttendance] count] == 0 ) {
            [waitingViewController showResult:kMessageNoAttendance];
        }
        else
            [waitingViewController.view setHidden:YES];
    }
    else {
        [waitingViewController showResult:kMessageNoClasses];
    }
}

- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    if ( ![action isEqualToString:kRequestListReservations] )
        return;
    
    [waitingViewController showResult:errorMessage];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mAttendance count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AttendanceTableViewCell";
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setAttendance:mAttendance[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - ReservationTableViewCellDelegate

- (void)didCanceledAttendance:(AttendanceTableViewCell *)cell
{
    [self.tableView beginUpdates];
    [mAttendance removeObject:cell.mAttendance];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Button Action

- (IBAction)onChangeMonth:(id)sender {
    if ( monthPicker.hidden ) {
        [self.view bringSubviewToFront:monthPicker];
        [monthPicker setHidden:NO];
    }
    else
        [monthPicker setHidden:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [monthPicker setHidden:YES];
}

@end
