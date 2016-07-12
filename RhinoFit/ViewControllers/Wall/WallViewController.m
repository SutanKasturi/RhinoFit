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

@interface WallViewController ()<UITableViewDataSource, UITableViewDelegate, WallTableCellButtonDelegate>

@property (nonatomic, strong) WaitingViewController *waitingViewController;
@property (nonatomic, strong) NSMutableArray *mWallPostArray;

@end

@implementation WallViewController

@synthesize mWallPostArray;
@synthesize waitingViewController;

- (void) getWallPosts {
//    if ( mWallPostArray )
//        return;
//    
//    mWallPostArray = [[NSMutableArray alloc] init];
    [[NetworkManager sharedManager] getWallPosts:^(NSMutableArray *result) {
        if ( mWallPostArray )
            [mWallPostArray removeAllObjects];
        else
            mWallPostArray = [[NSMutableArray alloc] init];
        if ( result != nil && [result count] > 0 ) {
            [mWallPostArray addObjectsFromArray:result];
            [self.tableView reloadData];
            [waitingViewController.view setHidden:YES];
            [self scrollToBottom];
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
    
//    [self.addWallPostButton setButtonType:CustomButtonBlue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWalls:) name:@"AddWalls" object:nil];
}

- (void)refreshWalls:(NSNotification *) notification    {
    waitingViewController = nil;
    [mWallPostArray removeAllObjects];
    [self.tableView reloadData];
    [self loadAllData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadAllData];
}

- (void)loadAllData {
    if ( waitingViewController == nil ) {
        waitingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingViewController"];
        waitingViewController.view.frame = self.tableView.frame;
        [self addChildViewController:waitingViewController];
        [self.view addSubview:waitingViewController.view];
    }
    [waitingViewController showWaitingIndicator];
    [self getWallPosts];
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
    cell.indexPath = indexPath;
    cell.buttonDelegate = self;
    if (!wall.flaggable) {
        [cell.btnFlag setHidden:YES];
    } else {
        [cell.btnFlag setHidden:NO];
    }
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

- (void) onFlagClicked:(NSIndexPath *)indexPath {
    NSLog(@"Flag Button clicked");
    Wall *wall = mWallPostArray[indexPath.row - 1];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure want to report this user for inappropriate content?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *flagAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NetworkManager *networkManage = [NetworkManager sharedManager];
        [networkManage reportWallPost:wall.wallId
                              success:^(BOOL isSuccess) {
                                  if (isSuccess) {
                                      [self getWallPosts];
                                  }
                                  
                              } failure:^(NSString *error) {
                                  
                              }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:flagAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) onDeleteClicked:(NSIndexPath *)indexPath {
    Wall *wall = mWallPostArray[indexPath.row - 1];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure want to Delete this post?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Delete Button clicked %ld", (long)indexPath.row);
        NetworkManager *networkManage = [NetworkManager sharedManager];
        [networkManage deleteWallPost:wall.wallId
                              success:^(BOOL isSuccess) {
                                  if (isSuccess) {
                                      [self getWallPosts];
                                  }
            
        } failure:^(NSString *error) {
            
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[mWallPostArray count] - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
}

@end
