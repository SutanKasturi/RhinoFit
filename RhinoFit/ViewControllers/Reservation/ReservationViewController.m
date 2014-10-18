//
//  ReservationViewController.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ReservationViewController.h"
#import "WaitingViewController.h"
#import "Constants.h"
#import "ReservationTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "NetworkManager.h"

@interface ReservationViewController ()<ReservationTableViewCellDelegate, NetworkManagerDelegate>

@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSMutableArray *mReservations;

@end

@implementation ReservationViewController

@synthesize waitingViewController;
@synthesize mReservations = _mReservations;

- (NSMutableArray *) mReservations
{
    if ( _mReservations )
        return _mReservations;
    
    NetworkManager *networkManager = [NetworkManager sharedManager];
    networkManager.delegate = self;
    [networkManager listReservation];
    
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleString];
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
    self.title = [NSString stringWithFormat:@"My Reservations(%d)", (int)[[self mReservations] count]];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    if ( ![action isEqualToString:kRequestListReservations] )
        return;
    
    if ( obj != nil && [obj isKindOfClass:[NSMutableArray class]]) {
        _mReservations = obj;
        [self setTitleString];
        [self.tableView reloadData];
        if ( [[self mReservations] count] == 0 ) {
            [waitingViewController showResult:kMessageNoReservations];
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
    return [[self mReservations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ReservationTableViewCell";
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setReservation:[self mReservations][indexPath.row]];
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

- (void)didCanceledReservation:(ReservationTableViewCell *)cell
{
    [self.tableView beginUpdates];
    [[self mReservations] removeObject:cell.mReservation];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end