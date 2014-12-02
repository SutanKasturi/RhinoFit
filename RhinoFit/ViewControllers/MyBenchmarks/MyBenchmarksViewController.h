//
//  MyBenchmarksViewController.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface MyBenchmarksViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CustomButton *addBenchmarkButton;

+ (NSMutableArray*) getAvailableBenchmarks;

@end
