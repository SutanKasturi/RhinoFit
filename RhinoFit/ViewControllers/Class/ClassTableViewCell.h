//
//  ClassTableViewCell.h
//  RhinoFit
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RhinoFitClass.h"

@class ClassTableViewCell;

@protocol ClassTableViewCellDelegate <NSObject>

@optional
- (void) reloadCell:(ClassTableViewCell*)cell;
- (void) onTrackWod:(RhinoFitClass*)rhinofitClass;

@end

@interface ClassTableViewCell : UITableViewCell

@property (nonatomic, strong) RhinoFitClass *theClass;

@property (weak, nonatomic) id<ClassTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIButton *trackWodButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void) setClass:(RhinoFitClass*) aClass;
+ (CGSize)findSizeForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+ (CGFloat) getCellHeight:(RhinoFitClass*) aClass;

@end
