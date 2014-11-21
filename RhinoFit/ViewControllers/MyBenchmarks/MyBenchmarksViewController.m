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

- (void)getMyBenchmarks
{
//    if ( _mMyBenchmarks ) {
//        [waitingViewController.view setHidden:YES];
//        return;
//    }
    
//    _mMyBenchmarks = [[NSMutableArray alloc] init];

    [[NetworkManager sharedManager] getMyBenchmarks:^(NSMutableArray *result) {
        if ( result == nil || [result count] == 0 ) {
            [waitingViewController showResult:kMessageNoMyBenchmarks];
        }
        else {
            [waitingViewController.view setHidden:YES];
            _mMyBenchmarks = result;
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [waitingViewController showResult:error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addBenchmarkButton setButtonType:CustomButtonBlue];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.view.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
        [self getMyBenchmarks];
    }
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
    BOOL isNew = NO;
    for ( int i = 0; i < [[self mMyBenchmarks] count]; i++ ) {
        MyBenchmark *theBenchmark = [self mMyBenchmarks][i];
        if ( [theBenchmark.benchmarkId intValue] >= [available.benchmarkId intValue] ) {
            if ( [theBenchmark.benchmarkId intValue] == [available.benchmarkId intValue] ) {
                selectedBenchmark = theBenchmark;
            }
            else {
                isNew = YES;
            }
            
            path = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    if ( selectedBenchmark == nil ) {
        selectedBenchmark = [[MyBenchmark alloc] init];
        selectedBenchmark.benchmarkId = available.benchmarkId;
        selectedBenchmark.title = available.bdescription;
        selectedBenchmark.type = available.btype;
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
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
@end
