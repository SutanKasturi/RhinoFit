//
//  ScrollContentViewController.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContentDelegate.h"

@interface ScrollContentViewController : UIViewController

@property (weak, nonatomic) id<ScrollContentDelegate> delegate;

@end
