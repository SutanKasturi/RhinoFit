//
//  DemoTextView.h
//  HeadCount
//
//  Created by admin on 3/2/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DemoTextView : UITextView<UITextViewDelegate>

@property (nonatomic, setter = setRequired:) BOOL required;

- (BOOL) validate;

@end
