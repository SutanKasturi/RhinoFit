//
//  TrackWodViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContentViewController.h"
#import "RhinoFitClass.h"
#import "DemoTextField.h"
#import "DemoTextView.h"
#import "CustomButton.h"
#import "ScrollContentDelegate.h"
#import "WodInfo.h"

@protocol TrackWodViewControllerDelegate <NSObject>

@optional
- (void) didChangedWod;

@end

@interface TrackWodViewController : ScrollContentViewController

@property (weak, nonatomic) id<TrackWodViewControllerDelegate> wodDelegate;
@property (weak, nonatomic) id<ScrollContentDelegate> delegate;

@property (nonatomic, strong) RhinoFitClass *mClass;
@property (nonatomic, strong) WodInfo *mWodInfo;

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSDate *startDate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet DemoTextField *titleTextField;
@property (weak, nonatomic) IBOutlet DemoTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet DemoTextView *resultsTextView;
@property (weak, nonatomic) IBOutlet CustomButton *trackWodButton;


@end
