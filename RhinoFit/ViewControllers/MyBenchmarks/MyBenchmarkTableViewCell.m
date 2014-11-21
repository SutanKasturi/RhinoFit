//
//  MyBenchmarkTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyBenchmarkTableViewCell.h"

@implementation MyBenchmarkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onUpdate:(id)sender {
    [self.delegate onUpdateBenchmark:self.mBenchmark];
}
- (IBAction)onHistory:(id)sender {
    [self.delegate onHistoryBenchmark:self];
}

- (void) setBenchmark:(MyBenchmark*)benchmark
{
    self.mBenchmark = benchmark;
    self.titleLabel.text = benchmark.title;
    self.currentScoreLabel.text = [NSString stringWithFormat:@"Current PR: %@ %@", benchmark.currentScore, benchmark.type];
    self.lastScoreLabel.text = [NSString stringWithFormat:@"Last Benchmark: %@ %@", benchmark.lastScore, benchmark.type];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    
    self.currentDateLabel.text = [df stringFromDate:benchmark.currentDate];
    self.lastDateLabel.text = [df stringFromDate:benchmark.lastDate];
}

@end
