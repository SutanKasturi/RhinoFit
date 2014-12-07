//
//  PostWallMessageViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface PostWallMessageViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CustomButton *postThisMessageButton;

@end
