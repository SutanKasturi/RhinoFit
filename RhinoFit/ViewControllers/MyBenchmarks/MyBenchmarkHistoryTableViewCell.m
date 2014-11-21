//
//  MyBenchmarkHistoryTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 11/21/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MyBenchmarkHistoryTableViewCell.h"

@implementation MyBenchmarkHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onUpdate:(id)sender {
    [self.delegate onUpdateBenchmark:self];
}

- (void) setBenchmarkHistory:(BenchmarkHistory*)history {
    self.mHistroy = history;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    self.dateLabel.text = [df stringFromDate:history.date];
    self.valueLabel.text = history.value;
}
@end
