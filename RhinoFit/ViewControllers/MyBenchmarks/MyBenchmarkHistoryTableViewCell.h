//
//  MyBenchmarkHistoryTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BenchmarkHistory.h"

@class MyBenchmarkHistoryTableViewCell;
@protocol MyBenchmarkHistoryTableViewCellDelegate <NSObject>

@required
- (void) onUpdateBenchmark:(MyBenchmarkHistoryTableViewCell*)cell;

@end

@interface MyBenchmarkHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyBenchmarkHistoryTableViewCellDelegate> delegate;

@property (nonatomic, strong) BenchmarkHistory *mHistroy;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (void) setBenchmarkHistory:(BenchmarkHistory*)history;
@end
