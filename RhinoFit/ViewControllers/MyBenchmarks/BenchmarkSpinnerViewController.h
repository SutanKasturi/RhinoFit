//
//  BenchmarkSpinnerViewController.h
//  RhinoFit
//
//  Created by Admin on 11/22/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AvailableBenchmark;

@protocol BenchmarkSpinnerViewControllerDelegate <NSObject>

@required
- (void) didSelectedBenchmark:(AvailableBenchmark*)availableBenchmark;

@end

@interface BenchmarkSpinnerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<BenchmarkSpinnerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *mBenchmarkArray;

@end
