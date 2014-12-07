//
//  ScrollViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContentViewController.h"

@interface ScrollViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ScrollContentViewController *viewController;
- (void) setContentViewController:(ScrollContentViewController*)viewController;

@end
