//
//  MyMembershipsViewController.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyMembershipsViewController.h"
#import "NetworkManager.h"
#import "MyMembershipsTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Constants.h"
#import "WaitingViewController.h"

@interface MyMembershipsViewController ()

@property (nonatomic, strong) NSMutableArray *mMyMemberships;
@property (nonatomic, strong) WaitingViewController *waitingViewController;

@end

@implementation MyMembershipsViewController

@synthesize mMyMemberships = _mMyMemberships;
@synthesize waitingViewController;

- (NSMutableArray *)mMyMemberships
{
    if ( _mMyMemberships )
        return _mMyMemberships;
    
    [[NetworkManager sharedManager] getMyMemberships:^(NSMutableArray *result) {
        if ( result == nil || [result count] == 0 ) {
            [waitingViewController showResult:kMessageNoMyBenchmarks];
        }
        else {
            [waitingViewController.view setHidden:YES];
            _mMyMemberships = result;
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [waitingViewController showResult:error];
    }];
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self mMyMemberships] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyMembershipsTableViewCell";
    MyMembershipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setMyMembership:[self mMyMemberships][indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
