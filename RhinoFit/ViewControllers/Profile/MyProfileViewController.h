//
//  MyProfileViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface MyProfileViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet CustomButton *updateMyProfileButton;

@end
