//
//  BenchmarkSpinnerViewController.m
//  RhinoFit
//
//  Created by Admin on 11/22/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "BenchmarkSpinnerViewController.h"
#import "AvailableBenchmark.h"

@interface BenchmarkSpinnerViewController ()

@end

@implementation BenchmarkSpinnerViewController

@synthesize mBenchmarkArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *layer = self.tableView.layer;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor grayColor].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mBenchmarkArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BenchmarkTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    AvailableBenchmark *availableBenchmark = mBenchmarkArray[indexPath.row];
    [cell.textLabel setText:availableBenchmark.bdescription];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectedBenchmark:mBenchmarkArray[indexPath.row]];
}


@end
