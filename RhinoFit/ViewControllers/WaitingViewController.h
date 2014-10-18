//
//  WaitingViewController.h
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (void) showWaitingIndicator;
- (void) showResult:(NSString*)result;

@end
