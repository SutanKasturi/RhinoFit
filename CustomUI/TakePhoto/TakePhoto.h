//
//  TakePhoto.h
//  2B1S
//
//  Created by Admin on 9/22/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TakePhoto;

@protocol TakePhotoDelegate <NSObject>

@optional
- (void) setImage:(UIImage*)aImage;

@end

@interface TakePhoto : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id<TakePhotoDelegate> actiondelegate;

@property (nonatomic, strong) UIViewController *mParentViewController;
@property (nonatomic, assign) BOOL isAllowEditing;

- (id)init:(UIViewController*)viewController;
- (void) takePhoto;

@end
