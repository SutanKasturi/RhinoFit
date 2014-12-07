//
//  WallTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wall.h"

#define DEFAULT_WALL_CELL_SIZE1 (CGSize){[[UIScreen mainScreen] bounds].size.width - 96, 244}
#define DEFAULT_WALL_CELL_SIZE2 (CGSize){[[UIScreen mainScreen] bounds].size.width - 96, 86}

@interface WallTableViewCell : UITableViewCell

@property (nonatomic, strong) Wall *mWall;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBackView;
@property (weak, nonatomic) IBOutlet UIView *userBackView;

- (void) setupWallInfo:(Wall*)wall;

@end
