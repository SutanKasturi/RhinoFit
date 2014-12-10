//
//  MyBenchmarksViewController.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyBenchmarksViewController.h"
#import "NetworkManager.h"
#import "MyBenchmarkTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Constants.h"
#import "WaitingViewController.h"
#import "AddBenchmarkViewController.h"
#import "AvailableBenchmark.h"
#import "MyBenchmarkHistoryViewController.h"

@interface MyBenchmarksViewController ()<MyBenchmarkTableViewCellDelegate, AddBenchmarkViewControllerDelegate, MyBenchmarkHistoryViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *mMyBenchmarks;
@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation MyBenchmarksViewController

@synthesize mMyBenchmarks = _mMyBenchmarks;
@synthesize waitingViewController;
@synthesize selectedIndexPath;

static NSMutableArray * availableBenchmark;

+ (NSMutableArray*) getAvailableBenchmarks {
    return availableBenchmark;
}

- (void)getAvailableBenchmark
{
    if ( availableBenchmark != nil ) {
        [self getMyBenchmarks];
        return;
    }
    
    [[NetworkManager sharedManager] getAvailableBenchmarks:^(NSMutableArray *result) {
        if ( result == nil || [result count] == 0 ) {
            [waitingViewController showResult:kMessageNoAvailableBenchmarks];
        }
        else {
            availableBenchmark = result;
            [self getMyBenchmarks];
        }
    } failure:^(NSString *error) {
        [waitingViewController showResult:error];
    }];
}


- (void)getMyBenchmarks
{
    [[NetworkManager sharedManager] getMyBenchmarks:^(NSMutableArray *result) {
        if ( result == nil || [result count] == 0 ) {
            waitingViewController.view.frame = self.tableView.frame;
            [waitingViewController showResult:kMessageNoMyBenchmarks];
        }
        else {
            [waitingViewController.view setHidden:YES];
            _mMyBenchmarks = result;
            NSMutableArray *unavailableBenchmark = [[NSMutableArray alloc] init];
            NSMutableArray *benchmarksTemp = [[NSMutableArray alloc] initWithArray:availableBenchmark];
            for ( MyBenchmark *benchmark in _mMyBenchmarks ) {
                BOOL isAvailable = NO;
                for ( AvailableBenchmark *availableBenchmark in benchmarksTemp ) {
                    if ( [benchmark.benchmarkId intValue] == [availableBenchmark.benchmarkId intValue] ) {
                        isAvailable = YES;
                        [benchmarksTemp removeObject:availableBenchmark];
                        break;
                    }
                }
                if ( isAvailable == NO ) {
                    [unavailableBenchmark addObject:benchmark];
                }
            }
            for ( MyBenchmark *benchmark in unavailableBenchmark ) {
                [_mMyBenchmarks removeObject:benchmark];
            }
            [self.tableView reloadData];
            [self setTitleString];
        }
        [self refresh];
    } failure:^(NSString *error) {
        waitingViewController.view.frame = self.tableView.frame;
        [waitingViewController showResult:error];
    }];
}

- (void) refresh {
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"tableView":self.tableView, @"bottomView": self.bottomLayoutGuide, @"topView": self.topLayoutGuide};
    
    // 2. Define the views Positions
    NSArray *tableview_constraint_POS_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView]-0-[tableView]-0-[bottomView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
    NSArray *tableview_constraint_POS_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView]-0-[tableView]-64-[bottomView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
    if ( availableBenchmark == nil || [availableBenchmark count] == [_mMyBenchmarks count] ) {
        [self.addBenchmarkButton setHidden:YES];
//        [self.view removeConstraint:tableview_constraint_POS_V2[1]];
        [self.view addConstraints:tableview_constraint_POS_V1];
    }
    else {
        [self.addBenchmarkButton setHidden:NO];
//        [self.view removeConstraint:tableview_constraint_POS_V1[1]];
        [self.view addConstraints:tableview_constraint_POS_V2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addBenchmarkButton setButtonType:CustomButtonBlue];
    [self.addBenchmarkButton setHidden:YES];
    [self setTitleString];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.view.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
//        [self getMyBenchmarks];
    }
    if ( availableBenchmark == nil ) {
        [self getAvailableBenchmark];
    }
    else {
        [self getMyBenchmarks];
    }
}

- (void) setTitleString
{
    self.title = [NSString stringWithFormat:@"My Benchmarks (%d)", (int)[_mMyBenchmarks count]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"My Benchmarks";
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self mMyBenchmarks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyBenchmarkTableViewCell";
    MyBenchmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setBenchmark:[self mMyBenchmarks][indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - AddBenchmarkViewControllerDelegate

- (void)didAddedBenchmark:(NSArray *)newBenchmark
{
    [self.tableView beginUpdates];
    
    AvailableBenchmark *available = newBenchmark[0];
    NSDate *date = newBenchmark[1];
    NSString *result = newBenchmark[2];
    
    MyBenchmark *selectedBenchmark = nil;
    NSIndexPath *path = nil;
    
    for ( int i = 0; i < [[self mMyBenchmarks] count]; i++ ) {
        MyBenchmark *theBenchmark = [self mMyBenchmarks][i];
        if ( [theBenchmark.benchmarkId intValue] >= [available.benchmarkId intValue] ) {
            if ( [theBenchmark.benchmarkId intValue] == [available.benchmarkId intValue] ) {
                selectedBenchmark = theBenchmark;
            }
            path = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    BOOL isNew = NO;
    if ( selectedBenchmark == nil ) {
        isNew = YES;
        selectedBenchmark = [[MyBenchmark alloc] init];
        selectedBenchmark.benchmarkId = available.benchmarkId;
        selectedBenchmark.title = available.bdescription;
        selectedBenchmark.type = available.btype;
        if ( path == nil ) {
            path = [NSIndexPath indexPathForRow:[[self mMyBenchmarks] count] inSection:0];
        }
    }
    selectedBenchmark.lastDate = date;
    selectedBenchmark.lastScore = result;
    
    if ( isNew == NO ) {
        BOOL isUpdated = NO;
        if ( [available.btype isEqualToString:@"minutes:seconds"] ) {
            if ( [self getSeconds:result] > [self getSeconds:selectedBenchmark.currentScore])
                isUpdated = YES;
        }
        else {
            if ( [result intValue] > [selectedBenchmark.currentScore intValue] )
                isUpdated = YES;
        }
        
        if ( isUpdated ) {
            selectedBenchmark.currentDate = date;
            selectedBenchmark.currentScore = result;
        }
    }
    else {
        selectedBenchmark.currentDate = date;
        selectedBenchmark.currentScore = result;
        [[self mMyBenchmarks] insertObject:selectedBenchmark atIndex:path.row];
    }
    if ( isNew == NO ) {
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        if ( [[self mMyBenchmarks] count] == [availableBenchmark count] ) {
            [self refresh];
        }
        else if ( [[self mMyBenchmarks] count] == 1 ) {
            [waitingViewController.view setHidden:YES];
        }
    }
    [self.tableView endUpdates];
}

- (int) getSeconds:(NSString*)minuteAndSecond
{
    NSString *string = minuteAndSecond;
    if ( [string isEqualToString:@""] ) {
        string = @"00:00";
    }
    NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
    int minute = [[string substringToIndex:range.location - 1] intValue];
    int second = [[string substringFromIndex:range.location + 1] intValue];
    return minute * 60 + second;
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)onAddBenchmark:(id)sender {
    AddBenchmarkViewController *addBenchmarkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBenchmarkViewController"];
    addBenchmarkViewController.mBenchmark = nil;
    addBenchmarkViewController.delegate = self;
    [self.navigationController pushViewController:addBenchmarkViewController animated:YES];
}

#pragma mark- MyBenchmarksTableViewCellDelegate

- (void)onUpdateBenchmark:(MyBenchmark *)benchmark
{
    AddBenchmarkViewController *addBenchmarkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBenchmarkViewController"];
    addBenchmarkViewController.mBenchmark = benchmark;
    addBenchmarkViewController.delegate = self;
    [self.navigationController pushViewController:addBenchmarkViewController animated:YES];
}

- (void)onHistoryBenchmark:(MyBenchmarkTableViewCell *)cell {
    MyBenchmarkHistoryViewController *benchmarkHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBenchmarkHistoryViewController"];
    benchmarkHistoryViewController.mBenchmark = cell.mBenchmark;
    benchmarkHistoryViewController.delegate = self;
    selectedIndexPath = [self.tableView indexPathForCell:cell];
    [self.navigationController pushViewController:benchmarkHistoryViewController animated:YES];
}

#pragma mark - MyBenchmarkHistoryViewControllerDelegate
- (void)didUpdatedMyBenchmarkHistory {
    if ( selectedIndexPath && selectedIndexPath.row < [[self mMyBenchmarks] count]) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)removeMyBenchmark {
    if ( selectedIndexPath && selectedIndexPath.row < [[self mMyBenchmarks] count]) {
        [[self mMyBenchmarks] removeObjectAtIndex:selectedIndexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        if ( [[self mMyBenchmarks] count] == 0 ) {
            [waitingViewController.view setHidden:NO];
            [waitingViewController showResult:kMessageNoMyBenchmarks];
        }
        else if ( [[self mMyBenchmarks] count] == [availableBenchmark count] - 1 ) {
            [self refresh];
        }
    }
}
@end
