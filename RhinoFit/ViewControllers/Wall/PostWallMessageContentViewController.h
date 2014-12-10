//
//  PostWallMessageContentViewController.h
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextView.h"
#import "ScrollContentDelegate.h"
#import "Wall.h"

@protocol PostWallMessageContentViewControllerDelegate <NSObject>

@optional
- (void) didPostMessage:(Wall*)newWall;

@end

@interface PostWallMessageContentViewController : UIViewController

@property (weak, nonatomic) id<PostWallMessageContentViewControllerDelegate> delegate;
@property (weak, nonatomic) id<ScrollContentDelegate> scrollDelegate;

@property (weak, nonatomic) IBOutlet DemoTextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

- (void) postThisMessage;

@end
