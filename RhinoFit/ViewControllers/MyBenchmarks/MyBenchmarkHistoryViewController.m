//
//  MyBenchmarkHistoryViewController.m
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyBenchmarkHistoryViewController.h"
#import "MyBenchmarkHistoryTableViewCell.h"
#import "NetworkManager.h"
#import "AddBenchmarkViewController.h"
#import "WaitingViewController.h"
#import "AvailableBenchmark.h"

@interface MyBenchmarkHistoryViewController () <AddBenchmarkViewControllerDelegate, MyBenchmarkHistoryTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *mBenchmarkHistory;
@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) MyBenchmarkHistoryTableViewCell *selectedCell;

@end

@implementation MyBenchmarkHistoryViewController

@synthesize mBenchmark;
@synthesize mBenchmarkHistory;
@synthesize measurementLabel;
@synthesize waitingViewController;
@synthesize selectedCell;

- (void)getMyBenchmarkHistory {
    mBenchmarkHistory = [[NSMutableArray alloc] init];
    [[NetworkManager sharedManager] getMyBenchmarkData:[mBenchmark.benchmarkId stringValue]
                                               success:^(NSMutableArray *result) {
                                                   if ( result == nil || [result count] == 0 ) {
                                                       [waitingViewController showResult:kMessageNoMyBenchmarkHistories];
                                                   }
                                                   else {
                                                       [waitingViewController.view setHidden:YES];
                                                       mBenchmarkHistory = result;
                                                       [self.tableView reloadData];
                                                   }
                                               }
                                               failure:^(NSString *error) {
                                                   [waitingViewController showResult:error];
                                               }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleString];
    measurementLabel.text = [mBenchmark.type capitalizedString];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
        [self getMyBenchmarkHistory];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTitleString];
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}

- (void) setTitleString {
    self.title = [NSString stringWithFormat:@"%@ - History", mBenchmark.title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mBenchmarkHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyBenchmarkHistoryTableViewCell";
    MyBenchmarkHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setBenchmarkHistory:mBenchmarkHistory[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - AddBenchmarkViewControllerDelegate

- (void)didAddedBenchmark:(NSArray *)newBenchmark{
    if ( selectedCell ) {
        NSIndexPath *path = [self.tableView indexPathForCell:selectedCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [self setBenchmark];
        [self.delegate didUpdatedMyBenchmarkHistory];
    }
}

- (void)didDeletedBenchmarkData {
    if ( selectedCell ) {
        NSIndexPath *path = [self.tableView indexPathForCell:selectedCell];
        [mBenchmarkHistory removeObjectAtIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        if ( [mBenchmarkHistory count] == 0 ) {
            [self.delegate removeMyBenchmark];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self setBenchmark];
        }
    }
}

- (void) setBenchmark {
    BenchmarkHistory *currentHistory = mBenchmarkHistory[0];
    self.mBenchmark.lastDate = currentHistory.date;
    self.mBenchmark.lastScore = currentHistory.value;
    for ( int i = 1; i < [mBenchmarkHistory count]; i++ ) {
        BenchmarkHistory* history = mBenchmarkHistory[i];
        if ( [mBenchmark.type isEqualToString:@"minutes:seconds"] ) {
            if ( [self getSeconds:currentHistory.value] < [self getSeconds:history.value])
                currentHistory = history;
        }
        else {
            if ( [currentHistory.value intValue] < [history.value intValue] )
                currentHistory = history;
        }
    }
    self.mBenchmark.currentDate = currentHistory.date;
    self.mBenchmark.currentScore = currentHistory.value;
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

#pragma mark - MyBenchmarkHistoryTableViewCellDelegate

- (void)onUpdateBenchmark:(MyBenchmarkHistoryTableViewCell*)cell {
    AddBenchmarkViewController *addBenchmarkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBenchmarkViewController"];
    addBenchmarkViewController.mBenchmark = self.mBenchmark;
    addBenchmarkViewController.mBenchmarkHistory = cell.mHistroy;
    selectedCell = cell;
    addBenchmarkViewController.delegate = self;
    [self.navigationController pushViewController:addBenchmarkViewController animated:YES];
}
@end
