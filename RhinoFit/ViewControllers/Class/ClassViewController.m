//
//  ClassViewController.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ClassViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "NetworkManager.h"
#import "WaitingViewController.h"
#import "Constants.h"
#import "ClassTableViewCell.h"
#import "ScrollViewController.h"
#import "TrackWodViewController.h"

@interface ClassViewController ()<DemoTextFieldDelegate, ClassTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) UIView *waitingView;

@end

@implementation ClassViewController

@synthesize classes;
@synthesize waitingViewController;
@synthesize waitingView;
@synthesize dateTextField;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    
    NSDictionary *transitionData = self.transitions.all[0];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.slidingViewController.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( waitingViewController == nil ) {
        waitingView = [[UIView alloc] initWithFrame:self.view.bounds];
        waitingView.backgroundColor = UIColorFromRGB(0x000000);
        waitingView.alpha = 0.1f;
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingView];
        [self.view addSubview:waitingViewController.view];
        [waitingViewController showWaitingIndicator];
        
        dateTextField.pickerdelegate = self;
        [dateTextField setType:TEXT_FIELD_DATE];
        [dateTextField setDate:[NSDate new]];
    }
}

#pragma mark - Button Actions
- (IBAction)onChangeDate:(id)sender {
    [dateTextField becomeFirstResponder];
}

- (IBAction)onPreviousDay:(id)sender {
    [dateTextField prevDate];
}

- (IBAction)onToday:(id)sender {
    [dateTextField today];
}

- (IBAction)onNextDay:(id)sender {
    [dateTextField nextDate];
}

#pragma mark - DemoTextFieldDelegate
- (void)didChangedDate:(NSDate *)date
{
    NSLog(@"Change Date");
    [waitingView setHidden:NO];
    [waitingViewController showWaitingIndicator];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [df stringFromDate:date];
    [[NetworkManager sharedManager] getClassess:dateString
                        endDate:dateString
                        success:^(NSArray *result) {
                            if ( classes )
                                [classes removeAllObjects];
                            else
                                classes = [[NSMutableArray alloc] init];
                            if ( result != nil && [result isKindOfClass:[NSArray class]] && [result count] > 0 ) {
                                [classes addObjectsFromArray:[result sortedArrayUsingSelector:@selector(compare:)]];
                                [self.tableView reloadData];
                                [waitingViewController.view setHidden:YES];
                                [waitingView setHidden:YES];
                            }
                            else {
                                [waitingView setHidden:YES];
                                [waitingViewController showResult:kMessageNoClasses];
                            }
                        }
                        failure:^(NSString *error) {
                            if ( classes )
                                [classes removeAllObjects];
                            [waitingView setHidden:YES];
                            [waitingViewController showResult:error];
                        }];
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ClassTableViewCell";
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setClass:classes[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [UIScreen mainScreen].bounds.size.width < 350) {
        return 130;
    }
    else
        return 100;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - ClassTableViewCellDelegate
- (void)onTrackWod:(RhinoFitClass *)rhinofitClass {
    ScrollViewController *scrollViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrollViewController"];
    TrackWodViewController *trackWodViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackWodViewController"];
    trackWodViewController.mClass = rhinofitClass;
    trackWodViewController.delegate = scrollViewController;
    [scrollViewController setContentViewController:trackWodViewController];
    [self.navigationController pushViewController:scrollViewController animated:YES];
    [scrollViewController setTitle:@"Track WOD"];
}
@end
