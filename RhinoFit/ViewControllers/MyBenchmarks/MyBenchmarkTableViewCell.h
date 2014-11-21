//
//  MyBenchmarkTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBenchmark.h"

@class MyBenchmarkTableViewCell;

@protocol MyBenchmarkTableViewCellDelegate <NSObject>

@required
- (void) onUpdateBenchmark:(MyBenchmark*)benchmark;
- (void) onHistoryBenchmark:(MyBenchmarkTableViewCell*)cell;

@end

@interface MyBenchmarkTableViewCell : UITableViewCell

@property (nonatomic, strong) id<MyBenchmarkTableViewCellDelegate> delegate;

@property (nonatomic, strong) MyBenchmark *mBenchmark;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastDateLabel;

- (void) setBenchmark:(MyBenchmark*)benchmark;

@end
