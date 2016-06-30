//
//  MenuViewController.h
//  RhinoFit
//
//  Created by Admin on 10/17/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *mAvatarImageView;
//@property (weak, nonatomic) IBOutlet UILabel *mUserNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
