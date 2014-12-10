//
//  MyWodsViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyWodsViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "WodInfo.h"
#import "NetworkManager.h"
#import "WaitingViewController.h"
#import "MyWodsTableViewCell.h"
#import "TrackWodViewController.h"

@interface MyWodsViewController ()<SRMonthPickerDelegate, UIScrollViewDelegate, MyWodsTableViewCellDelegate, TrackWodViewControllerDelegate>

@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSMutableArray *mMyWods;
@property (nonatomic, strong) NSIndexPath *mSelectedIndexPath;
@end

@implementation MyWodsViewController

@synthesize waitingViewController;
@synthesize mMyWods;
@synthesize monthLabel;
@synthesize monthPicker;

static NSDate *startDate;

+ (void) setStartDate:(NSDate*)date {
    startDate = date;
}

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
    
    self.monthPicker.date = startDate;
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
    
    [self setTitleString];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
        [self getMyWods];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) setTitleString
{
    self.title = [NSString stringWithFormat:@"My WODS (%d)", (int)[mMyWods count]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mMyWods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyWodsTableViewCell";
    MyWodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    WodInfo *wodInfo = mMyWods[indexPath.row];
    if ( wodInfo.startDate == nil ) {
        wodInfo.startDate = monthPicker.date;
    }
    [cell setupWodInfo:wodInfo];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *results = ((WodInfo*)mMyWods[indexPath.row]).results;
    CGSize defaultSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 115);
    
    
    float width = defaultSize.width - 56;
    CGSize constrainedSize = CGSizeMake(width, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:results attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0,0, width, requiredHeight.size.height);
    }
    
    return defaultSize.height + requiredHeight.size.height;
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
            [self getMyWods];
        });
    });
    
}

- (void) getMyWods
{
    monthLabel.text = [NSString stringWithFormat:@"%@", [self formatDate:self.monthPicker.date]];
    [waitingViewController showWaitingIndicator];
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
    
    [[NetworkManager sharedManager] getMyWods:[NSString stringWithFormat:@"%@-%@-01", year, month]
                                          endDate:[NSString stringWithFormat:@"%@-%@-%d", year, month, (int)range.length]
                                          success:^(NSArray *result) {
                                              if ( result != nil ) {
                                                  mMyWods = [[NSMutableArray alloc] initWithArray:result];
                                                  [self.tableView reloadData];
                                                  if ( [mMyWods count] == 0 ) {
                                                      [waitingViewController showResult:kMessageNoMyWods];
                                                  }
                                                  else
                                                      [waitingViewController.view setHidden:YES];
                                              }
                                              else {
                                                  [waitingViewController showResult:kMessageNoMyWods];
                                              }
                                              [self setTitleString];
                                          }
                                          failure:^(NSString *error) {
                                              [waitingViewController showResult:error];
                                          }];
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

#pragma mark - MyWodsTableViewCellDelegate
- (void)onEditMyWod:(MyWodsTableViewCell *)cell {
    TrackWodViewController *trackWodViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackWodViewController"];
    trackWodViewController.mWodInfo = cell.mWodInfo;
    self.mSelectedIndexPath = [self.tableView indexPathForCell:cell];
    [self.navigationController pushViewController:trackWodViewController animated:YES];
}

#pragma mark - TrackWodViewControllerDelegate
- (void)didChangedWod {
    if ( self.mSelectedIndexPath ) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[self.mSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
@end
