//
//  WallViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "RoundedButton.h"

@interface WallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet RoundedButton *addWallPostButton;

@end
