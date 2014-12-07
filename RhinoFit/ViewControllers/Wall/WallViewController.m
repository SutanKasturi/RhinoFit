//
//  WallViewController.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "WallViewController.h"
#import "WaitingViewController.h"
#import "WallTableViewCell.h"
#import "NetworkManager.h"
#import "UIViewController+ECSlidingViewController.h"
#import "TakePhoto.h"
#import "PostWallMessageViewController.h"

@interface WallViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSMutableArray *mWallPostArray;

@end

@implementation WallViewController

@synthesize mWallPostArray;
@synthesize waitingViewController;

- (void) getWallPosts {
    if ( mWallPostArray )
        return;
    
    mWallPostArray = [[NSMutableArray alloc] init];
    [[NetworkManager sharedManager] getWallPosts:^(NSMutableArray *result) {
        if ( mWallPostArray )
            [mWallPostArray removeAllObjects];
        if ( result != nil && [result count] > 0 ) {
            [mWallPostArray addObjectsFromArray:result];
            [self.tableView reloadData];
            [waitingViewController.view setHidden:YES];
        }
        else {
            [waitingViewController showResult:kMessageNoWalls];
        }
    } failure:^(NSString *error) {
        [mWallPostArray removeAllObjects];
        [waitingViewController showResult:error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addWallPostButton setButtonType:CustomButtonBlue];
}

- (void)viewDidAppear:(BOOL)animated {
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
        
        [waitingViewController showWaitingIndicator];
        [self getWallPosts];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mWallPostArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0 )
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyTableViewCell"];
        return cell;
    }
    
    Wall *wall = mWallPostArray[indexPath.row - 1];
    NSString *cellIdentifier;
    if ( wall.yours ) {
        if ( ![wall.pic isEqualToString:@""] ) {
            cellIdentifier = @"WallRightImageTableViewCell";
        }
        else {
            cellIdentifier = @"WallRightTableViewCell";
        }
    }
    else {
        if ( ![wall.pic isEqualToString:@""] ) {
            cellIdentifier = @"WallLeftImageTableViewCell";
        }
        else {
            cellIdentifier = @"WallLeftTableViewCell";
        }
    }

    WallTableViewCell *cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupWallInfo:wall];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0 )
        return 20;
    
    Wall *wall = mWallPostArray[indexPath.row - 1];
    CGSize defaultSize = ![wall.pic isEqualToString:@""]? DEFAULT_WALL_CELL_SIZE1:DEFAULT_WALL_CELL_SIZE2;
    
    
    float width = defaultSize.width - 8;
    CGSize constrainedSize = CGSizeMake(width, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:wall.msg attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0,0, width, requiredHeight.size.height);
    }
    
    return defaultSize.height + requiredHeight.size.height;
}

@end
