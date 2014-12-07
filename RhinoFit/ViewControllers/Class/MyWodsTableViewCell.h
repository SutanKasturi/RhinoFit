//
//  MyWodsTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 12/7/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WodInfo.h"

@class MyWodsTableViewCell;
@protocol MyWodsTableViewCellDelegate <NSObject>

@optional
- (void) onEditMyWod:(MyWodsTableViewCell*)cell;

@end


@interface MyWodsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyWodsTableViewCellDelegate> delegate;

@property (nonatomic, strong) WodInfo *mWodInfo;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

- (void) setupWodInfo:(WodInfo*)wodInfo;

@end
