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

@interface ClassViewController ()<DemoTextFieldDelegate>

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
                            [self successRequest:kRequestGetClassess result:result];
                        }
                        failure:^(NSString *error) {
                            [self failureRequest:kRequestGetClassess errorMessage:error];
                        }];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    if ( ![action isEqualToString:kRequestGetClassess] )
        return;
    
    if ( obj != nil && [obj isKindOfClass:[NSArray class]]) {
        classes = [[NSMutableArray alloc] initWithArray:obj];
        [self.tableView reloadData];
        [waitingViewController.view setHidden:YES];
        [waitingView setHidden:YES];
    }
    else {
        [waitingView setHidden:YES];
        [waitingViewController showResult:kMessageNoClasses];
    }
}

- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    if ( ![action isEqualToString:kRequestGetClassess] )
        return;
    
    [waitingView setHidden:YES];
    [waitingViewController showResult:errorMessage];
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
@end
