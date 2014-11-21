//
//  MyBenchmarkHistoryViewController.h
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBenchmarkViewController.h"

@protocol MyBenchmarkHistoryViewControllerDelegate <NSObject>

@optional
- (void) didUpdatedMyBenchmarkHistory;
- (void) removeMyBenchmark;

@end

@interface MyBenchmarkHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<MyBenchmarkHistoryViewControllerDelegate> delegate;

@property (nonatomic, strong) MyBenchmark *mBenchmark;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
