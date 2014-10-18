//
//  ClassViewController.h
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "DemoTextField.h"

@interface ClassViewController : UIViewController<ECSlidingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)menuButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet DemoTextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;

@end
