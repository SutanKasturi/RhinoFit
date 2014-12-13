//
//  MenuViewController.m
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MenuViewController.h"
#import "NetworkManager.h"
#import "UserInfo.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "MenuTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyWodsViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UserInfo *currentUser;
@property (nonatomic, strong) NSArray *menuItems;
//@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end

@implementation MenuViewController

@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];

    NetworkManager *networkManager = [NetworkManager sharedManager];
    currentUser = [networkManager getUser];
    if ( currentUser != nil )
        [self displayUserInfo];
    else
        [networkManager getUserInfo:^(id result) {
                                [self successRequest:kRequestGetUserInfo result:result];
                            }
                            failure:^(NSString *error) {
                                [self failureRequest:kRequestGetUserInfo errorMessage:error];
                            }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:kNotificationUpdateProfile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMyWods) name:kNotificationMyWods object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self displayUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationUpdateProfile];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationMyWods];
}

- (void) displayUserInfo
{
    UserInfo *userInfo = [[NetworkManager sharedManager] getUser];
    self.mUserNameLabel.text = userInfo.userEmail;
    [self.mAvatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userInfo.userPicture]]
                                 placeholderImage:[UIImage imageNamed:@"avatar"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              if ( image )
                                                  self.mAvatarImageView.image = image;
                                          }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              
                                          }];
}

- (void) onMyWods {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWodsNavigationController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - NetworkManagerDelegate

- (void) successRequest:(NSString *)action result:(id)obj
{
    if ( ![action isEqualToString:kRequestGetUserInfo] )
        return;
    
    if ( obj != nil ) {
        currentUser = [[NetworkManager sharedManager] getUser];
        [self displayUserInfo];
    }
}

- (void) failureRequest:(NSString *)action errorMessage:(NSString *)errorMessage
{
    if ( ![action isEqualToString:kRequestGetUserInfo] )
        return;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[kMenuClasses, kMenuMyReservations, kMenuMyAttendance, kMenuMyWods, kMenuMyBenchmarks, kMenuMyMemberships, kMenuWall, kMenuMyProfile, kMenuLogout];
    
    return _menuItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.menuLabel.text = menuItem;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);

    if ([menuItem isEqualToString:kMenuClasses]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyReservations]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservationNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyAttendance]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyWods]) {
        [MyWodsViewController setStartDate:[NSDate new]];
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWodsNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyBenchmarks]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBenchmarksNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyMemberships]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyMembershipsNavigationController"];
    } else if ([menuItem isEqualToString:kMenuWall]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WallNavigationController"];
    } else if ([menuItem isEqualToString:kMenuMyProfile]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileNavigationController"];
    } else if ([menuItem isEqualToString:kMenuLogout]) {
        [[NetworkManager sharedManager] deleteUser];
//        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        AppDelegate *app = [[UIApplication sharedApplication] delegate];
//        app.window.rootViewController = viewController;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}


@end
