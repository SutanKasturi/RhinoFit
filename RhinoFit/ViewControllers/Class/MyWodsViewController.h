//
//  MyWodsViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRMonthPicker/SRMonthPicker.h>

@interface MyWodsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeMonthButton;
@property (weak, nonatomic) IBOutlet SRMonthPicker *monthPicker;

+ (void) setStartDate:(NSDate*)date;

@end
