//
//  MyProfileContentViewController.h
//  RhinoFit
//
//  Created by Admin on 12/6/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyProfileContentViewControllerDelegate <NSObject>

@optional
- (void) didChangeContentHeight:(CGFloat)height;

@end

@interface MyProfileContentViewController : UIViewController

@property (nonatomic, weak) id<MyProfileContentViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end
