//
//  WallTableViewCell.m
//  RhinoFit
//
//  Created by Admin on 12/5/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "WallTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation WallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
//    self.accessoryType = UITableViewCellAccessoryNone;
//    self.accessoryView = nil;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    // Fix for contentView constraint warning
//    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
}
- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)onFlagButtonClicked:(id)sender {
//    NSLog(@"Flag Button clicked");
    [self.buttonDelegate onFlagClicked:self.indexPath];
}
- (IBAction)onDeleteButtonClicked:(id)sender {
//    NSLog(@"Delete Button clicked");
    [self.buttonDelegate onDeleteClicked:self.indexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setupWallInfo:(Wall*)wall {
    self.mWall = wall;
    self.msgLabel.text = wall.msg;
    self.userNameLabel.text = wall.name;
    [self.markLabel setHidden:NO];
    [self.postImage setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    self.postImage.image = nil;
    NSLog(@"%@", wall.pic);
    [self.postImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wall.pic]]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       self.postImage.image = image;
                                       if ( image ) {
                                           [self.markLabel setHidden:YES];
                                           [self.postImage setBackgroundColor:[UIColor clearColor]];
                                       }
                                       else {
                                           self.postImage.image = wall.picImage;
                                       }
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];
    [self.avatarImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wall.profilePic]]
                            placeholderImage:[UIImage imageNamed:@"avatar"]
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         if ( image )
                                             self.avatarImage.image = image;
                                         else
                                             self.avatarImage.image = [UIImage imageNamed:@"avatar"];
                                     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         
                                     }];
    
    CALayer *layer = self.messageBackView.layer;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.cornerRadius = 5.0f;
    layer.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor;
    layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    if ( wall.yours ) {
        layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:70.0f/255.0f blue:123.0f/255.0f alpha:0.2f].CGColor;
        layer.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:70.0f/255.0f blue:123.0f/255.0f alpha:0.05f].CGColor;
    }
    else {
        layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
        layer.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.05f].CGColor;
    }
    
    self.userBackView.layer.borderWidth = 1.0f;
    self.userBackView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
}

@end
