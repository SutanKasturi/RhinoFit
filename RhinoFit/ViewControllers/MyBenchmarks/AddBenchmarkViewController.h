//
//  AddBenchmarkViewController.h
//  RhinoFit
//
//  Created by Admin on 10/30/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBenchmark.h"
#import "DemoTextField.h"
#import "CustomButton.h"

@protocol AddBenchmarkViewControllerDelegate <NSObject>

@required
- (void) didAddedBenchmark:(NSArray*)newBenchmark;

@end

@interface AddBenchmarkViewController : UIViewController

@property (nonatomic, strong) id<AddBenchmarkViewControllerDelegate> delegate;

@property (nonatomic, strong) MyBenchmark *mBenchmark;
@property (weak, nonatomic) IBOutlet UIButton *benchmarkButton;
@property (weak, nonatomic) IBOutlet DemoTextField *benchmarkTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet DemoTextField *measurementTextfield;
@property (weak, nonatomic) IBOutlet CustomButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *measurementLabel;

@end
